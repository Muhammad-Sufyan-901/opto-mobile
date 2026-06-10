// Domain-layer contract for catalog read operations.
//
// Depends only on pure-Dart entities and enums — no Supabase or data-layer
// imports allowed here.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_product_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/vendor_entity.dart';

/// Read-only catalog repository contract.
///
/// Implementations live in `data/repositories/catalog_repository_impl.dart`.
/// BLoC and use-case classes depend on this abstract contract — never on the
/// implementation class — so the data source can be swapped without touching
/// the presentation layer.
abstract class CatalogRepository {
  /// Returns all active catalog products, with optional filters.
  ///
  /// [typeFilter] — restrict to a single [ProductType].
  /// [irisColorFilter] — restrict to a specific iris colour string.
  /// [sizeFilter] — restrict to a specific size code / label.
  ///
  /// Throws a [Failure] on network / RLS / parse errors.
  Future<List<ProstheticProductEntity>> getProducts({
    ProductType? typeFilter,
    String? irisColorFilter,
    String? sizeFilter,
  });

  /// Returns a single product by [id].
  ///
  /// Throws [ServerFailure('Product not found')] when no row matches.
  Future<ProstheticProductEntity> getProductById(String id);

  /// Returns a vendor by [vendorId], or `null` if the vendor does not exist.
  ///
  /// Vendors are optional on products (`vendor_id` is nullable) — so callers
  /// must handle the null case gracefully.
  Future<VendorEntity?> getVendor(String vendorId);
}
