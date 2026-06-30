// States for [OrderSuppliesCubit].
//
// Uses `freezed` for immutable, sealed state classes — mirrors the pattern
// in the care guides and consultation feature cubits.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/order_result.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';

part 'order_supplies_state.freezed.dart';

@freezed
sealed class OrderSuppliesState with _$OrderSuppliesState {
  /// No data loaded yet; initial state.
  const factory OrderSuppliesState.initial() = OrderSuppliesInitial;

  /// Data fetch is in progress.
  const factory OrderSuppliesState.loading() = OrderSuppliesLoading;

  /// Products loaded; user may browse and add items to the cart.
  ///
  /// [products] — full product list.
  /// [cart] — maps productId → quantity (only keys with qty > 0 are present).
  const factory OrderSuppliesState.catalog({
    required List<SupplyProduct> products,
    required Map<String, int> cart,
  }) = OrderSuppliesCatalog;

  /// Order submission is in progress.
  const factory OrderSuppliesState.submitting({
    required List<SupplyProduct> products,
    required Map<String, int> cart,
  }) = OrderSuppliesSubmitting;

  /// Order was placed successfully.
  ///
  /// [result] carries the total, payment method, and — for VA orders — the
  /// generated virtual account number and bank name.
  const factory OrderSuppliesState.confirmed(OrderResult result) =
      OrderSuppliesConfirmed;

  /// An error occurred (loading or submitting).
  const factory OrderSuppliesState.error(String message) = OrderSuppliesError;
}
