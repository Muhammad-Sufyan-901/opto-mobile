// Catalog events for [CatalogBloc].
//
// Uses `freezed` for immutable, sealed event classes.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';

part 'catalog_event.freezed.dart';

@freezed
sealed class CatalogEvent with _$CatalogEvent {
  /// Load (or reload) the catalog, optionally filtered.
  ///
  /// Passing `null` for all filters returns the full active catalog.
  const factory CatalogEvent.loadCatalog({
    ProductType? typeFilter,
    String? irisColorFilter,
    String? sizeFilter,
  }) = LoadCatalog;

  /// Load a single product and its vendor by [productId].
  const factory CatalogEvent.loadProduct(String productId) = LoadProduct;
}
