// Cubit for the Order Supplies flow.
//
// Drives catalog browsing, cart management, and order submission for
// [OrderSuppliesScreen] and [SupplyOrderSummaryScreen].
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/supplies_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/order_supplies_state.dart';

export 'order_supplies_state.dart';

/// Cubit that drives the Order Supplies flow.
///
/// Lifecycle:
/// 1. Call [loadCatalog] once after construction (inside `BlocProvider.create`)
///    to trigger the data fetch.
/// 2. Use [addToCart] / [removeFromCart] while browsing the catalog.
/// 3. Call [confirmOrder] from the summary screen to simulate order placement.
class OrderSuppliesCubit extends Cubit<OrderSuppliesState> {
  OrderSuppliesCubit(this._repo) : super(const OrderSuppliesState.initial());

  final SuppliesRepository _repo;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Fetches all supply products and emits [OrderSuppliesCatalog] on success.
  ///
  /// Emits [OrderSuppliesLoading] first, then either [OrderSuppliesCatalog] or
  /// [OrderSuppliesError]. The [isClosed] guard ensures we never emit after the
  /// cubit has been disposed.
  Future<void> loadCatalog() async {
    emit(const OrderSuppliesState.loading());
    try {
      final products = await _repo.getProducts();
      if (!isClosed) {
        emit(OrderSuppliesState.catalog(products: products, cart: const {}));
      }
    } on Exception catch (e) {
      if (!isClosed) {
        emit(
          OrderSuppliesState.error(
            e.toString().replaceAll('Exception: ', ''),
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          const OrderSuppliesState.error(
            'Something went wrong. Please try again.',
          ),
        );
      }
    }
  }

  /// Increments the quantity of [productId] in the cart by 1.
  ///
  /// No-op unless the current state is [OrderSuppliesCatalog].
  void addToCart(String productId) {
    final state = this.state;
    if (state is! OrderSuppliesCatalog) return;

    final updatedCart = Map<String, int>.from(state.cart);
    updatedCart[productId] = (updatedCart[productId] ?? 0) + 1;

    emit(OrderSuppliesState.catalog(
      products: state.products,
      cart: updatedCart,
    ));
  }

  /// Decrements the quantity of [productId] in the cart by 1.
  ///
  /// Removes the key when the quantity reaches 0.
  /// No-op unless the current state is [OrderSuppliesCatalog].
  void removeFromCart(String productId) {
    final state = this.state;
    if (state is! OrderSuppliesCatalog) return;

    final updatedCart = Map<String, int>.from(state.cart);
    final currentQty = updatedCart[productId] ?? 0;

    if (currentQty <= 1) {
      updatedCart.remove(productId);
    } else {
      updatedCart[productId] = currentQty - 1;
    }

    emit(OrderSuppliesState.catalog(
      products: state.products,
      cart: updatedCart,
    ));
  }

  /// Simulates placing an order.
  ///
  /// Only works when the current state is [OrderSuppliesCatalog] with a
  /// non-empty cart. Emits [OrderSuppliesSubmitting] → [OrderSuppliesConfirmed].
  /// The [isClosed] guard protects each emit.
  Future<void> confirmOrder() async {
    final state = this.state;
    if (state is! OrderSuppliesCatalog) return;
    if (state.cart.isEmpty) return;

    if (!isClosed) {
      emit(OrderSuppliesState.submitting(
        products: state.products,
        cart: state.cart,
      ));
    }

    // Simulate async network call.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!isClosed) {
      emit(const OrderSuppliesState.confirmed());
    }
  }
}
