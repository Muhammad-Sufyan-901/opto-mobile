import 'package:flutter/material.dart';

// ==========================================
// ➔ ✨ DEFAULT CONSTANTS (DRY Principle)
// ==========================================
const double _defaultRadius = 8.0;
const double _defaultMinWidth = 200.0;
const double _defaultBorderWidth = 1.0;
const double _defaultElevation = 4.0;
const double _defaultHeight = 0.0;
const double _defaultIconSize = 18.0;
const EdgeInsetsGeometry _defaultMenuPadding = EdgeInsets.symmetric(
  vertical: 4.0,
);
const EdgeInsetsGeometry _defaultItemPadding = EdgeInsets.symmetric(
  horizontal: 12.0,
  vertical: 8.0,
);

// ==========================================
// 1. ROOT DROPDOWN MENU
// ==========================================
class AppDropdownMenu extends StatelessWidget {
  final double? width;
  // Children is a list of widgets that will be displayed in the menu
  final List<Widget> children;
  // Trigger is a button that opens the menu. We need a builder to call controller.open()
  final Widget Function(BuildContext context, MenuController controller)
  triggerBuilder;

  const AppDropdownMenu({
    super.key,
    required this.triggerBuilder,
    required this.children,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // Resolusi Gaya Menu ala Shadcn
    final Color backgroundColor = isDarkMode
        ? Colors.grey.shade900
        : Colors.white;
    final Color borderColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;

    return MenuAnchor(
      builder: (context, controller, child) {
        return triggerBuilder(context, controller);
      },
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor,
        ),
        surfaceTintColor: const WidgetStatePropertyAll(
          Colors.transparent,
        ),
        padding: const WidgetStatePropertyAll(
          _defaultMenuPadding,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _defaultRadius,
            ),
            side: BorderSide(
              color: borderColor,
              width: _defaultBorderWidth,
            ),
          ),
        ),
        elevation: const WidgetStatePropertyAll(
          _defaultElevation,
        ),
        minimumSize: WidgetStatePropertyAll(
          Size(
            width ?? _defaultMinWidth,
            _defaultHeight,
          ),
        ),
      ),
      menuChildren: children,
    );
  }
}

// ==========================================
// 2. DROPDOWN ITEM (Standard, Destructive, & Disabled)
// ==========================================
class AppDropdownItem extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? leading;
  final String? shortcut;
  final bool isDestructive;
  final bool disabled;

  const AppDropdownItem({
    super.key,
    required this.title,
    this.onPressed,
    this.leading,
    this.shortcut,
    this.isDestructive = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    Color resolvedTextColor;
    Color resolvedIconColor;

    if (disabled) {
      resolvedTextColor = isDarkMode
          ? Colors.grey.shade700
          : Colors.grey.shade400;
      resolvedIconColor = isDarkMode
          ? Colors.grey.shade700
          : Colors.grey.shade400;
    } else if (isDestructive) {
      resolvedTextColor = Colors.red.shade600;
      resolvedIconColor = Colors.red.shade500;
    } else {
      resolvedTextColor = isDarkMode ? Colors.white : Colors.black87;
      resolvedIconColor = isDarkMode
          ? Colors.grey.shade400
          : Colors.grey.shade600;
    }

    Widget? trailingWidget;
    if (shortcut != null) {
      trailingWidget = Text(
        shortcut!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: disabled ? resolvedTextColor : Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      );
    }

    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = IconTheme(
        data: IconThemeData(
          color: resolvedIconColor,
          size: _defaultIconSize,
        ),
        child: leading!,
      );
    }

    return MenuItemButton(
      onPressed: disabled ? null : onPressed,
      leadingIcon: leadingWidget,
      trailingIcon: trailingWidget,
      style: _getSharedItemStyle(context),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: resolvedTextColor,
          fontWeight: (isDestructive && !disabled)
              ? FontWeight.w500
              : FontWeight.normal,
        ),
      ),
    );
  }
}

// ==========================================
// 3. DROPDOWN SUBMENU (Nested Cascading Menu)
// ==========================================
class AppDropdownSubMenu extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget> children;

  const AppDropdownSubMenu({
    super.key,
    required this.title,
    required this.children,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = IconTheme(
        data: IconThemeData(
          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          size: _defaultIconSize,
        ),
        child: leading!,
      );
    }

    return SubmenuButton(
      menuChildren: children,
      leadingIcon: leadingWidget,
      style: _getSharedItemStyle(context),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

// ==========================================
// 4. DROPDOWN CHECKBOX ITEM
// ==========================================
class AppDropdownCheckbox extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool disabled;

  const AppDropdownCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          side: BorderSide(
            width: 1.0,
            color: disabled
                ? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300)
                : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400),
          ),
        ),
      ),
      child: CheckboxMenuButton(
        value: value,
        onChanged: disabled ? null : onChanged,
        style: _getSharedItemStyle(context),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: disabled
                ? (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400)
                : (isDarkMode ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. DROPDOWN RADIO ITEM
// ==========================================
class AppDropdownRadio<T> extends StatelessWidget {
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const AppDropdownRadio({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return RadioMenuButton<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      style: _getSharedItemStyle(context),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

// ==========================================
// 6. DROPDOWN LABEL (Non-clickable Header)
// ==========================================
class AppDropdownLabel extends StatelessWidget {
  final String text;

  const AppDropdownLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

// ==========================================
// 7. DROPDOWN SEPARATOR (Divider)
// ==========================================
class AppDropdownSeparator extends StatelessWidget {
  const AppDropdownSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      height: 9,
      thickness: 1,
      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
    );
  }
}

// ==========================================
// HELPER: Shared Hover Style
// ==========================================
ButtonStyle _getSharedItemStyle(BuildContext context) {
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return ButtonStyle(
    padding: const WidgetStatePropertyAll(_defaultItemPadding),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return isDarkMode ? Colors.white10 : Colors.grey.shade100;
        }
        return Colors.transparent;
      },
    ),
  );
}
