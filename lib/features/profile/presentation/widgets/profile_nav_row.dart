import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A tappable nav/settings row used across the Profile screens.
///
/// Renders an icon chip + title + optional subtitle + optional trailing widget
/// (defaults to a chevron). When [danger] is true the icon chip background and
/// title colour switch to the error/red palette — used for "Sign out" and
/// "Delete account" rows.
///
/// Accessibility: the whole row is a single [Semantics] button whose label
/// combines [title] and [subtitle] (if set).
class ProfileNavRow extends StatelessWidget {
  const ProfileNavRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Custom trailing widget. Defaults to a chevron icon.
  final Widget? trailing;
  final VoidCallback? onTap;

  /// When true, renders the icon chip and title in the error/danger colour.
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color redTint =
        ext?.dangerTint ?? cs.errorContainer.withValues(alpha: 0.5);
    final Color red = cs.error;
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final Color chipBg = danger ? redTint : blueTint;
    final Color chipFg = danger ? red : blueStrong;
    final Color titleColor = danger ? red : cs.onSurface;

    final String semanticLabel = subtitle != null
        ? '$title. $subtitle'
        : title;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ext?.blueTint?.withValues(alpha: 0.45) ?? cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            children: [
              // Icon chip
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(icon, size: 24, color: chipFg),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        letterSpacing: -0.2,
                        fontSize: 16.5,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink3,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing
              ExcludeSemantics(
                child: trailing ??
                    Icon(Icons.chevron_right, color: ink3, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
