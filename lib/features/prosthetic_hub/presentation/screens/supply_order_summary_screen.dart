// Screen: Supply Order Summary (light M3 restyle)
//
// Rounded line-item rows + summary block matching the new token/radius language.
// All logic unchanged: extra guard, BlocProvider.value, announce(), BlocListener
// → HapticPatterns.success() + context.go(hub), confirmOrder() loading state.
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/currency_formatter.dart';
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
    final extra = GoRouterState.of(context).extra;
    if (extra is! Map<String, dynamic>) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    final catalogState = extra['catalogState'] as OrderSuppliesCatalog?;
    final cubit = extra['cubit'] as OrderSuppliesCubit?;
    if (catalogState == null || cubit == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
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
      final product = widget.catalogState.products.firstWhereOrNull(
        (p) => p.id == entry.key,
      );
      if (product == null) continue;
      items.add(_LineItem(product: product, qty: entry.value));
    }
    return items;
  }

  int get _totalItems =>
      widget.catalogState.cart.values.fold(0, (sum, qty) => sum + qty);

  int get _totalPrice {
    int total = 0;
    for (final entry in widget.catalogState.cart.entries) {
      final product = widget.catalogState.products.firstWhereOrNull(
        (p) => p.id == entry.key,
      );
      if (product == null) continue;
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
    final Color green = ext?.green ?? cs.tertiary;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final lineItems = _lineItems;
    final totalPrice = _totalPrice;
    final String totalFormatted = 'Rp ${formatRupiah(totalPrice)}';

    return BlocListener<OrderSuppliesCubit, OrderSuppliesState>(
      listener: (context, state) {
        if (state is OrderSuppliesConfirmed) {
          HapticPatterns.success();
          announce(
            context,
            'Order confirmed. Your supplies will arrive in 3–5 days.',
          );
          context.go(AppRoutes.prostheticHub.path);
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

                // ── Line items ───────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item rows
                        for (final item in lineItems) ...[
                          _OrderLineItem(item: item),
                          const SizedBox(height: AppDimensions.space12),
                        ],

                        const SizedBox(height: AppDimensions.space8),

                        // ── Summary block ──────────────────────────────
                        Semantics(
                          label: 'Order total: $totalFormatted. Delivery free.',
                          child: Container(
                            padding: const EdgeInsets.all(
                              AppDimensions.cardPaddingLarge,
                            ),
                            decoration: BoxDecoration(
                              color: blueTint,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCard + 4,
                              ),
                              border: Border.all(color: line, width: 1.5),
                            ),
                            child: ExcludeSemantics(
                              child: Column(
                                children: [
                                  _SumRow(
                                    label: 'Subtotal',
                                    value: totalFormatted,
                                  ),
                                  const SizedBox(height: 10),
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

                        // ── Consent notice ────────────────────────────
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

                // ── Confirm button ───────────────────────────────────────
                BlocBuilder<OrderSuppliesCubit, OrderSuppliesState>(
                  builder: (context, state) {
                    final bool isLoading = state is OrderSuppliesSubmitting;
                    return Semantics(
                      button: true,
                      label: 'Confirm and place order',
                      child: SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: FilledButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => context
                                  .read<OrderSuppliesCubit>()
                                  .confirmOrder(),
                          icon: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: cs.onPrimary,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline, size: 20),
                          label: const Text('Confirm & Place Order'),
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

class _LineItem {
  const _LineItem({required this.product, required this.qty});

  final SupplyProduct product;
  final int qty;
}

/// A single order line row inside a tinted card.
class _OrderLineItem extends StatelessWidget {
  const _OrderLineItem({required this.item});

  final _LineItem item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    final int subtotal = item.product.priceIdr * item.qty;
    final String subtotalFormatted = 'Rp ${formatRupiah(subtotal)}';

    return Semantics(
      label:
          '${item.product.name}, quantity ${item.qty}, subtotal $subtotalFormatted',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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
            ExcludeSemantics(
              child: Text(
                subtotalFormatted,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
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
    final base = bold
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
