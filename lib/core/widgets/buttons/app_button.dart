import 'package:flutter/material.dart';
import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

// Button Variants
enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  ghost,
  link,
  destructive,
  success,
  warning,
}

const double minimumWidth = 64;
const double defaultRadius = AppDimensions.radiusButton; // 16dp per design system
const double defaultIconSize = AppDimensions.iconMd; // 20dp
const double defaultHeight = AppDimensions.buttonHeight; // 60dp (≥60dp per design system)
const double defaultWidth = double.infinity;

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonStyle? customStyle;
  final EdgeInsetsGeometry? padding;
  final double width;
  final double height;
  final double radius;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double iconSize;
  final AppButtonVariant _variant;

  // ==========================================
  // NAMED CONSTRUCTORS (Button Factory)
  // ==========================================
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.secondary;

  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.outlined;

  const AppButton.ghost({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.ghost;

  const AppButton.link({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.link;

  const AppButton.destructive({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.destructive;

  const AppButton.success({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.success;

  const AppButton.warning({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customStyle,
    this.padding,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.radius = defaultRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize = defaultIconSize,
  }) : _variant = AppButtonVariant.warning;

  // ==========================================
  // BUTTON BUILDER LOGIC
  // ==========================================
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final customColors = theme.extension<AppExtendedCustomColors>();

    final bool isLink = _variant == AppButtonVariant.link;

    final Widget buttonContent = isLoading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: iconSize),
                const SizedBox(width: 8),
              ],
              Text(text),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8),
                Icon(suffixIcon, size: iconSize),
              ],
            ],
          );

    final VoidCallback? action = isLoading ? null : onPressed;

    final Map<AppButtonVariant, ButtonStyle> variantStyles = {
      AppButtonVariant.primary: FilledButton.styleFrom(),
      AppButtonVariant.secondary: FilledButton.styleFrom(
        backgroundColor: colorScheme.secondaryContainer.withValues(alpha: 0.15),
        foregroundColor: colorScheme.secondaryContainer,
      ),
      AppButtonVariant.outlined: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary, width: 2),
      ),
      AppButtonVariant.ghost: TextButton.styleFrom(),
      AppButtonVariant.link:
          TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).copyWith(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
      AppButtonVariant.destructive: FilledButton.styleFrom(
        backgroundColor: customColors?.error ?? Colors.red.shade600,
        foregroundColor: customColors?.onError ?? Colors.white,
      ),
      AppButtonVariant.success: FilledButton.styleFrom(
        backgroundColor: customColors?.success ?? Colors.green.shade600,
        foregroundColor: customColors?.onSuccess ?? Colors.white,
      ),
      AppButtonVariant.warning: FilledButton.styleFrom(
        backgroundColor: customColors?.warning ?? Colors.orange.shade600,
        foregroundColor: customColors?.onWarning ?? Colors.white,
      ),
    };

    EdgeInsetsGeometry resolvedPadding =
        padding ??
        const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        );
    Size resolvedMinimumSize = Size(
      minimumWidth,
      height,
    );
    TextDecoration? resolvedDecoration;
    Color? resolvedDecorationColor;
    double? resolvedWidth = width;

    if (isFullWidth) {
      resolvedWidth = double.infinity;
    } else if (width != double.infinity) {
      resolvedWidth = width;
    } else {
      resolvedWidth = null;
    }

    if (isLink) {
      if (padding == null) resolvedPadding = EdgeInsets.zero;

      resolvedMinimumSize = Size.zero;
      resolvedDecoration = TextDecoration.underline;
      resolvedDecorationColor = colorScheme.primary;
    }

    final ButtonStyle baseStyle = ElevatedButton.styleFrom(
      padding: resolvedPadding,
      minimumSize: resolvedMinimumSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      textStyle: textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.bold,
        decoration: resolvedDecoration,
        decorationColor: resolvedDecorationColor,
      ),
    ).merge(variantStyles[_variant]).merge(customStyle);

    final Map<AppButtonVariant, Widget Function()> buttonBuilders = {
      AppButtonVariant.primary: () => FilledButton(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
      AppButtonVariant.secondary: () => FilledButton.tonal(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
      AppButtonVariant.outlined: () => OutlinedButton(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
      AppButtonVariant.ghost: () => TextButton(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
      AppButtonVariant.link: () => TextButton(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
      AppButtonVariant.destructive: () => FilledButton(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
      AppButtonVariant.success: () => FilledButton(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
      AppButtonVariant.warning: () => FilledButton(
        onPressed: action,
        style: baseStyle,
        child: buttonContent,
      ),
    };

    return SizedBox(
      width: resolvedWidth,
      child: buttonBuilders[_variant]!(),
    );
  }
}
