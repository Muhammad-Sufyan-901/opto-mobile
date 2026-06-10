// ProductDetail events for [ProductDetailBloc].
//
// Uses `freezed` for immutable, sealed event classes.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_detail_event.freezed.dart';

@freezed
sealed class ProductDetailEvent with _$ProductDetailEvent {
  /// Load a single product and its vendor by [productId].
  const factory ProductDetailEvent.load(String productId) =
      ProductDetailLoad;
}
