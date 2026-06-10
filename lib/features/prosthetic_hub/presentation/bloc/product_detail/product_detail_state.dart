// ProductDetail states for [ProductDetailBloc].
//
// Uses `freezed` for immutable, sealed state classes.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_product_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/vendor_entity.dart';

part 'product_detail_state.freezed.dart';

@freezed
sealed class ProductDetailState with _$ProductDetailState {
  /// Initial state — product not yet loaded.
  const factory ProductDetailState.initial() = ProductDetailInitial;

  /// Product detail fetch in progress.
  const factory ProductDetailState.loading() = ProductDetailLoading;

  /// Product (and optional vendor) loaded successfully.
  const factory ProductDetailState.loaded({
    required ProstheticProductEntity product,
    VendorEntity? vendor,
  }) = ProductDetailLoaded;

  /// Product detail fetch failed with [message].
  const factory ProductDetailState.error(String message) = ProductDetailError;
}
