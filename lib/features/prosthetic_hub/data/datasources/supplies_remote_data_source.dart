// Remote data source for the `prosthetic_hub` supplies feature.
//
// This is the ONLY place in the supplies feature that calls
// `SupabaseClientProvider.client` directly.
// Callers (repository impls) must never import this file from the domain layer.
//
// SECURITY NOTES:
// - Never join 🔒 tables (anthropometric_data, eye_photos, consultations,
//   sos_events) into product catalog or order queries here.
// - `prosthetic_orders` 🔒 writes are scoped to the authenticated user_id —
//   the `user_id` filter is a client-side defence-in-depth guard; RLS on
//   `prosthetic_orders` is the authoritative boundary.
// - Use only `SupabaseClientProvider.client` — never `Supabase.instance.client`
//   directly.
// - Image URLs are resolved via `SupabaseStorage.getPublicUrl` (synchronous);
//   no additional auth is required for the `product-images` public bucket.
// - `virtual_account_no` is owner-sensitive data — never expose it outside an
//   authenticated, owner-scoped query.
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/checkout_details.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/order_result.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';

/// Contract for the supplies remote data source.
abstract class SuppliesRemoteDataSource {
  /// Returns all active supply products (excluding prostheses), ordered by
  /// ascending price.
  Future<List<SupplyProduct>> getProducts();

  /// Places an order for every item in [cart] with the given [details].
  ///
  /// [cart] maps productId → quantity.
  /// [products] is the full catalog list used to look up prices and metadata.
  /// [details] carries shipping address and payment method.
  ///
  /// Returns an [OrderResult]; for VA orders this includes a generated
  /// virtual account number and bank name.
  Future<OrderResult> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required CheckoutDetails details,
  });
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by Supabase PostgREST.
///
/// All [PostgrestException]s are mapped to typed [Failure]s via
/// [SupabaseErrorMapper.fromPostgrest] before being rethrown.
class SuppliesRemoteDataSourceImpl implements SuppliesRemoteDataSource {
  SupabaseClient get _client => SupabaseClientProvider.client;

  // CATALOG ─────────────────────────────────────────────────────────────────

  @override
  Future<List<SupplyProduct>> getProducts() async {
    try {
      final rows = await _client
          .from('prosthetic_products')
          .select()
          .eq('is_active', true)
          .neq('type', 'prosthesis')
          .order('price_idr');
      return rows.map(_rowToProduct).toList();
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// Maps a raw Supabase row to a [SupplyProduct] domain entity.
  ///
  /// If the row contains a non-null `image_path`, a public storage URL is
  /// resolved from the `product-images` bucket (synchronous — no await).
  SupplyProduct _rowToProduct(Map<String, dynamic> row) {
    final imagePath = row['image_path'] as String?;
    final imageUrl = imagePath != null
        ? _client.storage.from('product-images').getPublicUrl(imagePath)
        : null;
    return SupplyProduct(
      id: row['id'] as String,
      name: row['name'] as String,
      type: supplyProductTypeFromDb(row['type'] as String),
      audioDescription: row['audio_description'] as String,
      priceIdr: row['price_idr'] as int,
      isCustom: row['is_custom'] as bool,
      imageUrl: imageUrl,
    );
  }

  // ORDERS 🔒 ───────────────────────────────────────────────────────────────
  // These methods write to `prosthetic_orders` which is owner-only (RLS).
  // Never reference this table from catalog, map, or community queries.

  @override
  Future<OrderResult> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required CheckoutDetails details,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('Sesi tidak ditemukan. Silakan masuk kembali.');
    }

    // One UUID groups all line-item rows belonging to this checkout together.
    final groupId = _generateUuidV4();

    // For VA orders, generate a mock virtual account number once and reuse it
    // for every row in this checkout group. COD orders have no VA number.
    final String? vaNumber =
        details.paymentMethod == PaymentMethod.virtualAccount
            ? _generateVaNumber()
            : null;

    // Compute the grand total across all cart lines.
    int grandTotal = 0;
    final rows = <Map<String, dynamic>>[];
    for (final entry in cart.entries) {
      final product = products.firstWhereOrNull((p) => p.id == entry.key);
      if (product == null) continue;
      final lineTotal = product.priceIdr * entry.value;
      grandTotal += lineTotal;
      final row = <String, dynamic>{
        'user_id': userId,
        'product_id': product.id,
        'status': 'submitted', // advance past 'draft' on confirmed checkout
        'consent_given': true,
        'total_idr': lineTotal,
        // Payment + shipping columns (from migration 20260630000000)
        'order_group_id': groupId,
        'payment_method': details.paymentMethod.dbValue,
        'payment_status': 'pending',
        'recipient_name': details.recipientName,
        'recipient_phone': details.recipientPhone,
        'shipping_address': details.shippingAddress,
        'shipping_city': details.shippingCity,
        'shipping_postal_code': details.shippingPostalCode,
      };
      if (vaNumber != null) row['virtual_account_no'] = vaNumber;
      rows.add(row);
    }

    // Nothing to insert — cart contained only unrecognised product IDs.
    if (rows.isEmpty) {
      throw const ServerFailure('Keranjang kosong atau produk tidak ditemukan.');
    }

    try {
      await _client.from('prosthetic_orders').insert(rows);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }

    return OrderResult(
      method: details.paymentMethod,
      totalIdr: grandTotal,
      virtualAccountNo: vaNumber,
      bankName: vaNumber != null ? 'BCA' : null,
    );
  }

  // PRIVATE HELPERS ─────────────────────────────────────────────────────────

  /// Generates a RFC-4122 UUID v4 string using a cryptographically-secure RNG.
  /// Used to group multi-product checkout rows under one [order_group_id].
  String _generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    // Set version (4) and variant bits per RFC-4122 §4.4.
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex =
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  /// Generates a mock BCA virtual account number: fixed prefix 8808 followed
  /// by 12 random digits.
  ///
  /// In a production integration this would be replaced by a call to an Edge
  /// Function (`order-confirm`) that contacts the payment provider (e.g.
  /// Midtrans/Xendit) and returns a real VA number.
  String _generateVaNumber() {
    final random = Random.secure();
    final suffix =
        List.generate(12, (_) => random.nextInt(10)).join();
    return '8808$suffix';
  }
}
