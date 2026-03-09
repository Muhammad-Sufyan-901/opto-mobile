import 'package:flutter/material.dart';

// ==========================================
// VARIANTS ENUM
// ==========================================
enum AppBadgeVariant {
  primary, // Solid Background, white text (Default)
  secondary, // Solid Background abu-abu muda, black text
  destructive, // Solid Background merah pekat, white text
  outline, // Border only
  ghost, // No border, no background
  soft, // Background pudar (10% opacity), solid text
}

// ==========================================
// DEFAULT CONSTANTS
// ==========================================
const double _defaultRadius = 999.0;
const EdgeInsetsGeometry _defaultPadding = EdgeInsets.symmetric(
  horizontal: 10.0,
  vertical: 2.0,
);

class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeVariant variant;
  final Color?
  color; // Custom color (optional, overrides default variant color)
  final IconData? icon;
  final bool isLoading;
  final double radius;

  // ==========================================
  // NAMED CONSTRUCTORS (Badge Factory)
  // ==========================================
  const AppBadge({
    super.key,
    required this.text,
    this.variant = AppBadgeVariant.primary,
    this.color,
    this.icon,
    this.isLoading = false,
    this.radius = _defaultRadius,
  });

  const AppBadge.secondary({
    super.key,
    required this.text,
    this.icon,
    this.isLoading = false,
  }) : variant = AppBadgeVariant.secondary,
       color = null,
       radius = _defaultRadius;

  const AppBadge.destructive({
    super.key,
    required this.text,
    this.icon,
    this.isLoading = false,
  }) : variant = AppBadgeVariant.destructive,
       color = null,
       radius = _defaultRadius;

  const AppBadge.outline({
    super.key,
    required this.text,
    this.color,
    this.icon,
    this.isLoading = false,
  }) : variant = AppBadgeVariant.outline,
       radius = _defaultRadius;

  const AppBadge.ghost({
    super.key,
    required this.text,
    this.color,
    this.icon,
    this.isLoading = false,
  }) : variant = AppBadgeVariant.ghost,
       radius = _defaultRadius;

  const AppBadge.soft({
    super.key,
    required this.text,
    required this.color,
    this.icon,
    this.isLoading = false,
  }) : variant = AppBadgeVariant.soft,
       radius = _defaultRadius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    Color resolvedBackgroundColor = Colors.transparent;
    Color resolvedForegroundColor = Colors.black;
    BoxBorder? resolvedBorder;

    switch (variant) {
      case AppBadgeVariant.primary:
        resolvedBackgroundColor = color ?? colorScheme.primary;
        resolvedForegroundColor = colorScheme.onPrimary;
        break;

      case AppBadgeVariant.secondary:
        resolvedBackgroundColor = isDarkMode
            ? Colors.grey.shade800
            : Colors.grey.shade200;
        resolvedForegroundColor = isDarkMode
            ? Colors.grey.shade100
            : Colors.grey.shade900;
        break;

      case AppBadgeVariant.destructive:
        resolvedBackgroundColor = color ?? Colors.red.shade600;
        resolvedForegroundColor = Colors.white;
        break;

      case AppBadgeVariant.outline:
        resolvedBackgroundColor = Colors.transparent;
        resolvedForegroundColor =
            color ?? (isDarkMode ? Colors.white : Colors.black87);
        resolvedBorder = Border.all(
          color:
              color ??
              (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
          width: 1.0,
        );
        break;

      case AppBadgeVariant.ghost:
        resolvedBackgroundColor = Colors.transparent;
        resolvedForegroundColor =
            color ?? (isDarkMode ? Colors.white : Colors.black87);
        break;

      case AppBadgeVariant.soft:
        final Color baseColor = color ?? colorScheme.primary;
        resolvedBackgroundColor = baseColor.withValues(
          alpha: 0.15,
        );
        resolvedForegroundColor = baseColor;
        break;
    }

    return Container(
      padding: _defaultPadding,
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: resolvedBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: resolvedForegroundColor,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
          ] else if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: resolvedForegroundColor,
            ),
            const SizedBox(
              width: 4,
            ),
          ],

          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: resolvedForegroundColor,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
