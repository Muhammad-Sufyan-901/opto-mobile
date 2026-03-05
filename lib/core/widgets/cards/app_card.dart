import 'package:flutter/material.dart';

// ==========================================
// ➔ ✨ DEFAULT CONSTANTS (DRY Principle)
// ==========================================
const double _defaultRadius = 12.0;
const double _defaultBorderWidth = 1.0;
const EdgeInsetsGeometry _defaultHeaderPadding = EdgeInsets.all(24.0);
const EdgeInsetsGeometry _defaultContentPadding = EdgeInsets.only(
  left: 24.0,
  right: 24.0,
  bottom: 24.0,
);
const EdgeInsetsGeometry _defaultFooterPadding = EdgeInsets.only(
  left: 24.0,
  right: 24.0,
  bottom: 24.0,
);

// ==========================================
// 1. ROOT CARD COMPONENT
// ==========================================
class AppCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final double borderWidth;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool hasBorder;
  final bool hasShadow;

  // Varian 1: Combined (Border + Shadow)
  const AppCard({
    super.key,
    required this.child,
    this.radius = _defaultRadius,
    this.margin,
    this.backgroundColor,
    this.borderWidth = _defaultBorderWidth,
    this.hasBorder = true,
    this.hasShadow = true,
  });

  // Varian 2: Outlined (Only Border)
  const AppCard.outlined({
    super.key,
    required this.child,
    this.radius = _defaultRadius,
    this.margin,
    this.backgroundColor,
    this.borderWidth = _defaultBorderWidth,
    this.hasBorder = true,
    this.hasShadow = false,
  });

  // Varian 3: Elevated (Only Shadow)
  const AppCard.elevated({
    super.key,
    required this.child,
    this.radius = _defaultRadius,
    this.margin,
    this.backgroundColor,
    this.borderWidth = 0.0,
    this.hasBorder = false,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Brightness brightness = theme.brightness;
    final bool isDarkMode = brightness == Brightness.dark;

    BoxBorder? resolvedBorder;
    if (hasBorder) {
      resolvedBorder = Border.all(
        color: isDarkMode ? colorScheme.outlineVariant : Colors.grey.shade200,
        width: borderWidth,
      );
    }

    List<BoxShadow>? resolvedBoxShadow;
    if (hasShadow) {
      resolvedBoxShadow = [
        BoxShadow(
          blurRadius: 8,
          offset: const Offset(0, 2),
          color: Colors.black.withValues(
            alpha: 0.05,
          ),
        ),
      ];
    }

    return Container(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: resolvedBorder,
        boxShadow: resolvedBoxShadow,
      ),
      child: child,
    );
  }
}

// ==========================================
// 2. CARD HEADER
// ==========================================
class AppCardHeader extends StatelessWidget {
  final Widget title;
  final Widget? description;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const AppCardHeader({
    super.key,
    required this.title,
    this.description,
    this.trailing,
    this.padding = _defaultHeaderPadding,
  });

  @override
  Widget build(BuildContext context) {
    Widget headerContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title,
        if (description != null) ...[
          const SizedBox(
            height: 6,
          ),
          description!,
        ],
      ],
    );

    if (trailing != null) {
      headerContent = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: headerContent,
          ),
          const SizedBox(
            width: 16,
          ),
          trailing!,
        ],
      );
    }

    return Padding(
      padding: padding,
      child: headerContent,
    );
  }
}

// ==========================================
// 3. CARD TITLE
// ==========================================
class AppCardTitle extends StatelessWidget {
  final String text;
  const AppCardTitle(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    return Text(
      text,
      style: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: colorScheme.onSurface,
      ),
    );
  }
}

// ==========================================
// 4. CARD DESCRIPTION
// ==========================================
class AppCardDescription extends StatelessWidget {
  final String text;
  const AppCardDescription(
    this.text, {
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: color ?? colorScheme.onSurface,
      ),
    );
  }
}

// ==========================================
// 5. CARD CONTENT
// ==========================================
class AppCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppCardContent({
    super.key,
    required this.child,
    this.padding = _defaultContentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}

// ==========================================
// 6. CARD FOOTER
// ==========================================
class AppCardFooter extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const AppCardFooter({
    super.key,
    required this.children,
    this.padding = _defaultFooterPadding,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Widget footerLayout;

    if (direction == Axis.horizontal) {
      footerLayout = Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    } else {
      footerLayout = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    }

    return Padding(
      padding: padding,
      child: footerLayout,
    );
  }
}
