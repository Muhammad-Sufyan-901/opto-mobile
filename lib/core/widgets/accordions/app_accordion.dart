import 'package:flutter/material.dart';

// ==========================================
// ➔ ✨ DEFAULT CONSTANTS (DRY Principle)
// ==========================================
const Curve _defaultAnimationCurve = Curves.easeInOut;
const Duration _defaultAnimationDuration = Duration(
  milliseconds: 250,
);
const EdgeInsetsGeometry _defaultTriggerPadding = EdgeInsets.symmetric(
  vertical: 16.0,
);
const EdgeInsetsGeometry _defaultContentPadding = EdgeInsets.only(
  bottom: 16.0,
);

enum AppAccordionType {
  single,
  multiple,
}

// ==========================================
// 1. STATE PROVIDER
// ==========================================
class AppAccordionProvider extends InheritedWidget {
  final Set<String> expandedValues;
  final void Function(String) toggleItem;

  const AppAccordionProvider({
    super.key,
    required this.expandedValues,
    required this.toggleItem,
    required super.child,
  });

  static AppAccordionProvider of(BuildContext context) {
    final AppAccordionProvider? result = context
        .dependOnInheritedWidgetOfExactType<AppAccordionProvider>();
    assert(result != null, 'No AppAccordionProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppAccordionProvider oldWidget) {
    return expandedValues != oldWidget.expandedValues;
  }
}

// ==========================================
// 2. ROOT ACCORDION COMPONENT
// ==========================================
class AppAccordion extends StatefulWidget {
  final List<AppAccordionItem> children;
  final AppAccordionType type;
  final List<String> initialExpandedValues;

  const AppAccordion({
    super.key,
    required this.children,
    this.type = AppAccordionType.single,
    this.initialExpandedValues = const [],
  });

  @override
  State<AppAccordion> createState() => _AppAccordionState();
}

class _AppAccordionState extends State<AppAccordion> {
  late Set<String> _expandedValues;

  @override
  void initState() {
    super.initState();
    _expandedValues = Set<String>.from(widget.initialExpandedValues);

    if (widget.type == AppAccordionType.single && _expandedValues.length > 1) {
      _expandedValues = {_expandedValues.first};
    }
  }

  void _toggleItem(String value) {
    setState(() {
      final Set<String> newExpandedValues = Set<String>.from(_expandedValues);

      final bool isCurrentlyExpanded = newExpandedValues.contains(value);

      if (widget.type == AppAccordionType.single) {
        newExpandedValues.clear();
        if (!isCurrentlyExpanded) {
          newExpandedValues.add(value);
        }
      } else {
        if (isCurrentlyExpanded) {
          newExpandedValues.remove(value);
        } else {
          newExpandedValues.add(value);
        }
      }

      _expandedValues = newExpandedValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppAccordionProvider(
      expandedValues: _expandedValues,
      toggleItem: _toggleItem,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: widget.children,
      ),
    );
  }
}

// ==========================================
// 3. ACCORDION ITEM COMPONENT (Trigger & Content)
// ==========================================
class AppAccordionItem extends StatelessWidget {
  final String value; // Must be unique ID
  final String title;
  final Widget content;
  final bool disabled;

  const AppAccordionItem({
    super.key,
    required this.value,
    required this.title,
    required this.content,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // Get data from parent (Provider)
    final AppAccordionProvider provider = AppAccordionProvider.of(context);
    final bool isOpen = provider.expandedValues.contains(value);

    // Resolve colors and other properties
    Color resolvedTitleColor = colorScheme.onSurface;
    Color resolvedIconColor = Colors.grey.shade600;
    Color resolvedBorderColor = isDarkMode
        ? colorScheme.outlineVariant
        : Colors.grey.shade200;

    if (disabled) {
      resolvedTitleColor = Colors.grey.shade400;
      resolvedIconColor = Colors.grey.shade400;
    } else if (isOpen) {
      resolvedTitleColor = colorScheme.primary;
    }

    // Resolve content
    Widget resolvedContent;

    // If opened, render content. If closed, render empty (shrink)
    if (isOpen) {
      resolvedContent = Padding(
        padding: _defaultContentPadding,
        child: DefaultTextStyle(
          style: textTheme.bodyMedium!.copyWith(
            color: Colors.grey.shade600,
            height: 1.5,
          ),
          child: content,
        ),
      );
    } else {
      resolvedContent = const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: resolvedBorderColor,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trigger (clickable)
          InkWell(
            onTap: disabled ? null : () => provider.toggleItem(value),
            // Remove box hover effect on mobile, focus on functionality
            splashColor: disabled ? Colors.transparent : null,
            highlightColor: disabled ? Colors.transparent : null,
            child: Padding(
              padding: _defaultTriggerPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: resolvedTitleColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),

                  // Magic Animation: Chevron turns when opened
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0.0,
                    duration: _defaultAnimationDuration,
                    curve: _defaultAnimationCurve,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: resolvedIconColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content (show/hide)
          AnimatedSize(
            duration: _defaultAnimationDuration,
            curve: _defaultAnimationCurve,
            alignment: Alignment.topCenter,
            child: resolvedContent,
          ),
        ],
      ),
    );
  }
}
