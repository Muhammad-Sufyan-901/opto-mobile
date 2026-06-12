// Widget: SupplyProductCard
//
// Single row card in the Order Supplies catalog. Matches the visual style of
// [CareGuideCard] — bordered container, icon chip, text column, qty controls.
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/currency_formatter.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';

/// An accessible product card for the Order Supplies catalog.
///
/// Shows product name, type label, price, and a quantity control.
/// When [qty] == 0, only a `+` button is shown. When [qty] > 0, a
/// `[−] qty [+]` row replaces it.
///
/// Semantics: the root [Semantics] announces name, type, price, and qty state.
/// Decorative elements are wrapped in [ExcludeSemantics].
class SupplyProductCard extends StatelessWidget {
  const SupplyProductCard({
    super.key,
    required this.product,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
  });

  final SupplyProduct product;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final String formattedPrice = 'Rp ${formatRupiah(product.priceIdr)}';

    final String semanticsLabel =
        '${product.name}. ${product.type.displayLabel}. $formattedPrice. '
        '${qty == 0 ? "Tap plus to add" : "Quantity: $qty"}';

    return Semantics(
      label: semanticsLabel,
      child: Container(
        constraints: const BoxConstraints(minHeight: AppDimensions.minTapTarget),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: AppDimensions.space16,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Leading icon chip (48×48) ──────────────────────────────────
            ExcludeSemantics(
              child: Container(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                decoration: BoxDecoration(
                  color: blueTint,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 22,
                  color: blueStrong,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Text column ────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Type label + price (excluded from semantics — root covers them)
                  ExcludeSemantics(
                    child: Row(
                      children: [
                        Text(
                          product.type.displayLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink2,
                          ),
                        ),
                        Text(
                          ' · ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink3,
                          ),
                        ),
                        Text(
                          formattedPrice,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Quantity control ───────────────────────────────────────────
            if (qty == 0)
              // Single + button when nothing in cart
              Semantics(
                button: true,
                label: 'Add ${product.name}',
                excludeSemantics: true,
                child: SizedBox(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  child: IconButton(
                    icon: Icon(Icons.add, color: blueStrong),
                    onPressed: onAdd,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: AppDimensions.minTapTarget,
                      minHeight: AppDimensions.minTapTarget,
                    ),
                  ),
                ),
              )
            else
              // [−] qty [+] row when item is in cart
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    button: true,
                    label: 'Remove one ${product.name} from cart',
                    excludeSemantics: true,
                    child: SizedBox(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      child: IconButton(
                        icon: Icon(Icons.remove, color: blueStrong),
                        onPressed: onRemove,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: AppDimensions.minTapTarget,
                          minHeight: AppDimensions.minTapTarget,
                        ),
                      ),
                    ),
                  ),
                  ExcludeSemantics(
                    child: SizedBox(
                      width: 28,
                      child: Text(
                        '$qty',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Add ${product.name}',
                    excludeSemantics: true,
                    child: SizedBox(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      child: IconButton(
                        icon: Icon(Icons.add, color: blueStrong),
                        onPressed: onAdd,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: AppDimensions.minTapTarget,
                          minHeight: AppDimensions.minTapTarget,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
