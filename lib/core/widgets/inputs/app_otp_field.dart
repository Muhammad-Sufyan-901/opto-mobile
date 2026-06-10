import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int _defaultLength = 6;
const double _defaultRadius = 12;

class AppOTPField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final List<int> separatorPositions;
  final bool disabled;
  final bool isInvalid;

  const AppOTPField({
    super.key,
    this.length = _defaultLength,
    this.onChanged,
    this.separatorPositions = const [],
    this.disabled = false,
    this.isInvalid = false,
  });

  @override
  State<AppOTPField> createState() => _AppOTPFieldState();
}

class _AppOTPFieldState extends State<AppOTPField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(() {
      if (mounted) setState(() {});
      widget.onChanged?.call(_controller.text);
    });

    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SPLIT INDEX INTO SEVERAL GROUPS BASED ON SEPARATOR
    List<List<int>> groups = [];
    List<int> currentGroup = [];
    for (int i = 0; i < widget.length; i++) {
      currentGroup.add(i);
      if (widget.separatorPositions.contains(i) || i == widget.length - 1) {
        groups.add(currentGroup);
        currentGroup = [];
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: groups.asMap().entries.map((entry) {
            final int groupIndex = entry.key;
            final List<int> groupIndices = entry.value;

            final Widget groupWidget = _buildGroup(groupIndices, context);

            // Insert separator (-) if not the last group
            if (groupIndex < groups.length - 1) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  groupWidget,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Text(
                      '-',
                      // Use textTheme so textScaler and font family compose correctly.
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: widget.disabled
                                ? Colors.grey.shade400
                                : Colors.grey.shade500,
                          ),
                    ),
                  ),
                ],
              );
            }
            return groupWidget;
          }).toList(),
        ),

        // TRANSPARENT TEXT FIELD (To Capture Input & Keyboard)
        Positioned.fill(
          child: Opacity(
            opacity: 0.01,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !widget.disabled,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: widget.length,
              showCursor: false,
              enableInteractiveSelection: false,
              style: const TextStyle(
                color: Colors.transparent,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // MAGIC LAYER: Render one by one in Stack so they don't overlap
  // ==========================================
  Widget _buildGroup(List<int> groupIndices, BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final List<Widget> slots = [];
    Widget? activeSlot; // Saved to be rendered last (topmost)

    for (int i = 0; i < groupIndices.length; i++) {
      final int globalIndex = groupIndices[i];
      final bool isFirst = i == 0;
      final bool isLast = i == groupIndices.length - 1;

      // Active Logic: Index equals text length (or last slot if full)
      bool isActive = false;
      if (_focusNode.hasFocus) {
        if (_controller.text.length == globalIndex) {
          isActive = true;
        } else if (_controller.text.length == widget.length &&
            globalIndex == widget.length - 1) {
          isActive = true;
        }
      }

      final bool isFilled = _controller.text.length > globalIndex;
      final String char = isFilled ? _controller.text[globalIndex] : '';

      Color borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
      Color textColor = theme.colorScheme.onSurface;
      // Must be solid so it doesn't obscure the stacked border
      Color backgroundColor = theme.colorScheme.surface;
      List<BoxShadow>? focusRing;

      if (widget.disabled) {
        textColor = isDark ? Colors.grey.shade600 : Colors.grey.shade400;
        backgroundColor = isDark ? Colors.grey.shade900 : Colors.grey.shade100;
      } else if (widget.isInvalid) {
        borderColor = Colors.red.shade600;
        if (isActive) {
          focusRing = [
            BoxShadow(
              color: Colors.red.shade600.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 0,
            ),
          ];
        }
      } else if (isActive) {
        borderColor = theme.colorScheme.onSurface;
        focusRing = [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
            spreadRadius: 2,
            blurRadius: 0,
          ),
        ];
      }

      BorderRadius radius = BorderRadius.zero;
      if (isFirst && isLast) {
        radius = BorderRadius.circular(_defaultRadius);
      } else if (isFirst) {
        radius = const BorderRadius.horizontal(
          left: Radius.circular(_defaultRadius),
        );
      } else if (isLast) {
        radius = const BorderRadius.horizontal(
          right: Radius.circular(_defaultRadius),
        );
      }

      // Shift each box to the left by 1 pixel precisely (44 - 1 = 43)
      final slotWidget = Positioned(
        left: i * 43.0,
        top: 0,
        bottom: 0,
        child: Container(
          width: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            borderRadius: radius,
            boxShadow: focusRing,
          ),
          child: Text(
            char,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      );

      // Split active slot to be placed at the end of the array
      if (isActive) {
        activeSlot = slotWidget;
      } else {
        slots.add(slotWidget);
      }
    }

    // Add active slot at the end so the glow & border cover the adjacent box border!
    if (activeSlot != null) slots.add(activeSlot);

    // Calculate total width of the group precisely
    final double groupWidth =
        groupIndices.length * 44.0 - (groupIndices.length - 1) * 1.0;

    return SizedBox(
      width: groupWidth,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none, // Allow glow to pass through the boundary
        children: slots,
      ),
    );
  }
}
