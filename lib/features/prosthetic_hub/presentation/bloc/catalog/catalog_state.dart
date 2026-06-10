// Catalog states for [CatalogBloc].
//
// Uses `freezed` for immutable, sealed state classes.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_product_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/vendor_entity.dart';

part 'catalog_state.freezed.dart';

@freezed
sealed class CatalogState with _$CatalogState {
  /// Initial state — catalog not yet loaded.
  const factory CatalogState.initial() = CatalogInitial;

  /// Catalog operation in progress.
  const factory CatalogState.loading() = CatalogLoading;

  /// Catalog list loaded successfully.
  const factory CatalogState.loaded(
    List<ProstheticProductEntity> products,
  ) = CatalogLoaded;

  /// Single product (and optional vendor) loaded successfully.
  const factory CatalogState.productLoaded({
    required ProstheticProductEntity product,
    VendorEntity? vendor,
  }) = ProductLoaded;

  /// Catalog operation failed with [message].
  const factory CatalogState.error(String message) = CatalogError;
}
