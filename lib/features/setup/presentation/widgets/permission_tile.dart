import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A single permission row on the Permissions setup screen.
///
/// Spec: `.perm-row` in `Opto Onboarding.html`.
///   - 2px solid `outline` border, radius 18.
///   - Leading 48dp icon chip: `blueTint` bg / `primary` icon.
///   - Title + description text.
///   - Trailing pill button: blue "Allow" when not granted; green check
///     pill (`.perm-btn.on`) when granted.
///
/// Accessibility: the granted state is exposed as labelled text so it is
/// never conveyed by colour alone.
class PermissionTile extends StatelessWidget {
  const PermissionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.granted,
    required this.onAllow,
  });

  /// Material icon for the leading chip.
  final IconData icon;

  /// Permission name (e.g. "Camera").
  final String title;

  /// One-line explanation (e.g. "Read text and identify objects around you").
  final String desc;

  /// Whether the permission has been granted.
  final bool granted;

  /// Called when the "Allow" button is pressed.
  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color green = ext?.green ?? Colors.green.shade700;
    final Color greenTint = ext?.greenTint ?? Colors.green.shade50;

    final Color btnBg = granted ? green : cs.primary;
    final Color btnFg = Colors.white;
    final String btnLabel = granted ? 'Granted' : 'Allow';
    final String semanticLabel =
        '$title. $desc. ${granted ? "Permission granted." : "Permission not yet granted. Double-tap to allow."}';

    return Semantics(
      button: !granted,
      label: semanticLabel,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: granted ? greenTint.withValues(alpha: 0.35) : cs.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
          border: Border.all(
            color: granted
                ? green.withValues(alpha: 0.4)
                : cs.outline.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Icon chip ──────────────────────────────
            ExcludeSemantics(
              child: Container(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                decoration: BoxDecoration(
                  color: blueTint,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
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

            const SizedBox(width: AppDimensions.space12),

            // ── Allow / Granted pill ───────────────────
            GestureDetector(
              onTap: granted ? null : onAllow,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                constraints: const BoxConstraints(
                  minWidth: 66,
                  minHeight: 46,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                ),
                decoration: BoxDecoration(
                  color: btnBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (granted)
                      Icon(Icons.check, size: AppDimensions.iconMd, color: btnFg),
                    if (!granted)
                      Text(
                        btnLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: btnFg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
