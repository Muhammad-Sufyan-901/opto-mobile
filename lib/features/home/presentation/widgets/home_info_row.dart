import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Shared info-row used for the "Upcoming reminder" and "Navigate nearby"
/// tiles on the Opto Home screen.
///
/// Renders a white card with a leading blue-tint icon chip, optional eyebrow
/// label, title, subtitle, and a trailing chevron.
///
/// Design: `.remind` and `.nearby` classes in `Opto Onboarding.html`
/// (Dashboard section). Both share the same shell; the eyebrow is optional
/// ("UPCOMING" for the reminder row, absent for the nearby row).
class HomeInfoRow extends StatelessWidget {
  const HomeInfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.semanticLabel,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// Optional uppercase eyebrow (e.g. "Upcoming"). Displayed in primary blue.
  final String? eyebrow;

  /// Full accessible label. Falls back to `"$eyebrow. $title. $subtitle."`.
  final String? semanticLabel;

  final VoidCallback? onTap;

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

    final String resolvedLabel = semanticLabel ??
        [
          if (eyebrow != null) '${eyebrow!}.',
          '$title.',
          subtitle,
        ].join(' ');

    return Semantics(
      button: true,
      label: resolvedLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF142850).withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Leading icon chip (46×46, radius 13) ──────────────────
              ExcludeSemantics(
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, size: AppDimensions.iconLg, color: blueStrong),
                ),
              ),

              const SizedBox(width: 14),

              // ── Text column ────────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (eyebrow != null) ...[
                        Text(
                          eyebrow!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: cs.primary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                      ],
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: ink2,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ───────────────────────────────────────
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
