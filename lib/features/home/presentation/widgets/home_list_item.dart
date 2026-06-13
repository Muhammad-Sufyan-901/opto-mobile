import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A single list-item row for the "Up next" and "Recent activity" card groups
/// on the Opto Home screen.
///
/// The leading element is either:
/// - A **round 46×46 blue-tint icon chip** (when [icon] is provided), or
/// - A **blue avatar circle** with white [avatarInitials] (e.g. "BP").
///
/// Exactly one of [icon] or [avatarInitials] must be supplied.
///
/// Design: `.li`, `.li-ic`, `.li-av`, `.li-tt`, `.li-h`, `.li-s`, `.li-tr`
/// in `Android Home Dashboard.html` (V1 Card Stack).
class HomeListItem extends StatelessWidget {
  const HomeListItem({
    super.key,
    this.icon,
    this.avatarInitials,
    required this.title,
    required this.subtitle,
    this.showChevron = true,
    this.onTap,
    this.semanticLabel,
  }) : assert(
         (icon != null) != (avatarInitials != null),
         'Provide either icon or avatarInitials, not both.',
       );

  /// Material icon displayed inside the blue-tint chip.
  final IconData? icon;

  /// 1-2 character initials rendered inside the blue avatar circle.
  final String? avatarInitials;

  final String title;
  final String subtitle;

  /// When true, a trailing chevron is shown (default). Pass false for
  /// recent-activity rows that have no trailing action.
  final bool showChevron;

  final VoidCallback? onTap;

  /// Full accessible label. Falls back to "$title. $subtitle.".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final String label = semanticLabel ?? '$title. $subtitle.';

    return Semantics(
      button: onTap != null,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Leading: icon chip OR avatar ──────────────────────────
              ExcludeSemantics(
                child: icon != null
                    ? Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: blueTint,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: AppDimensions.iconLg, color: blueStrong),
                      )
                    : Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          avatarInitials!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),

              const SizedBox(width: 14),

              // ── Text ─────────────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: ink2,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ──────────────────────────────────────
              if (showChevron)
                ExcludeSemantics(
                  child: Icon(Icons.chevron_right, size: 22, color: ink3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
