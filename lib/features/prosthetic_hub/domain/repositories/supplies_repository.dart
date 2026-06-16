// Abstract repository contract for the Order Supplies feature.
//
// Implementations live in `data/repositories/`.

import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';

/// Contract for retrieving prosthetic supply products.
///
/// A mock implementation ([SuppliesRepositoryMock]) is used during the
/// current development phase. A real Supabase-backed implementation will
/// replace it once the backend table is provisioned.
abstract class SuppliesRepository {
  /// Returns all available supply products.
  Future<List<SupplyProduct>> getProducts();

  /// Places an order for the items in [cart].
  ///
  /// [cart] maps productId (String) → quantity (int).
  /// [products] is the full catalog list used to look up prices and UUIDs.
  /// [consentGiven] must be `true` for the order to be submitted.
  ///
  /// Throws a [Failure] on error.
  Future<void> placeOrder({
    required Map<String, int> cart,
    required List<SupplyProduct> products,
    required bool consentGiven,
  });
}
