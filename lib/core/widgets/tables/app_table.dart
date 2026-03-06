import 'package:flutter/material.dart';

// ==========================================
// ➔ ✨ DEFAULT CONSTANTS
// ==========================================
const EdgeInsetsGeometry _defaultCellPadding = EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 16.0,
);
// Default Min Width 600px. If screen width < 600px, horizontal scroll will appear!
const double _defaultMinWidth = 600.0;
const double _defaultBorderWidth = 1.0;
const int _defaultFlex = 1;

// ==========================================
// 1. ROOT TABLE COMPONENT
// ==========================================
class AppTable extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;

  const AppTable({
    super.key,
    required this.children,
    this.minWidth = _defaultMinWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the largest size between screen width or minWidth
        final double tableWidth = constraints.maxWidth > minWidth
            ? constraints.maxWidth
            : minWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth, // Force table to have breathing room
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// 2. TABLE HEADER
// ==========================================
class AppTableHeader extends StatelessWidget {
  final Widget child;

  const AppTableHeader({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            width: _defaultBorderWidth,
          ),
        ),
      ),
      child: child,
    );
  }
}

// ==========================================
// 3. TABLE BODY
// ==========================================
class AppTableBody extends StatelessWidget {
  final List<Widget> children;

  const AppTableBody({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

// ==========================================
// 4. TABLE ROW (Support Tap & Hover)
// ==========================================
class AppTableRow extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onTap;
  final bool isFooter;

  const AppTableRow({
    super.key,
    required this.children,
    this.onTap,
    this.isFooter = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Map<bool, Color> backgroundColors = {
      true: isDarkMode
          ? Colors.grey.shade900
          : Colors.grey.shade50, // Footer Background
      false: Colors.transparent, // Normal Background (Table Row)
    };

    final Color borderColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade100;

    Widget rowContent = Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );

    if (onTap != null) {
      return Material(
        color: backgroundColors[isFooter],
        child: InkWell(
          onTap: onTap,
          hoverColor: isDarkMode
              ? Colors.white10
              : Colors.black.withValues(
                  alpha: 0.03,
                ),
          child: rowContent,
        ),
      );
    }

    return Container(
      color: backgroundColors[isFooter],
      child: rowContent,
    );
  }
}

// ==========================================
// 5. TABLE HEAD CELL
// ==========================================
class AppTableHead extends StatelessWidget {
  final String text;
  final int? flex;
  final double? width;
  final TextAlign textAlign;

  const AppTableHead(
    this.text, {
    super.key,
    this.flex = _defaultFlex,
    this.width,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    Widget cellContent = Padding(
      padding: _defaultCellPadding,
      child: Text(
        text,
        textAlign: textAlign,
        style: textTheme.bodyMedium?.copyWith(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (width != null) {
      return SizedBox(
        width: width,
        child: cellContent,
      );
    }

    return Expanded(
      flex: flex ?? _defaultFlex,
      child: cellContent,
    );
  }
}

// ==========================================
// 6. TABLE DATA CELL
// ==========================================
class AppTableCell extends StatelessWidget {
  final Widget child;
  final int? flex;
  final double? width;
  final Alignment alignment;

  const AppTableCell({
    super.key,
    required this.child,
    this.flex = _defaultFlex,
    this.width,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;

    Widget cellContent = Container(
      padding: _defaultCellPadding,
      alignment: alignment,
      child: DefaultTextStyle(
        style: textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurface,
        ),
        child: child,
      ),
    );

    if (width != null) {
      return SizedBox(
        width: width,
        child: cellContent,
      );
    }

    return Expanded(
      flex: flex ?? _defaultFlex,
      child: cellContent,
    );
  }
}
