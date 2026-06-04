import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

/// A large selectable option card used on the Vision-profile setup screen.
///
/// Spec: `.opt-option` / `.opt-option.sel` in `Opto Onboarding.html`
///   - Unselected: 2px solid `outline` border, white background.
///   - Selected: 2px solid `primary` border, `blueTint` background.
///   - Leading icon chip: `blueTint` bg / `primary` icon when unselected;
///     white bg / `primary` icon when selected.
///   - Trailing: filled radio indicator (`.opt-radio` / `.opt-radio.on`).
///
/// Accessibility: selection state announced via [Semantics.selected] and
/// an [InkWell] tooltip — colour alone never conveys selection.
class SetupOptionTile extends StatelessWidget {
  const SetupOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.desc,
    required this.selected,
    required this.onTap,
  });

  /// Material icon to display in the leading chip.
  final IconData icon;

  /// Primary label text.
  final String title;

  /// Optional secondary description (shown below [title]).
  final String? desc;

  /// Whether this option is currently selected.
  final bool selected;

  /// Called when the tile is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final Color bg = selected ? blueTint : cs.surface;
    final Color border = selected ? cs.primary : cs.outline;
    final Color chipBg = selected ? cs.surface : blueTint;

    return Semantics(
      button: true,
      selected: selected,
      label: '$title${desc != null ? ", $desc" : ""}'
          ', ${selected ? "selected" : "not selected"}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: border, width: 2),
          ),
          child: Row(
            children: [
              // ── Icon chip ──────────────────────────────
              ExcludeSemantics(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: chipBg,
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

              // ── Text ───────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (desc != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        desc!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: ext?.ink2 ?? cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: AppDimensions.space16),

              // ── Radio indicator ────────────────────────
              ExcludeSemantics(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? cs.primary : cs.outline,
                      width: 2.5,
                    ),
                    // Inner fill creates the "filled radio" look when selected.
                    color: selected ? cs.primary : Colors.transparent,
                  ),
                  child: selected
                      ? Icon(
                          Icons.circle,
                          size: 10,
                          color: cs.surface,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
