// Screen: Order Supplies catalog (M3 redesign)
//
// Inline live summary card (Subtotal / Delivery Free / Total) + sticky
// bottom bar with Total and Checkout button — matching design A4.
// "Checkout" still navigates to the existing SupplyOrderSummaryScreen
// which calls confirmOrder(). All cubit/state/routing logic unchanged.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/currency_formatter.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/order_supplies_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/supply_product_card.dart';

/// Screen: Order Supplies catalog (Prosthetic Hub sub-flow).
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.screenPadding,
                right: AppDimensions.screenPadding,
                top: 16,
              ),
              child: const ProstheticHeader(title: 'Order Supplies'),
            ),
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
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Product list + inline summary card + sticky bottom bar.
class _CatalogView extends StatelessWidget {
  const _CatalogView({required this.products, required this.cart});

  final List<SupplyProduct> products;
  final Map<String, int> cart;

  int get _subtotal {
    int total = 0;
    for (final entry in cart.entries) {
      final product = products.where((p) => p.id == entry.key).firstOrNull;
      if (product != null) total += product.priceIdr * entry.value;
    }
    return total;
  }

  int get _totalItems => cart.values.fold(0, (sum, qty) => sum + qty);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color green = ext?.green ?? cs.tertiary;

    final cubit = context.read<OrderSuppliesCubit>();
    final bool cartIsEmpty = _totalItems == 0;
    final int subtotal = _subtotal;
    final String totalFormatted = 'Rp ${formatRupiah(subtotal)}';

    return Column(
      children: [
        // ── Scrollable catalog ─────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
            ),
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

                const SizedBox(height: AppDimensions.space16),

                // ── Inline summary card ──────────────────────────────────
                if (!cartIsEmpty)
                  Semantics(
                    label: 'Order summary. Subtotal $totalFormatted. Delivery free. Total $totalFormatted.',
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge - 4),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 4),
                        border: Border.all(color: line, width: 1.5),
                      ),
                      child: ExcludeSemantics(
                        child: Column(
                          children: [
                            _SumRow(
                              label: 'Subtotal',
                              value: totalFormatted,
                            ),
                            const SizedBox(height: 11),
                            _SumRow(
                              label: 'Delivery',
                              value: 'Free',
                              valueColor: green,
                            ),
                            const SizedBox(height: 4),
                            Divider(color: line, thickness: 1.5),
                            const SizedBox(height: 4),
                            _SumRow(
                              label: 'Total',
                              value: totalFormatted,
                              bold: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppDimensions.space24),
              ],
            ),
          ),
        ),

        // ── Sticky bottom bar ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(top: BorderSide(color: line, width: 1.5)),
          ),
          child: Row(
            children: [
              // Total label + value
              ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      cartIsEmpty ? 'Rp 0' : totalFormatted,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Checkout button
              Expanded(
                child: Semantics(
                  button: true,
                  label: cartIsEmpty
                      ? 'Checkout. Add items to your cart first.'
                      : 'Checkout. $_totalItems item${_totalItems == 1 ? "" : "s"}. Total $totalFormatted.',
                  child: SizedBox(
                    height: AppDimensions.buttonHeight,
                    child: FilledButton.icon(
                      onPressed: cartIsEmpty
                          ? null
                          : () {
                              final state =
                                  context.read<OrderSuppliesCubit>().state;
                              if (state is OrderSuppliesCatalog) {
                                context.push(
                                  AppRoutes.prostheticOrderSummary.path,
                                  extra: {
                                    'catalogState': state,
                                    'cubit': context
                                        .read<OrderSuppliesCubit>(),
                                  },
                                );
                              }
                            },
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      label: const Text('Checkout'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          AppDimensions.buttonHeight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A single summary row (label + value).
class _SumRow extends StatelessWidget {
  const _SumRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = bold
        ? Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w800,
            )
        : Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: base),
        Text(
          value,
          style: base.copyWith(
            color: valueColor ?? base.color,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
          ),
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
