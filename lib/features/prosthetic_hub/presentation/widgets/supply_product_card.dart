// Widget: SupplyProductCard
//
// Restyled for the M3 redesign — square image placeholder with a short type
// label, product name, type description, blue price, and a stepper pill.
// Mirrors the `.hb-sup` layout from the design.
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/currency_formatter.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';

/// An accessible product card for the Order Supplies catalog.
///
/// Shows a square image chip, product name, type label, price, and a quantity
/// stepper pill. When [qty] is 0 only the `+` is shown; once the user taps it
/// the pill expands to `[−] qty [+]`.
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

  /// Derives a short 1–6 char label from the product type for the image chip.
  String _chipLabel(SupplyProductType type) => switch (type) {
        SupplyProductType.solution => 'Saline',
        SupplyProductType.selfCleaningCase => 'SC\nCase',
        SupplyProductType.storageCase => 'Case',
        SupplyProductType.careKit => 'Kit',
        SupplyProductType.cloth => 'Cloth',
      };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color onTint = cs.onPrimaryContainer;
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final String formattedPrice = 'Rp ${formatRupiah(product.priceIdr)}';

    final String semanticsLabel =
        '${product.name}. ${product.type.displayLabel}. $formattedPrice. '
        '${qty == 0 ? "Tap plus to add" : "Quantity: $qty"}';

    return Semantics(
      label: semanticsLabel,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: AppDimensions.space16,
        ),
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 2),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Image chip ─────────────────────────────────────────────────
            ExcludeSemantics(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: line.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => _ChipFallback(
                            label: _chipLabel(product.type),
                            labelColor: onTint,
                          ),
                        )
                      : Image.asset(
                          product.type.imageAssetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => _ChipFallback(
                            label: _chipLabel(product.type),
                            labelColor: onTint,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // ── Text column ────────────────────────────────────────────────
            Expanded(
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.type.displayLabel,
                      style: theme.textTheme.bodySmall?.copyWith(color: ink3),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      formattedPrice,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ── Stepper pill ───────────────────────────────────────────────
            _StepperPill(
              qty: qty,
              onAdd: onAdd,
              onRemove: onRemove,
              productName: product.name,
              line: line,
            ),
          ],
        ),
      ),
    );
  }
}

/// The `[− qty +]` pill stepper (or just `[+]` when qty = 0).
class _StepperPill extends StatelessWidget {
  const _StepperPill({
    required this.qty,
    required this.onAdd,
    required this.onRemove,
    required this.productName,
    required this.line,
  });

  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final String productName;
  final Color line;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: line, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (qty > 0) ...[
            Semantics(
              button: true,
              label: 'Remove one $productName from cart',
              excludeSemantics: true,
              child: SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  color: cs.primary,
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
          Semantics(
            button: true,
            label: 'Add $productName',
            excludeSemantics: true,
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  size: 20,
                  color: cs.primary,
                ),
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
    );
  }
}

/// Fallback widget shown inside the image chip when the image fails to load.
class _ChipFallback extends StatelessWidget {
  const _ChipFallback({required this.label, required this.labelColor});

  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          height: 1.3,
          color: labelColor,
        ),
      ),
    );
  }
}
