// Screen: Order Supplies catalog
//
// Displays the supply product catalog, allows the user to add / remove items
// from the cart, and navigates to [SupplyOrderSummaryScreen] for confirmation.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/widgets/buttons/app_button.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/order_supplies_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/supply_product_card.dart';

/// Screen: Order Supplies catalog (Prosthetic Hub sub-flow).
///
/// Outer widget creates the [BlocProvider]; inner [StatefulWidget] handles
/// accessibility announcements and UI state.
class OrderSuppliesScreen extends StatelessWidget {
  const OrderSuppliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderSuppliesCubit>(
      create: (_) => sl<OrderSuppliesCubit>()..loadCatalog(),
      child: const _OrderSuppliesView(),
    );
  }
}

class _OrderSuppliesView extends StatefulWidget {
  const _OrderSuppliesView();

  @override
  State<_OrderSuppliesView> createState() => _OrderSuppliesViewState();
}

class _OrderSuppliesViewState extends State<_OrderSuppliesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Order supplies.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocListener<OrderSuppliesCubit, OrderSuppliesState>(
          listener: (context, state) {
            if (state is OrderSuppliesConfirmed) {
              HapticPatterns.success();
              announce(
                context,
                'Order placed. Your supplies will be delivered soon.',
              );
              context.pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              top: 16,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProstheticHeader(title: 'Order Supplies'),
                const SizedBox(height: AppDimensions.space16),
                Expanded(
                  child: BlocBuilder<OrderSuppliesCubit, OrderSuppliesState>(
                    builder: (context, state) {
                      return switch (state) {
                        OrderSuppliesInitial() ||
                        OrderSuppliesLoading() =>
                          const Center(child: CircularProgressIndicator()),
                        OrderSuppliesCatalog(:final products, :final cart) =>
                          _CatalogView(products: products, cart: cart),
                        OrderSuppliesSubmitting() =>
                          const Center(child: CircularProgressIndicator()),
                        OrderSuppliesConfirmed() =>
                          // Handled by BlocListener (pops). Show spinner briefly.
                          const Center(child: CircularProgressIndicator()),
                        OrderSuppliesError(:final message) =>
                          _ErrorView(message: message),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Scrollable catalog list with a sticky "Review Order" button at the bottom.
class _CatalogView extends StatelessWidget {
  const _CatalogView({required this.products, required this.cart});

  final List<dynamic> products;
  final Map<String, int> cart;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderSuppliesCubit>();

    final int totalItems = cart.values.fold(0, (sum, qty) => sum + qty);
    final bool cartIsEmpty = totalItems == 0;

    final String buttonLabel = cartIsEmpty
        ? 'Review Order'
        : 'Review Order ($totalItems item${totalItems == 1 ? "" : "s"})';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < products.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppDimensions.space12),
                  SupplyProductCard(
                    product: products[i],
                    qty: cart[products[i].id] ?? 0,
                    onAdd: () => cubit.addToCart(products[i].id),
                    onRemove: () => cubit.removeFromCart(products[i].id),
                  ),
                ],
                const SizedBox(height: AppDimensions.space24),
              ],
            ),
          ),
        ),
        AppButton.primary(
          text: buttonLabel,
          onPressed: cartIsEmpty
              ? null
              : () {
                  final state = context.read<OrderSuppliesCubit>().state;
                  if (state is OrderSuppliesCatalog) {
                    context.push(
                      '/prosthetic-hub/order-supplies/summary',
                      extra: state,
                    );
                  }
                },
        ),
      ],
    );
  }
}

/// Centered error message with a "Retry" button.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Semantics(
              button: true,
              label: 'Retry loading supplies',
              child: TextButton(
                onPressed: () =>
                    context.read<OrderSuppliesCubit>().loadCatalog(),
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
