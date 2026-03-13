import 'package:flutter/material.dart';

enum AppCalendarMode { single, range }

enum AppCalendarCellState {
  selected,
  rangeStart,
  rangeEnd,
  inRange,
  disabled,
  today,
  outside,
  normal,
}

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> _weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

class AppCalendar extends StatefulWidget {
  final AppCalendarMode mode;
  final DateTime initialDate;
  final DateTime? selectedDate;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final ValueChanged<DateTime>? onDateChanged;
  final void Function(DateTime start, DateTime? end)? onRangeChanged;
  final bool showMonthYearPicker;
  final bool Function(DateTime)? selectableDayPredicate;
  final Widget Function(BuildContext, DateTime, AppCalendarCellState)?
  customCellBuilder;

  const AppCalendar({
    super.key,
    this.mode = AppCalendarMode.single,
    required this.initialDate,
    this.selectedDate,
    this.rangeStart,
    this.rangeEnd,
    this.onDateChanged,
    this.onRangeChanged,
    this.showMonthYearPicker = false,
    this.selectableDayPredicate,
    this.customCellBuilder,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      1,
    );
    _selectedDate = widget.selectedDate;
    _rangeStart = widget.rangeStart;
    _rangeEnd = widget.rangeEnd;
  }

  void _changeMonth(int offset) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + offset,
        1,
      );
    });
  }

  void _setMonthYear(int year, int month) {
    setState(() {
      _displayedMonth = DateTime(year, month, 1);
    });
  }

  void _handleDateTap(DateTime date) {
    if (widget.selectableDayPredicate != null &&
        !widget.selectableDayPredicate!(date)) {
      return;
    }

    setState(() {
      if (widget.mode == AppCalendarMode.single) {
        _selectedDate = date;
        widget.onDateChanged?.call(date);
      } else {
        if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
          _rangeStart = date;
          _rangeEnd = null;
        } else if (date.isBefore(_rangeStart!)) {
          _rangeStart = date;
        } else {
          _rangeEnd = date;
        }
        widget.onRangeChanged?.call(_rangeStart!, _rangeEnd);
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  AppCalendarCellState _getCellState(DateTime date) {
    if (widget.selectableDayPredicate != null &&
        !widget.selectableDayPredicate!(date)) {
      return AppCalendarCellState.disabled;
    }
    if (date.month != _displayedMonth.month) {
      return AppCalendarCellState.outside;
    }

    if (widget.mode == AppCalendarMode.single) {
      if (_isSameDay(date, _selectedDate)) return AppCalendarCellState.selected;
    } else {
      if (_isSameDay(date, _rangeStart)) return AppCalendarCellState.rangeStart;
      if (_isSameDay(date, _rangeEnd)) return AppCalendarCellState.rangeEnd;
      if (_rangeStart != null &&
          _rangeEnd != null &&
          date.isAfter(_rangeStart!) &&
          date.isBefore(_rangeEnd!)) {
        return AppCalendarCellState.inRange;
      }
    }

    if (_isSameDay(date, DateTime.now())) return AppCalendarCellState.today;
    return AppCalendarCellState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 16),
          _buildWeekdays(theme),
          const SizedBox(height: 8),
          _buildGrid(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 20),
          onPressed: () => _changeMonth(-1),
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
          ),
        ),
        if (widget.showMonthYearPicker) ...[
          Row(
            children: [
              _buildDropdown(
                value: _displayedMonth.month,
                items: List.generate(
                  12,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(_monthNames[i]),
                  ),
                ),
                onChanged: (val) => _setMonthYear(_displayedMonth.year, val!),
                theme: theme,
              ),
              const SizedBox(width: 4),
              _buildDropdown(
                value: _displayedMonth.year,
                items: List.generate(10, (i) {
                  final y = DateTime.now().year - 5 + i;
                  return DropdownMenuItem(value: y, child: Text(y.toString()));
                }),
                onChanged: (val) => _setMonthYear(val!, _displayedMonth.month),
                theme: theme,
              ),
            ],
          ),
        ] else ...[
          Text(
            '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 20),
          onPressed: () => _changeMonth(1),
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: BorderSide(
              color: theme.dividerColor.withValues(
                alpha: 0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required ThemeData theme,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 16,
        ),
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        isDense: true,
      ),
    );
  }

  Widget _buildWeekdays(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekdays.map((day) {
        return SizedBox(
          width: 36,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid(ThemeData theme) {
    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    int startOffset = firstDayOfMonth.weekday;

    if (startOffset == 7) {
      startOffset = 0; // Sunday = 0
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2, // Tiny gap for vertical
        crossAxisSpacing: 0, // 0 spacing for connected range backgrounds
        childAspectRatio: 1,
      ),
      itemCount: 42,
      itemBuilder: (BuildContext context, int index) {
        final int day = index - startOffset + 1;
        final DateTime date = DateTime(
          firstDayOfMonth.year,
          firstDayOfMonth.month,
          day,
        );
        final AppCalendarCellState state = _getCellState(date);

        return _buildCell(date, state, theme);
      },
    );
  }

  Widget _buildCell(
    DateTime date,
    AppCalendarCellState state,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // CALENDAR CELL MAP VARIANTS
    final Map<AppCalendarCellState, Color> bgColors = {
      AppCalendarCellState.selected: colorScheme.primary,
      AppCalendarCellState.rangeStart: colorScheme.primary,
      AppCalendarCellState.rangeEnd: colorScheme.primary,
      AppCalendarCellState.inRange: isDark
          ? colorScheme.primary.withValues(
              alpha: 0.2,
            )
          : colorScheme.primary.withValues(
              alpha: 0.1,
            ),
      AppCalendarCellState.today: isDark
          ? Colors.white10
          : Colors.black.withValues(
              alpha: 0.05,
            ),
      AppCalendarCellState.disabled: Colors.transparent,
      AppCalendarCellState.outside: Colors.transparent,
      AppCalendarCellState.normal: Colors.transparent,
    };

    final Map<AppCalendarCellState, Color> textColors = {
      AppCalendarCellState.selected: colorScheme.onPrimary,
      AppCalendarCellState.rangeStart: colorScheme.onPrimary,
      AppCalendarCellState.rangeEnd: colorScheme.onPrimary,
      AppCalendarCellState.inRange: colorScheme.onSurface,
      AppCalendarCellState.today: colorScheme.onSurface,
      AppCalendarCellState.disabled: Colors.grey.shade500,
      AppCalendarCellState.outside: Colors.grey.shade400,
      AppCalendarCellState.normal: colorScheme.onSurface,
    };

    final Map<AppCalendarCellState, BorderRadius> borderRadiuses = {
      AppCalendarCellState.selected: BorderRadius.circular(8),
      AppCalendarCellState.rangeStart: const BorderRadius.horizontal(
        left: Radius.circular(8),
      ),
      AppCalendarCellState.rangeEnd: const BorderRadius.horizontal(
        right: Radius.circular(8),
      ),
      AppCalendarCellState.inRange: BorderRadius.zero,
      AppCalendarCellState.today: BorderRadius.circular(8),
      AppCalendarCellState.disabled: BorderRadius.circular(8),
      AppCalendarCellState.outside: BorderRadius.circular(8),
      AppCalendarCellState.normal: BorderRadius.circular(8),
    };

    final Map<AppCalendarCellState, TextDecoration> textDecorations = {
      AppCalendarCellState.disabled: TextDecoration.lineThrough,
      AppCalendarCellState.selected: TextDecoration.none,
      AppCalendarCellState.rangeStart: TextDecoration.none,
      AppCalendarCellState.rangeEnd: TextDecoration.none,
      AppCalendarCellState.inRange: TextDecoration.none,
      AppCalendarCellState.today: TextDecoration.none,
      AppCalendarCellState.outside: TextDecoration.none,
      AppCalendarCellState.normal: TextDecoration.none,
    };

    Widget content = widget.customCellBuilder != null
        ? widget.customCellBuilder!(context, date, state)
        : Center(
            child: Text(
              '${date.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColors[state],
                fontWeight:
                    (state == AppCalendarCellState.selected ||
                        state == AppCalendarCellState.rangeStart ||
                        state == AppCalendarCellState.rangeEnd)
                    ? FontWeight.bold
                    : FontWeight.normal,
                decoration: textDecorations[state],
              ),
            ),
          );

    return GestureDetector(
      onTap: () => _handleDateTap(date),
      child: Container(
        decoration: BoxDecoration(
          color: bgColors[state],
          borderRadius: borderRadiuses[state],
        ),
        child: content,
      ),
    );
  }
}
