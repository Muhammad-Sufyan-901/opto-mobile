// Abstract repository contract for the Order Supplies feature.
//
// Implementations live in `data/repositories/`.

import 'package:opto/features/prosthetic_hub/domain/entities/checkout_details.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/order_result.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';

/// Contract for retrieving prosthetic supply products and placing orders.
///
/// The production implementation ([SuppliesRepositoryImpl]) is backed by
/// Supabase. A mock implementation ([SuppliesRepositoryMock]) is available
/// for testing.
abstract class SuppliesRepository {
  /// Returns all available supply products.
  Future<List<SupplyProduct>> getProducts();

  /// Places an order for the items in [cart] with the given checkout [details].
  ///
  /// [cart] maps productId (String) → quantity (int).
  /// [products] is the full catalog list used to look up prices and UUIDs.
  /// [details] carries shipping address and payment method.
  ///
  /// Returns an [OrderResult] with the total, payment method, and — for
  /// virtual-account orders — a generated VA number and bank name.
  ///
  /// Throws a [Failure] on error.
  Future<OrderResult> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required CheckoutDetails details,
  });
}
