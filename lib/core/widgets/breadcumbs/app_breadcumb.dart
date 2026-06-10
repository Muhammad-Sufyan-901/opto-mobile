import 'package:flutter/material.dart';

const double _defaultIconSize = 16.0;

// ==========================================
// 1. ROOT BREADCRUMB
// ==========================================
class AppBreadcrumb extends StatelessWidget {
  final List<Widget> children;

  const AppBreadcrumb({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6.0,
      runSpacing: 6.0,
      children: children,
    );
  }
}

// ==========================================
// 2. BREADCRUMB SEPARATOR
// ==========================================
class AppBreadcrumbSeparator extends StatelessWidget {
  final Widget? child;

  const AppBreadcrumbSeparator({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Color color = isDarkMode
        ? Colors.grey.shade600
        : Colors.grey.shade400;

    return IconTheme(
      data: IconThemeData(
        color: color,
        size: _defaultIconSize,
      ),
      child: DefaultTextStyle(
        // Use textTheme so font family, size, and textScaler compose correctly.
        style: theme.textTheme.bodySmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w400,
        ),
        child:
            child ??
            const Icon(
              Icons.chevron_right_rounded,
            ), // Default: Chevron
      ),
    );
  }
}

// ==========================================
// 3. BREADCRUMB LINK
// ==========================================
class AppBreadcrumbLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const AppBreadcrumbLink({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Color color = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    Widget linkContent = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0,
        vertical: 2.0,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        hoverColor: isDarkMode
            ? Colors.white10
            : Colors.black.withValues(alpha: 0.05),
        child: linkContent,
      );
    }

    return linkContent;
  }
}

// ==========================================
// 4. BREADCRUMB PAGE
// ==========================================
class AppBreadcrumbPage extends StatelessWidget {
  final String text;

  const AppBreadcrumbPage({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Color color = isDarkMode ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ==========================================
// 5. BREADCRUMB ELLIPSIS
// ==========================================
class AppBreadcrumbEllipsis extends StatelessWidget {
  final VoidCallback? onTap;

  const AppBreadcrumbEllipsis({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color color = isDarkMode ? Colors.white : Colors.black87;

    Widget content = Container(
      padding: const EdgeInsets.all(4),
      child: Icon(
        Icons.more_horiz,
        size: 16,
        color: color,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        hoverColor: isDarkMode
            ? Colors.white10
            : Colors.black.withValues(
                alpha: 0.05,
              ),
        child: content,
      );
    }

    return content;
  }
}
