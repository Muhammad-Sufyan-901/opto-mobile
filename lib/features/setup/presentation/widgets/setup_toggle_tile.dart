import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/core/widgets/switches/app_switch.dart';

/// An outlined row with an icon chip, text, and a trailing toggle.
///
/// Spec: `.set-toggle-row` in `Opto Onboarding.html`.
///   - 2px solid `outline` border, radius 18.
///   - Leading 48dp icon chip: `blueTint` bg / `primary` icon.
///   - Title + optional description.
///   - Trailing [AppSwitch] with `color: primary`.
///
/// Accessibility: the row is a labelled button whose switch state is
/// exposed via [Semantics.toggled] so it is never colour-only.
class SetupToggleTile extends StatelessWidget {
  const SetupToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.value,
    required this.onChanged,
  });

  /// Material icon for the leading chip.
  final IconData icon;

  /// Row title.
  final String title;

  /// Secondary description text below [title].
  final String desc;

  /// Current switch value.
  final bool value;

  /// Called when the toggle is tapped.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final String semanticLabel =
        '$title. $desc. ${value ? "On" : "Off"}. Double-tap to toggle.';

    return Semantics(
      button: true,
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: cs.outline.withValues(alpha: 0.5), width: 2),
          ),
          child: Row(
            children: [
              // ── Icon chip ──────────────────────────────
              ExcludeSemantics(
                child: Container(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusChip,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: AppDimensions.iconLg,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppDimensions.space16),

              // ── Labels ─────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: ext?.ink2 ?? cs.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppDimensions.space16),

              // ── Toggle ─────────────────────────────────
              ExcludeSemantics(
                child: AppSwitch(
                  value: value,
                  onChanged: onChanged,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
