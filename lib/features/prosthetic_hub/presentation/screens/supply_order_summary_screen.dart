// Screen: Supply Order Summary
//
// Shows the order line items and total, reads the summary aloud on entry, and
// lets the user confirm (place) the order via [OrderSuppliesCubit.confirmOrder].
// The cubit instance is passed in via GoRouter's `extra` map so the same cubit
// that owns the cart is used for submission — ensuring [OrderSuppliesSubmitting]
// and [OrderSuppliesConfirmed] states are properly exercised.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/currency_formatter.dart';
import 'package:opto/core/widgets/buttons/app_button.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/order_supplies_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Screen: Order Summary (Prosthetic Hub — Order Supplies sub-flow).
///
/// Receives a `Map<String, dynamic>` via `GoRouterState.of(context).extra`
/// with keys:
///   - `'catalogState'`: [OrderSuppliesCatalog] — products + cart snapshot
///   - `'cubit'`: [OrderSuppliesCubit] — the live cubit from the catalog screen
class SupplyOrderSummaryScreen extends StatelessWidget {
  const SupplyOrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra =
        GoRouterState.of(context).extra as Map<String, dynamic>;
    final catalogState = extra['catalogState'] as OrderSuppliesCatalog;
    final cubit = extra['cubit'] as OrderSuppliesCubit;
    return BlocProvider<OrderSuppliesCubit>.value(
      value: cubit,
      child: _SummaryView(catalogState: catalogState),
    );
  }
}

class _SummaryView extends StatefulWidget {
  const _SummaryView({required this.catalogState});

  final OrderSuppliesCatalog catalogState;

  @override
  State<_SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<_SummaryView> {
  List<_LineItem> get _lineItems {
    final items = <_LineItem>[];
    for (final entry in widget.catalogState.cart.entries) {
      final product = widget.catalogState.products.firstWhere(
        (p) => p.id == entry.key,
        orElse: () => throw StateError('Product ${entry.key} not found'),
      );
      items.add(_LineItem(product: product, qty: entry.value));
    }
    return items;
  }

  int get _totalItems =>
      widget.catalogState.cart.values.fold(0, (sum, qty) => sum + qty);

  int get _totalPrice {
    int total = 0;
    for (final entry in widget.catalogState.cart.entries) {
      final product = widget.catalogState.products.firstWhere(
        (p) => p.id == entry.key,
        orElse: () => throw StateError('Product ${entry.key} not found'),
      );
      total += product.priceIdr * entry.value;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(
        context,
        'Order summary. $_totalItems item${_totalItems == 1 ? "" : "s"}. '
        'Total Rp ${formatRupiah(_totalPrice)}. '
        'Double tap confirm to place your order.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    final lineItems = _lineItems;
    final totalPrice = _totalPrice;

    return BlocListener<OrderSuppliesCubit, OrderSuppliesState>(
      listener: (context, state) {
        if (state is OrderSuppliesConfirmed) {
          HapticPatterns.success();
          announce(
            context,
            'Order confirmed. Your supplies will arrive in 3–5 days.',
          );
          context.go('/prosthetic-hub');
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
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
                const ProstheticHeader(title: 'Order Summary'),
                const SizedBox(height: AppDimensions.space24),

                // ── Line items ────────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Items list
                        for (final item in lineItems) ...[
                          _OrderLineItem(
                            item: item,
                            formatPrice: formatRupiah,
                          ),
                          const SizedBox(height: AppDimensions.space12),
                        ],

                        // Divider before total
                        Divider(color: line, thickness: 1.5),

                        const SizedBox(height: AppDimensions.space12),

                        // Total row
                        Semantics(
                          label: 'Total: Rp ${formatRupiah(totalPrice)}',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ExcludeSemantics(
                                child: Text(
                                  'Total',
                                  style:
                                      theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                              ExcludeSemantics(
                                child: Text(
                                  'Rp ${formatRupiah(totalPrice)}',
                                  style:
                                      theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppDimensions.space32),

                        // ── Consent notice ─────────────────────────────────
                        Text(
                          'By confirming, you consent to this order. '
                          'The summary above will be read aloud for your review.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppDimensions.space24),
                      ],
                    ),
                  ),
                ),

                // ── Confirm button ────────────────────────────────────────────
                BlocBuilder<OrderSuppliesCubit, OrderSuppliesState>(
                  builder: (context, state) {
                    return AppButton.primary(
                      text: 'Confirm & Place Order',
                      prefixIcon: Icons.check_circle_outline,
                      isLoading: state is OrderSuppliesSubmitting,
                      onPressed: state is OrderSuppliesSubmitting
                          ? null
                          : () =>
                              context.read<OrderSuppliesCubit>().confirmOrder(),
                    );
                  },
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
// PRIVATE DATA + WIDGETS
// =============================================================================

/// Holds a resolved product reference and quantity for rendering.
class _LineItem {
  const _LineItem({required this.product, required this.qty});

  final SupplyProduct product;
  final int qty;
}

/// A single order line row: product name × qty = subtotal.
class _OrderLineItem extends StatelessWidget {
  const _OrderLineItem({
    required this.item,
    required this.formatPrice,
  });

  final _LineItem item;
  final String Function(int) formatPrice;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    final int subtotal = item.product.priceIdr * item.qty;
    final String subtotalFormatted = 'Rp ${formatPrice(subtotal)}';

    return Semantics(
      label:
          '${item.product.name}, quantity ${item.qty}, subtotal $subtotalFormatted',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name + qty
          Expanded(
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    '× ${item.qty}',
                    style: theme.textTheme.bodySmall?.copyWith(color: ink2),
                  ),
                ],
              ),
            ),
          ),
          // Subtotal
          ExcludeSemantics(
            child: Text(
              subtotalFormatted,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
