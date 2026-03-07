import 'package:flutter/material.dart';

// ==========================================
// ➔ ✨ VARIANTS ENUM
// ==========================================
enum AppAlertVariant {
  standard,
  destructive,
  info,
  warning,
  success,
}

const double _defaultRadius = 8.0;
const double _defaultBorderWidth = 1.0;
const double _defaultIconSize = 20.0;
const double _defaultPadding = 16.0;

// ==========================================
// ➔ ✨ ROOT ALERT COMPONENT
// ==========================================
class AppAlert extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Widget? action;
  final AppAlertVariant variant;
  final Color? color;

  // ==========================================
  // NAMED CONSTRUCTORS (Alert Factory)
  // ==========================================
  const AppAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.variant = AppAlertVariant.standard,
    this.color,
  });

  const AppAlert.destructive({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.color,
  }) : variant = AppAlertVariant.destructive;

  const AppAlert.info({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.color,
  }) : variant = AppAlertVariant.info;

  const AppAlert.warning({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.color,
  }) : variant = AppAlertVariant.warning;

  const AppAlert.success({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.color,
  }) : variant = AppAlertVariant.success;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    Color resolvedBackgroundColor = Colors.transparent;
    Color resolvedBorderColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    Color resolvedForegroundColor = colorScheme.onSurface;
    Color resolvedDescriptionColor = Colors.grey.shade500;

    switch (variant) {
      case AppAlertVariant.standard:
        if (color != null) {
          resolvedBorderColor = color!;
          resolvedForegroundColor = color!;
        }
        break;

      case AppAlertVariant.destructive:
        final baseColor = color ?? Colors.red.shade600;
        resolvedBorderColor = baseColor.withValues(alpha: 0.5);
        resolvedForegroundColor = baseColor;
        resolvedBackgroundColor = baseColor.withValues(
          alpha: 0.05,
        );
        break;

      case AppAlertVariant.info:
        final baseColor = color ?? Colors.blue.shade600;
        resolvedBorderColor = baseColor.withValues(alpha: 0.4);
        resolvedForegroundColor = baseColor;
        resolvedBackgroundColor = baseColor.withValues(alpha: 0.1);
        break;

      case AppAlertVariant.warning:
        // Sesuai dengan referensi gambar 2 (Warning dengan warna coklat/orange)
        final baseColor = color ?? Colors.orange.shade800;
        resolvedBorderColor = Colors.orange.shade300;
        resolvedForegroundColor = baseColor;
        resolvedBackgroundColor = Colors.orange.shade50;
        if (isDarkMode) {
          resolvedBackgroundColor = Colors.orange.shade900.withValues(
            alpha: 0.2,
          );
          resolvedBorderColor = Colors.orange.shade800;
          resolvedForegroundColor = Colors.orange.shade300;
        }
        break;

      case AppAlertVariant.success:
        final baseColor = color ?? Colors.green.shade600;
        resolvedBorderColor = baseColor.withValues(alpha: 0.4);
        resolvedForegroundColor = baseColor;
        resolvedBackgroundColor = baseColor.withValues(alpha: 0.1);
        break;
    }

    // ==========================================
    // ALERT CONTENT
    // ==========================================
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_defaultPadding),
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(_defaultRadius),
        border: Border.all(
          color: resolvedBorderColor,
          width: _defaultBorderWidth,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: _defaultIconSize,
              color: resolvedForegroundColor,
            ),
            const SizedBox(
              width: 12,
            ),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: resolvedForegroundColor,
                    letterSpacing: -0.2,
                    height: 1.4,
                  ),
                ),

                // Description (Opsional)
                if (description != null) ...[
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: resolvedDescriptionColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (action != null) ...[
            const SizedBox(
              width: 12,
            ),
            action!,
          ],
        ],
      ),
    );
  }
}
