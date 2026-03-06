import 'package:flutter/material.dart';

// ==========================================
// ➔ ✨ DEFAULT CONSTANTS
// ==========================================
const EdgeInsetsGeometry _defaultListPadding = EdgeInsets.all(4.0);
const EdgeInsetsGeometry _defaultTriggerPadding = EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 8.0,
);
const Duration _defaultAnimationDuration = Duration(
  milliseconds: 200,
);

// ==========================================
// 1. STATE PROVIDER
// ==========================================
class AppTabsProvider extends InheritedWidget {
  final String currentValue;
  final void Function(String) onTabChanged;
  final bool isLined;
  final bool isVertical;

  const AppTabsProvider({
    super.key,
    required this.currentValue,
    required this.onTabChanged,
    required this.isLined,
    required this.isVertical,
    required super.child,
  });

  static AppTabsProvider of(BuildContext context) {
    final AppTabsProvider? result = context
        .dependOnInheritedWidgetOfExactType<AppTabsProvider>();
    assert(result != null, 'No AppTabsProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppTabsProvider oldWidget) {
    return currentValue != oldWidget.currentValue ||
        isLined != oldWidget.isLined ||
        isVertical != oldWidget.isVertical;
  }
}

// ==========================================
// 2. ROOT TABS COMPONENT
// ==========================================
class AppTabs extends StatefulWidget {
  final String defaultValue;
  final Widget child;
  final bool isLined;
  final bool isVertical;
  final ValueChanged<String>? onChanged;

  const AppTabs({
    super.key,
    required this.defaultValue,
    required this.child,
    this.isLined = false,
    this.isVertical = false,
    this.onChanged,
  });

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.defaultValue;
  }

  void _handleTabChanged(String newValue) {
    if (_currentValue != newValue) {
      setState(() {
        _currentValue = newValue;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(newValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTabsProvider(
      currentValue: _currentValue,
      onTabChanged: _handleTabChanged,
      isLined: widget.isLined,
      isVertical: widget.isVertical,
      child: widget.child,
    );
  }
}

// ==========================================
// 3. TABS LIST (Container for Triggers)
// ==========================================
class AppTabsList extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  const AppTabsList({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final provider = AppTabsProvider.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // REFACTOR: Using Map (Key-Value) for Style Resolution
    // Key: isLined (bool) -> Value: Style Value
    final Map<bool, Color> bgColors = {
      true: Colors.transparent,
      false: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
    };

    final Map<bool, BorderRadiusGeometry?> borderRadiuses = {
      true: null,
      false: BorderRadius.circular(8),
    };

    final Map<bool, EdgeInsetsGeometry> paddings = {
      true: EdgeInsets.zero,
      false: _defaultListPadding,
    };

    // Border resolution for Lined variant. Key: isVertical (bool)
    final Map<bool, BoxBorder> linedBorders = {
      true: Border(left: BorderSide(color: Colors.grey.shade300, width: 1)),
      false: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
    };

    // Layout resolution. Key: isVertical (bool)
    final Map<bool, Widget> layouts = {
      true: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      ),
      false: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: mainAxisAlignment,
          children: children,
        ),
      ),
    };

    return Container(
      padding: paddings[provider.isLined],
      decoration: BoxDecoration(
        color: bgColors[provider.isLined],
        borderRadius: borderRadiuses[provider.isLined],
        border: provider.isLined ? linedBorders[provider.isVertical] : null,
      ),
      child: layouts[provider.isVertical]!,
    );
  }
}

// ==========================================
// 4. TABS TRIGGER (The Button)
// ==========================================
// Enum for tab state
enum _TabState {
  disabled,
  active,
  inactive,
}

class AppTabsTrigger extends StatelessWidget {
  final String value;
  final String title;
  final bool disabled;

  const AppTabsTrigger({
    super.key,
    required this.value,
    required this.title,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = AppTabsProvider.of(context);
    final bool isActive = provider.currentValue == value;

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // Determine current key state
    final _TabState currentState = disabled
        ? _TabState.disabled
        : (isActive ? _TabState.active : _TabState.inactive);

    // Typography using Key-Value Map
    final Map<_TabState, Color> textColors = {
      _TabState.disabled: Colors.grey.shade400,
      _TabState.active: isDarkMode ? Colors.white : Colors.black,
      _TabState.inactive: Colors.grey.shade600,
    };

    final Map<_TabState, FontWeight> fontWeights = {
      _TabState.disabled: FontWeight.w500,
      _TabState.active: FontWeight.w600,
      _TabState.inactive: FontWeight.w500,
    };

    // Decoration using Key-Value Map
    final Map<bool, BoxDecoration> defaultStyles = {
      true: BoxDecoration(
        color: isDarkMode ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      false: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
    };

    // Map for Lined Style. Key: isVertical (bool)
    final Color indicatorColor = isActive
        ? colorScheme.onSurface
        : Colors.transparent;

    final Map<bool, BoxDecoration> linedStyles = {
      true: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: indicatorColor,
            width: 2,
          ),
        ),
      ),
      false: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: indicatorColor,
            width: 2,
          ),
        ),
      ),
    };

    // Decoration resolution
    final BoxDecoration resolvedDecoration = provider.isLined
        ? linedStyles[provider.isVertical]!
        : defaultStyles[isActive]!;

    return InkWell(
      onTap: disabled ? null : () => provider.onTabChanged(value),
      borderRadius: BorderRadius.circular(6),
      splashColor: disabled ? Colors.transparent : null,
      highlightColor: disabled ? Colors.transparent : null,
      child: Container(
        padding: _defaultTriggerPadding,
        decoration: resolvedDecoration,
        alignment: provider.isVertical
            ? Alignment.centerLeft
            : Alignment.center,
        child: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            color: textColors[currentState],
            fontWeight: fontWeights[currentState],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. TABS CONTENT (The View)
// ==========================================
class AppTabsContent extends StatelessWidget {
  final String value;
  final Widget child;

  const AppTabsContent({
    super.key,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final provider = AppTabsProvider.of(context);
    final bool isActive = provider.currentValue == value;

    if (!isActive) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      key: ValueKey(value),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: _defaultAnimationDuration,
      builder: (BuildContext context, double opacity, _) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
    );
  }
}
