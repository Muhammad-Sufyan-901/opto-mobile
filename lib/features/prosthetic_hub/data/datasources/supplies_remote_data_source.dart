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
import 'package:collection/collection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';

/// Contract for the supplies remote data source.
abstract class SuppliesRemoteDataSource {
  /// Returns all active supply products (excluding prostheses), ordered by
  /// ascending price.
  Future<List<SupplyProduct>> getProducts();

  /// Places an order for every item in [cart].
  ///
  /// [cart] maps productId → quantity.
  /// [products] is the full catalog list used to look up prices and metadata.
  /// [consentGiven] must be `true`; it is persisted on the order row for audit.
  Future<void> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required bool consentGiven,
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
  Future<void> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required bool consentGiven,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthFailure('Sesi tidak ditemukan. Silakan masuk kembali.');
    }

    // Build one order row per cart line item.
    final rows = <Map<String, dynamic>>[];
    for (final entry in cart.entries) {
      final product = products.firstWhereOrNull((p) => p.id == entry.key);
      if (product == null) continue;
      rows.add({
        'user_id': userId,
        'product_id': product.id,
        'status': 'draft',
        'consent_given': consentGiven,
        'total_idr': product.priceIdr * entry.value,
      });
    }

    // Nothing to insert — cart contained only unrecognised product IDs.
    if (rows.isEmpty) return;

    try {
      await _client.from('prosthetic_orders').insert(rows);
    } on PostgrestException catch (e) {
      throw SupabaseErrorMapper.fromPostgrest(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
