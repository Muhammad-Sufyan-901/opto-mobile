import 'package:flutter/material.dart';

// ==========================================
// DEFAULT CONSTANTS
// ==========================================
const double _thumbSize = 20.0;
const double _trackThickness = 8.0;

class AppSlider extends StatefulWidget {
  final List<double> values;
  final double min;
  final double max;
  final ValueChanged<List<double>>? onChanged;
  final bool disabled;
  final bool isVertical;
  final Color? color;

  const AppSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.disabled = false,
    this.isVertical = false,
    this.color,
  });

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> {
  int? _activeThumbIndex;

  double _getPercentage(Offset pos, BoxConstraints constraints) {
    if (widget.isVertical) {
      return ((constraints.maxHeight - pos.dy).clamp(
            0.0,
            constraints.maxHeight,
          )) /
          constraints.maxHeight;
    }
    return (pos.dx.clamp(0.0, constraints.maxWidth)) / constraints.maxWidth;
  }

  void _handlePanStart(DragStartDetails details, BoxConstraints constraints) {
    if (widget.disabled || widget.onChanged == null || widget.values.isEmpty) {
      return;
    }

    final double tapValue =
        _getPercentage(details.localPosition, constraints) *
            (widget.max - widget.min) +
        widget.min;

    double minDistance = double.infinity;
    int closestIndex = 0;

    for (int i = 0; i < widget.values.length; i++) {
      final double dist = (widget.values[i] - tapValue).abs();
      if (dist < minDistance) {
        minDistance = dist;
        closestIndex = i;
      }
    }

    _activeThumbIndex = closestIndex;
    _updateThumb(tapValue);
  }

  void _handlePanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (widget.disabled ||
        widget.onChanged == null ||
        _activeThumbIndex == null) {
      return;
    }
    final double newValue =
        _getPercentage(details.localPosition, constraints) *
            (widget.max - widget.min) +
        widget.min;
    _updateThumb(newValue);
  }

  void _updateThumb(double newValue) {
    final newValues = List<double>.from(widget.values);
    newValues[_activeThumbIndex!] = newValue.clamp(widget.min, widget.max);
    widget.onChanged!(newValues);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    Color resolvedTrackColor = isDark
        ? Colors.grey.shade800
        : Colors.grey.shade200;
    Color resolvedActiveTrackColor =
        widget.color ?? theme.colorScheme.onSurface;
    Color resolvedThumbBorderColor = Colors.grey.shade400;

    if (widget.disabled) {
      resolvedActiveTrackColor = isDark
          ? Colors.grey.shade600
          : Colors.grey.shade400;
      resolvedThumbBorderColor = isDark
          ? Colors.grey.shade700
          : Colors.grey.shade300;
    }

    final double trackMargin = (_thumbSize - _trackThickness) / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double length = widget.isVertical
            ? constraints.maxHeight
            : constraints.maxWidth;
        final List<double> sortedValues = List.from(widget.values)..sort();

        final double activeStartVal = widget.values.length == 1
            ? widget.min
            : sortedValues.first;
        final double activeEndVal = sortedValues.isNotEmpty
            ? sortedValues.last
            : widget.min;

        final double startPx =
            ((activeStartVal - widget.min) / (widget.max - widget.min)) *
            length;
        final double endPx =
            ((activeEndVal - widget.min) / (widget.max - widget.min)) * length;
        final double activeLengthPx = endPx - startPx;

        return GestureDetector(
          onHorizontalDragStart: widget.isVertical
              ? null
              : (details) => _handlePanStart(details, constraints),
          onHorizontalDragUpdate: widget.isVertical
              ? null
              : (details) => _handlePanUpdate(details, constraints),
          onHorizontalDragEnd: widget.isVertical
              ? null
              : (_) => _activeThumbIndex = null,

          onVerticalDragStart: widget.isVertical
              ? (details) => _handlePanStart(details, constraints)
              : null,
          onVerticalDragUpdate: widget.isVertical
              ? (details) => _handlePanUpdate(details, constraints)
              : null,
          onVerticalDragEnd: widget.isVertical
              ? (_) => _activeThumbIndex = null
              : null,

          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: widget.isVertical ? _thumbSize : double.infinity,
            height: widget.isVertical ? double.infinity : _thumbSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: widget.isVertical ? trackMargin : 0,
                  right: widget.isVertical ? trackMargin : 0,
                  top: widget.isVertical ? 0 : trackMargin,
                  bottom: widget.isVertical ? 0 : trackMargin,
                  child: Container(
                    decoration: BoxDecoration(
                      color: resolvedTrackColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                Positioned(
                  left: widget.isVertical ? trackMargin : startPx,
                  right: widget.isVertical ? trackMargin : null,
                  bottom: widget.isVertical ? startPx : trackMargin,
                  top: widget.isVertical ? null : trackMargin,
                  width: widget.isVertical ? null : activeLengthPx,
                  height: widget.isVertical ? activeLengthPx : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          resolvedActiveTrackColor, // ➔ ✨ Warna custom diterapkan di sini!
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                ...widget.values.map((val) {
                  final double px =
                      ((val - widget.min) / (widget.max - widget.min)) * length;
                  return Positioned(
                    left: widget.isVertical ? 0 : px - (_thumbSize / 2),
                    bottom: widget.isVertical ? px - (_thumbSize / 2) : 0,
                    child: Container(
                      width: _thumbSize,
                      height: _thumbSize,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.color ?? resolvedThumbBorderColor,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
