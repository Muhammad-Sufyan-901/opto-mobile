import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/widgets/calendars/app_calendar.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_bloc.dart';
import 'package:opto/features/consultation/presentation/cubit/booking_cubit.dart';

/// Screen C3 — Choose a Time.
///
/// Receives `Map<String, dynamic> {'doctor': DoctorEntity, 'mode': ConsultMode}`
/// via GoRouter [state.extra].
///
/// Loads availability via [DoctorSearchBloc], groups slots by date into a
/// horizontal date strip + 3-column slot grid. "Continue" fires
/// [BookingCubit.selectSlot] + [BookingCubit.confirmBooking] in the background
/// and navigates to the Pre-consult Intake screen (C4).
class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final doctor = extra['doctor'] as DoctorEntity;
    final mode = extra['mode'] as ConsultMode? ?? ConsultMode.voice;

    return MultiBlocProvider(
      providers: [
        BlocProvider<DoctorSearchBloc>(
          create: (_) => sl<DoctorSearchBloc>()
            ..add(DoctorSearchEvent.loadAvailability(doctor.id)),
        ),
        BlocProvider<BookingCubit>(
          create: (_) => sl<BookingCubit>(),
        ),
      ],
      child: _BookingView(doctor: doctor, mode: mode),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _BookingView extends StatefulWidget {
  const _BookingView({required this.doctor, required this.mode});

  final DoctorEntity doctor;
  final ConsultMode mode;

  @override
  State<_BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<_BookingView> {
  /// Index into [_dateGroups] — the selected date column.
  int _selectedDateIdx = 0;

  /// The slot the user has tapped in the current date's grid.
  DoctorAvailabilityEntity? _selectedSlot;

  /// When true, the booking listener will navigate to the chat room once
  /// [BookingConfirmed] arrives (Text-chat mode only).
  bool _pendingChatNav = false;

  /// Availability slots grouped by calendar day.
  List<_DateGroup> _dateGroups = [];

  /// The date selected from the calendar widget.
  DateTime? _calendarSelectedDate;

  /// Controllers for the HH:MM time input.
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final FocusNode _hourFocus = FocusNode();
  final FocusNode _minuteFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _calendarSelectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Choose a time. Select a date and time slot for your consultation with ${widget.doctor.fullName ?? 'the doctor'}.');
    });
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _hourFocus.dispose();
    _minuteFocus.dispose();
    super.dispose();
  }

  /// Called when the user picks a date from the calendar.
  void _onCalendarDateChanged(DateTime date) {
    setState(() {
      _calendarSelectedDate = date;
      _selectedSlot = null;
    });

    // Find matching date group index
    for (int i = 0; i < _dateGroups.length; i++) {
      final g = _dateGroups[i];
      if (g.date.year == date.year &&
          g.date.month == date.month &&
          g.date.day == date.day) {
        setState(() => _selectedDateIdx = i);
        return;
      }
    }

    SemanticsService.announce(
      'Selected ${_monthName(date.month)} ${date.day}, ${date.year}.',
      TextDirection.ltr,
    );
  }

  /// Applies the manually entered time to pick a matching slot.
  void _applyManualTime() {
    final hourText = _hourController.text.trim();
    final minuteText = _minuteController.text.trim();
    if (hourText.isEmpty || minuteText.isEmpty) return;

    final hour = int.tryParse(hourText);
    final minute = int.tryParse(minuteText);
    if (hour == null || minute == null) return;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return;

    final timeLabel =
        '${hourText.padLeft(2, '0')}:${minuteText.padLeft(2, '0')}';

    // Try to find an exact match in the loaded slot grid first.
    if (_dateGroups.isNotEmpty) {
      final currentGroup = _dateGroups[_selectedDateIdx];
      for (final slot in currentGroup.slots) {
        final local = slot.slotStart.toLocal();
        if (local.hour == hour && local.minute == minute && !slot.isBooked) {
          HapticPatterns.focusTick();
          setState(() => _selectedSlot = slot);
          SemanticsService.announce(
            '$timeLabel selected.',
            TextDirection.ltr,
          );
          return;
        }
      }
    }

    // No pre-existing slot matched — build a synthetic one from the calendar
    // date and entered time so the Continue button becomes enabled.
    final base = _calendarSelectedDate ?? DateTime.now();
    final slotStart = DateTime(base.year, base.month, base.day, hour, minute);
    final syntheticSlot = DoctorAvailabilityEntity(
      id: 'manual-${slotStart.millisecondsSinceEpoch}',
      doctorId: widget.doctor.id,
      slotStart: slotStart,
      slotEnd: slotStart.add(const Duration(minutes: 30)),
      isBooked: false,
    );

    HapticPatterns.focusTick();
    setState(() => _selectedSlot = syntheticSlot);
    SemanticsService.announce(
      '$timeLabel on ${_monthName(base.month)} ${base.day} selected.',
      TextDirection.ltr,
    );
  }

  void _buildGroups(List<DoctorAvailabilityEntity> slots) {
    final Map<String, List<DoctorAvailabilityEntity>> byDay = {};
    for (final s in slots) {
      final local = s.slotStart.toLocal();
      final key =
          '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
      byDay.putIfAbsent(key, () => []).add(s);
    }
    final groups = byDay.entries.map((e) {
      final date = DateTime.parse(e.key);
      final sorted = List<DoctorAvailabilityEntity>.from(e.value)
        ..sort((a, b) => a.slotStart.compareTo(b.slotStart));
      return _DateGroup(date: date, slots: sorted);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (mounted) {
      setState(() {
        _dateGroups = groups;
        _selectedDateIdx = 0;
        _selectedSlot = null;
      });
    }
  }

  /// Fallback: generate mock dates + slots when the backend returns nothing.
  void _buildMockGroups() {
    final now = DateTime.now();
    final groups = <_DateGroup>[];
    for (int d = 0; d < 5; d++) {
      final date = now.add(Duration(days: d));
      final slots = <DoctorAvailabilityEntity>[];
      // Morning: 08:00 – 11:30 every 30 min
      for (int h = 8; h <= 11; h++) {
        for (int m = 0; m < 60; m += 30) {
          final start = DateTime(date.year, date.month, date.day, h, m);
          slots.add(DoctorAvailabilityEntity(
            id: 'mock-$d-$h-$m',
            doctorId: widget.doctor.id,
            slotStart: start,
            slotEnd: start.add(const Duration(minutes: 30)),
            isBooked: (h == 8 && m == 0 && d == 0), // first slot of today booked
          ));
        }
      }
      // Afternoon: 13:00 – 15:30
      for (int h = 13; h <= 15; h++) {
        for (int m = 0; m < 60; m += 30) {
          if (h == 15 && m == 30) continue;
          final start = DateTime(date.year, date.month, date.day, h, m);
          slots.add(DoctorAvailabilityEntity(
            id: 'mock-$d-$h-$m',
            doctorId: widget.doctor.id,
            slotStart: start,
            slotEnd: start.add(const Duration(minutes: 30)),
            isBooked: false,
          ));
        }
      }
      groups.add(_DateGroup(date: date, slots: slots));
    }
    if (mounted) {
      setState(() {
        _dateGroups = groups;
        _selectedDateIdx = 0;
        _selectedSlot = null;
      });
    }
  }

  String _modeName(ConsultMode m) {
    switch (m) {
      case ConsultMode.voice:
        return 'Voice call';
      case ConsultMode.video:
        return 'Video call';
      case ConsultMode.nonVerbal:
        return 'Text chat';
      case ConsultMode.inPerson:
        return 'In-person';
    }
  }

  IconData _modeIcon(ConsultMode m) {
    switch (m) {
      case ConsultMode.voice:
        return Icons.call_rounded;
      case ConsultMode.video:
        return Icons.videocam_outlined;
      case ConsultMode.nonVerbal:
        return Icons.chat_bubble_outline_rounded;
      case ConsultMode.inPerson:
        return Icons.local_hospital_outlined;
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.toLocal().hour.toString().padLeft(2, '0');
    final m = dt.toLocal().minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatSlotLabel(DoctorAvailabilityEntity slot) {
    final local = slot.slotStart.toLocal();
    final day = _dayName(local.weekday);
    final month = _monthName(local.month);
    return '$day, $month ${local.day}';
  }

  String _dayName(int wd) {
    const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return d[(wd - 1).clamp(0, 6)];
  }

  String _monthName(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[(m - 1).clamp(0, 11)];
  }

  void _onContinue() {
    if (_selectedSlot == null) {
      SemanticsService.announce(
          'Please select a time slot first.', TextDirection.ltr);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot.')),
      );
      return;
    }
    HapticPatterns.focusTick();

    // Fire booking in background (best-effort — UI flow does not block on it).
    context.read<BookingCubit>().selectSlot(
          _selectedSlot!,
          mode: widget.mode,
        );
    context.read<BookingCubit>().confirmBooking(doctorId: widget.doctor.id);

    // Navigate based on selected consultation mode.
    switch (widget.mode) {
      case ConsultMode.nonVerbal:
        // Text chat: set a pending flag so the BlocListener navigates to the
        // chatroom once BookingConfirmed arrives with the real booking id.
        // We must NOT navigate immediately because booking confirmation is
        // asynchronous and the chat screen's RLS check requires a committed
        // consultation_bookings row (can_access_booking).
        setState(() => _pendingChatNav = true);
      case ConsultMode.voice:
      case ConsultMode.video:
      case ConsultMode.inPerson:
        // All other modes go through the pre-consult intake screen first.
        SemanticsService.announce(
          'Proceeding to pre-consult intake.',
          TextDirection.ltr,
        );
        context.push(
          AppRoutes.consultIntake.path,
          extra: {
            'doctor': widget.doctor,
            'mode': widget.mode,
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingError) {
          // Reset the pending chat nav so the user can retry.
          if (_pendingChatNav) setState(() => _pendingChatNav = false);
          SemanticsService.announce(state.message, TextDirection.ltr);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is BookingConfirmed && _pendingChatNav) {
          // Booking row now exists in the DB — RLS will pass.
          setState(() => _pendingChatNav = false);
          SemanticsService.announce(
            'Opening text chat session with ${widget.doctor.fullName ?? 'your doctor'}.',
            TextDirection.ltr,
          );
          context.push(
            AppRoutes.consultChat.path,
            extra: {
              'doctor': widget.doctor,
              'bookingId': state.booking.id,
            },
          );
        }
      },
      child: BlocListener<DoctorSearchBloc, DoctorSearchState>(
        listener: (context, state) {
          if (state is DoctorSearchLoaded) {
            if (state.availability.isEmpty) {
              _buildMockGroups();
            } else {
              _buildGroups(state.availability);
            }
          }
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          body: Column(
            children: [
              // ── Scrollable body ──────────────────────────────────────────
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── App bar ────────────────────────────────────────
                        _AppBar(cs: cs, theme: theme),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: AppDimensions.space12),

                              // ── Doctor recap ───────────────────────────
                              _DoctorRecap(
                                doctor: widget.doctor,
                                modeName: _modeName(widget.mode),
                                modeIcon: _modeIcon(widget.mode),
                                cs: cs,
                                ext: ext,
                                theme: theme,
                              ),

                              const SizedBox(height: AppDimensions.space20),

                              // ── Time input with ":" separator ────────
                              _SectionLabel(
                                label: 'SELECT TIME',
                                cs: cs,
                                theme: theme,
                              ),
                              const SizedBox(height: AppDimensions.space12),

                              _TimeInputField(
                                hourController: _hourController,
                                minuteController: _minuteController,
                                hourFocus: _hourFocus,
                                minuteFocus: _minuteFocus,
                                onSubmitted: _applyManualTime,
                                cs: cs,
                                ext: ext,
                                theme: theme,
                              ),

                              const SizedBox(height: AppDimensions.space20),

                              // ── Slot grid ──────────────────────────────
                              if (_dateGroups.isNotEmpty) ...[
                                _SlotSection(
                                  label: _dateGroups.isNotEmpty
                                      ? 'MORNING · ${_formatSlotLabel(_dateGroups[_selectedDateIdx].slots.first)}'
                                      : 'MORNING',
                                  slots: _dateGroups[_selectedDateIdx].morning,
                                  selectedSlot: _selectedSlot,
                                  onSlotTap: (s) {
                                    HapticPatterns.focusTick();
                                    setState(() {
                                      _selectedSlot = s;
                                      _hourController.text = s.slotStart.toLocal().hour.toString().padLeft(2, '0');
                                      _minuteController.text = s.slotStart.toLocal().minute.toString().padLeft(2, '0');
                                    });
                                    SemanticsService.announce(
                                      '${_formatTime(s.slotStart)} selected.',
                                      TextDirection.ltr,
                                    );
                                  },
                                  cs: cs,
                                  ext: ext,
                                  theme: theme,
                                ),

                                const SizedBox(height: AppDimensions.space20),

                                _SlotSection(
                                  label: 'AFTERNOON',
                                  slots: _dateGroups[_selectedDateIdx].afternoon,
                                  selectedSlot: _selectedSlot,
                                  onSlotTap: (s) {
                                    HapticPatterns.focusTick();
                                    setState(() {
                                      _selectedSlot = s;
                                      _hourController.text = s.slotStart.toLocal().hour.toString().padLeft(2, '0');
                                      _minuteController.text = s.slotStart.toLocal().minute.toString().padLeft(2, '0');
                                    });
                                    SemanticsService.announce(
                                      '${_formatTime(s.slotStart)} selected.',
                                      TextDirection.ltr,
                                    );
                                  },
                                  cs: cs,
                                  ext: ext,
                                  theme: theme,
                                ),

                                const SizedBox(height: AppDimensions.space20),
                              ],

                              // ── Calendar widget ─────────────────────────
                              _SectionLabel(
                                label: 'SELECT A DATE',
                                cs: cs,
                                theme: theme,
                              ),
                              const SizedBox(height: AppDimensions.space12),

                              Center(
                                child: AppCalendar(
                                  mode: AppCalendarMode.single,
                                  initialDate: DateTime.now(),
                                  selectedDate: _calendarSelectedDate,
                                  onDateChanged: _onCalendarDateChanged,
                                  selectableDayPredicate: (date) {
                                    // Only allow today and future dates
                                    final now = DateTime.now();
                                    final today = DateTime(now.year, now.month, now.day);
                                    return !date.isBefore(today);
                                  },
                                ),
                              ),

                              const SizedBox(height: AppDimensions.space32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Sticky bottom bar ──────────────────────────────────────
              SafeArea(
                top: false,
                child: _BottomBar(
                  selectedSlot: _selectedSlot,
                  formatSlotLabel: _formatSlotLabel,
                  formatTime: _formatTime,
                  onContinue: _onContinue,
                  cs: cs,
                  ext: ext,
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _AppBar extends StatelessWidget {
  const _AppBar({required this.cs, required this.theme});

  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) context.pop();
              },
              child: SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.chevron_left_rounded,
                        size: 28, color: cs.onSurface),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                'Choose a Time',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Listen to available times',
            child: GestureDetector(
              onTap: () {
                HapticPatterns.focusTick();
                SemanticsService.announce(
                  'Choose a Time. Select a date from the horizontal list, then choose a time slot from the grid below.',
                  TextDirection.ltr,
                );
              },
              child: Container(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<AppExtendedCustomColors>()
                      ?.blueTint,
                  shape: BoxShape.circle,
                ),
                child: ExcludeSemantics(
                  child: Icon(Icons.volume_up_outlined,
                      size: AppDimensions.iconLg, color: cs.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorRecap extends StatelessWidget {
  const _DoctorRecap({
    required this.doctor,
    required this.modeName,
    required this.modeIcon,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final DoctorEntity doctor;
  final String modeName;
  final IconData modeIcon;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  String get _initials {
    final name = doctor.fullName;
    if (name == null || name.trim().isEmpty) return 'DR';
    return name.trim().split(' ').take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: '${doctor.fullName ?? 'Doctor'}. $modeName · 30 min.',
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ext?.blueTint ?? cs.primaryContainer,
            borderRadius: BorderRadius.circular(22),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: cs.primary,
                  backgroundImage: doctor.avatarUrl != null
                      ? NetworkImage(doctor.avatarUrl!)
                      : null,
                  child: doctor.avatarUrl == null
                      ? Text(_initials,
                          style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white))
                      : null,
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.fullName ?? 'Doctor',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(modeIcon, size: 15, color: ext?.ink2 ?? cs.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(
                            '$modeName · 30 min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ext?.ink2 ?? cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.cs,
    required this.theme,
  });

  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _TimeInputField extends StatelessWidget {
  const _TimeInputField({
    required this.hourController,
    required this.minuteController,
    required this.hourFocus,
    required this.minuteFocus,
    required this.onSubmitted,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final TextEditingController hourController;
  final TextEditingController minuteController;
  final FocusNode hourFocus;
  final FocusNode minuteFocus;
  final VoidCallback onSubmitted;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    return Semantics(
      label: 'Enter appointment time. Hours and minutes separated by colon.',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Clock icon
            ExcludeSemantics(
              child: Icon(
                Icons.access_time_rounded,
                size: AppDimensions.iconLg,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 16),

            // Hour field
            SizedBox(
              width: 56,
              child: ExcludeSemantics(
                child: TextField(
                  controller: hourController,
                  focusNode: hourFocus,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _TimeValueFormatter(max: 23),
                  ],
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: 2,
                    fontSize: 28,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '00',
                    hintStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: (ext?.ink3 ?? cs.onSurfaceVariant)
                          .withValues(alpha: 0.35),
                      letterSpacing: 2,
                      fontSize: 28,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    filled: true,
                    fillColor: cs.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: line, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: line, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: cs.primary, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 2) {
                      minuteFocus.requestFocus();
                    }
                  },
                  onSubmitted: (_) => onSubmitted(),
                ),
              ),
            ),

            // Colon separator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ExcludeSemantics(
                child: Text(
                  ':',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.primary,
                    fontSize: 32,
                  ),
                ),
              ),
            ),

            // Minute field
            SizedBox(
              width: 56,
              child: ExcludeSemantics(
                child: TextField(
                  controller: minuteController,
                  focusNode: minuteFocus,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _TimeValueFormatter(max: 59),
                  ],
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: 2,
                    fontSize: 28,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '00',
                    hintStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: (ext?.ink3 ?? cs.onSurfaceVariant)
                          .withValues(alpha: 0.35),
                      letterSpacing: 2,
                      fontSize: 28,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    filled: true,
                    fillColor: cs.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: line, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: line, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: cs.primary, width: 2),
                    ),
                  ),
                  onSubmitted: (_) => onSubmitted(),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Apply button
            Semantics(
              button: true,
              label: 'Apply entered time',
              child: GestureDetector(
                onTap: onSubmitted,
                child: Container(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const ExcludeSemantics(
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formatter that clamps numeric input to a maximum value (e.g. 23 for hours, 59 for minutes).
class _TimeValueFormatter extends TextInputFormatter {
  _TimeValueFormatter({required this.max});

  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final intVal = int.tryParse(newValue.text);
    if (intVal == null) return oldValue;
    if (intVal > max) return oldValue;
    return newValue;
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({
    required this.groups,
    required this.selectedIdx,
    required this.onSelect,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final List<_DateGroup> groups;
  final int selectedIdx;
  final ValueChanged<int> onSelect;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  String _weekday(int wd) {
    const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return d[(wd - 1).clamp(0, 6)];
  }

  String _month(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[(m - 1).clamp(0, 11)];
  }

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return _weekday(date.weekday);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < groups.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Semantics(
                button: true,
                selected: i == selectedIdx,
                label: '${_dayLabel(groups[i].date)} ${groups[i].date.day} ${_month(groups[i].date.month)}.'
                    ' ${groups[i].available} slots available.'
                    '${i == selectedIdx ? ' Selected.' : ''}',
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 68,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: i == selectedIdx
                          ? cs.primary
                          : (ext?.blueTint ?? cs.primaryContainer),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: i == selectedIdx
                            ? cs.primary
                            : (ext?.line ?? cs.outline),
                        width: 1.5,
                      ),
                    ),
                    child: ExcludeSemantics(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _dayLabel(groups[i].date).toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: i == selectedIdx
                                  ? Colors.white
                                  : (ext?.ink3 ?? cs.onSurfaceVariant),
                              letterSpacing: 0.5,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${groups[i].date.day}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: i == selectedIdx
                                  ? Colors.white
                                  : cs.onSurface,
                              letterSpacing: -0.5,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _month(groups[i].date.month),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: i == selectedIdx
                                  ? Colors.white
                                  : (ext?.ink3 ?? cs.onSurfaceVariant),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateStripSkeleton extends StatelessWidget {
  const _DateStripSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (i) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 68,
            height: 86,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotSection extends StatelessWidget {
  const _SlotSection({
    required this.label,
    required this.slots,
    required this.selectedSlot,
    required this.onSlotTap,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final String label;
  final List<DoctorAvailabilityEntity> slots;
  final DoctorAvailabilityEntity? selectedSlot;
  final ValueChanged<DoctorAvailabilityEntity> onSlotTap;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  String _fmt(DateTime dt) {
    final h = dt.toLocal().hour.toString().padLeft(2, '0');
    final m = dt.toLocal().minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.3,
          ),
          itemCount: slots.length,
          itemBuilder: (ctx, i) {
            final slot = slots[i];
            final isBooked = slot.isBooked;
            final isSelected = selectedSlot?.id == slot.id;
            final timeStr = _fmt(slot.slotStart);

            return Semantics(
              button: !isBooked,
              label: isBooked
                  ? '$timeStr, unavailable'
                  : isSelected
                      ? '$timeStr, selected'
                      : timeStr,
              child: GestureDetector(
                onTap: isBooked ? null : () => onSlotTap(slot),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 130),
                  decoration: BoxDecoration(
                    color: isBooked
                        ? cs.surface
                        : isSelected
                            ? cs.primary
                            : (ext?.blueTint ?? cs.primaryContainer),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isBooked
                          ? (ext?.line ?? cs.outline).withValues(alpha: 0.4)
                          : isSelected
                              ? cs.primary
                              : (ext?.line ?? cs.outline),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: ExcludeSemantics(
                    child: Center(
                      child: Text(
                        timeStr,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isBooked
                              ? (ext?.ink3 ?? cs.onSurfaceVariant)
                                  .withValues(alpha: 0.42)
                              : isSelected
                                  ? Colors.white
                                  : cs.onSurface,
                          decoration: isBooked
                              ? TextDecoration.lineThrough
                              : null,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.selectedSlot,
    required this.formatSlotLabel,
    required this.formatTime,
    required this.onContinue,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final DoctorAvailabilityEntity? selectedSlot;
  final String Function(DoctorAvailabilityEntity) formatSlotLabel;
  final String Function(DateTime) formatTime;
  final VoidCallback onContinue;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color line = ext?.line ?? cs.outline;
    final hasSlot = selectedSlot != null;
    final String dateStr =
        hasSlot ? formatSlotLabel(selectedSlot!) : '—';
    final String timeStr =
        hasSlot ? formatTime(selectedSlot!.slotStart) : '— : —';

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        14,
        AppDimensions.screenPadding,
        14,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: line, width: 1.5)),
      ),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dateStr,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ext?.ink3 ?? cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  timeStr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: -0.3,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          Expanded(
            child: Semantics(
              button: true,
              label: hasSlot
                  ? 'Continue. $dateStr at $timeStr.'
                  : 'Select a time slot to continue.',
              child: SizedBox(
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: hasSlot ? onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        cs.primary.withValues(alpha: 0.35),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusButton),
                    ),
                  ),
                  child: const ExcludeSemantics(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Continue',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DATA CLASSES
// =============================================================================

class _DateGroup {
  const _DateGroup({required this.date, required this.slots});

  final DateTime date;
  final List<DoctorAvailabilityEntity> slots;

  int get available => slots.where((s) => !s.isBooked).length;

  List<DoctorAvailabilityEntity> get morning =>
      slots.where((s) => s.slotStart.toLocal().hour < 12).toList();

  List<DoctorAvailabilityEntity> get afternoon =>
      slots.where((s) => s.slotStart.toLocal().hour >= 12).toList();
}
