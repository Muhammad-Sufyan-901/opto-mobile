import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

/// A selectable relationship chip for the Caregiver setup screen.
///
/// Spec: `.chip` / `.chip.on` in `Opto Onboarding.html`
///   - Unselected: 2px solid `colorScheme.outline` border, white bg,
///     `onSurfaceVariant` text.
///   - Selected: 2px solid `primary` border, `blueTint` bg, `primary` text.
///
/// Accessibility: selection state exposed via [Semantics.selected] so it is
/// never conveyed by colour alone; a leading check icon also appears when
/// selected (icon + colour + semantic state).
class RelationshipChip extends StatelessWidget {
  const RelationshipChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color blueTint =
        theme.extension<AppExtendedCustomColors>()?.blueTint ??
            cs.primaryContainer;

    final Color bgColor = selected ? blueTint : cs.surface;
    final Color borderColor = selected ? cs.primary : cs.outline;
    final Color labelColor = selected ? cs.primary : cs.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: '$label, ${selected ? "selected" : "not selected"}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(
            minHeight: AppDimensions.minTapTarget,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(Icons.check, size: 16, color: cs.primary),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
