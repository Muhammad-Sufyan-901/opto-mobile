import 'package:flutter/material.dart';

// ==========================================
// DEFAULT CONSTANTS
// ==========================================
const double _switchWidth = 44.0;
const double _switchHeight = 24.0;
const double _thumbSize = 20.0;
const Duration _animationDuration = Duration(milliseconds: 200);

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool disabled;
  final bool isInvalid;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.disabled = false,
    this.isInvalid = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    Color trackColor;
    Color thumbColor = isDarkMode ? Colors.black : Colors.white;
    Color labelColor = colorScheme.onSurface;
    BoxBorder? trackBorder;
    List<BoxShadow>? trackShadow;

    // 1. Status Disabled (Prioritas Tertinggi)
    if (disabled) {
      labelColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;
      trackColor = value
          ? colorScheme.primary.withValues(
              alpha: 0.5,
            )
          : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200);
    }
    // 2. Status Invalid (Error / Red Ring)
    else if (isInvalid) {
      labelColor = Colors.red.shade600;
      trackColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
      trackBorder = Border.all(
        color: Colors.red.shade600,
        width: 2,
      );
      trackShadow = [
        BoxShadow(
          color: Colors.red.shade600.withValues(alpha: 0.2),
          spreadRadius: 4,
          blurRadius: 0,
        ),
      ];
    }
    // 3. Status Normal (Default)
    else {
      trackColor = value
          ? colorScheme.primary
          : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300);
    }

    // ==========================================
    // ➔ ✨ KONTEN SWITCH (Trek + Tombol Bulat)
    // ==========================================
    Widget switchToggle = AnimatedContainer(
      duration: _animationDuration,
      width: _switchWidth,
      height: _switchHeight,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(24),
        border: trackBorder,
        boxShadow: trackShadow,
      ),
      child: AnimatedAlign(
        duration: _animationDuration,
        curve: Curves.easeInOutCubic,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: _thumbSize,
          height: _thumbSize,
          decoration: BoxDecoration(
            color: thumbColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.15,
                ),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );

    // ==========================================
    // WRAPPER (Toggle + Label)
    // ==========================================
    Widget content = switchToggle;

    if (label != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          switchToggle,
          const SizedBox(
            width: 12,
          ),
          Text(
            label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: disabled ? null : () => onChanged?.call(!value),
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}
