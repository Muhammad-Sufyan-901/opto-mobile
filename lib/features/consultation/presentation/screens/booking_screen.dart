import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/presentation/cubit/booking_cubit.dart';
import 'package:opto/features/consultation/presentation/widgets/availability_slot_list.dart';
import 'package:opto/features/consultation/presentation/widgets/booking_summary_card.dart';

/// Screen 18b — Consultation booking: slot + mode selection → confirmation.
///
/// Receives `Map<String, dynamic> {'doctor': DoctorEntity, 'slot': DoctorAvailabilityEntity}`
/// via GoRouter [state.extra].
///
/// On [BookingConfirmed] the screen pops back, announcing success and firing
/// [HapticPatterns.success].
class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final doctor = extra['doctor'] as DoctorEntity;
    final slot = extra['slot'] as DoctorAvailabilityEntity;

    return BlocProvider<BookingCubit>(
      create: (_) => sl<BookingCubit>(),
      child: _BookingView(doctor: doctor, slot: slot),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _BookingView extends StatefulWidget {
  const _BookingView({
    required this.doctor,
    required this.slot,
  });

  final DoctorEntity doctor;
  final DoctorAvailabilityEntity slot;

  @override
  State<_BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<_BookingView> {
  ConsultMode _selectedMode = ConsultMode.nonVerbal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final formatted = AvailabilitySlotList.formatSlot(widget.slot);
      announce(context, 'Book appointment. Slot on $formatted.');
      context.read<BookingCubit>().selectSlot(
            widget.slot,
            mode: _selectedMode,
          );
    });
  }

  void _selectMode(ConsultMode mode) {
    setState(() => _selectedMode = mode);
    context.read<BookingCubit>().selectSlot(widget.slot, mode: mode);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingConfirmed) {
          HapticPatterns.success();
          SemanticsService.announce(
            'Booking confirmed. Your appointment has been scheduled.',
            TextDirection.ltr,
          );
          if (context.canPop()) context.pop();
        } else if (state is BookingError) {
          SemanticsService.announce(state.message, TextDirection.ltr);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              top: 16,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Navigation header ───────────────────────────────────────
                _BookingHeader(cs: cs),
                const SizedBox(height: AppDimensions.space24),

                // ── Booking summary ─────────────────────────────────────────
                BookingSummaryCard(
                  slot: widget.slot,
                  doctor: widget.doctor,
                  mode: _selectedMode,
                ),
                const SizedBox(height: AppDimensions.space24),

                // ── Session type picker ─────────────────────────────────────
                _SectionLabel(
                  label: 'CHOOSE SESSION TYPE',
                  cs: cs,
                  theme: theme,
                ),
                const SizedBox(height: AppDimensions.space12),

                _ModeOption(
                  mode: ConsultMode.nonVerbal,
                  label: 'Non-verbal session',
                  subtitle: 'Text and audio guidance, no video',
                  icon: Icons.chat_outlined,
                  isSelected: _selectedMode == ConsultMode.nonVerbal,
                  isComingSoon: false,
                  cs: cs,
                  ext: ext,
                  theme: theme,
                  onTap: () => _selectMode(ConsultMode.nonVerbal),
                ),
                const SizedBox(height: AppDimensions.space8),

                _ModeOption(
                  mode: ConsultMode.inPerson,
                  label: 'In-person',
                  subtitle: 'Visit the clinic directly',
                  icon: Icons.local_hospital_outlined,
                  isSelected: _selectedMode == ConsultMode.inPerson,
                  isComingSoon: false,
                  cs: cs,
                  ext: ext,
                  theme: theme,
                  onTap: () => _selectMode(ConsultMode.inPerson),
                ),
                const SizedBox(height: AppDimensions.space8),

                _ModeOption(
                  mode: ConsultMode.video,
                  label: 'Video call',
                  subtitle: 'Live video with your doctor',
                  icon: Icons.videocam_outlined,
                  isSelected: _selectedMode == ConsultMode.video,
                  isComingSoon: true,
                  cs: cs,
                  ext: ext,
                  theme: theme,
                  onTap: () => _selectMode(ConsultMode.video),
                ),
                const SizedBox(height: AppDimensions.space32),

                // ── Confirm button ──────────────────────────────────────────
                BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    final bool isSubmitting = state is BookingSubmitting;
                    final String formattedSlot =
                        AvailabilitySlotList.formatSlot(widget.slot);

                    return Semantics(
                      button: true,
                      label: isSubmitting
                          ? 'Confirming booking, please wait'
                          : 'Confirm booking for slot on $formattedSlot',
                      child: SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  context.read<BookingCubit>().confirmBooking(
                                        doctorId: widget.doctor.id,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusButton,
                              ),
                            ),
                          ),
                          child: ExcludeSemantics(
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Confirm Booking',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _BookingHeader extends StatelessWidget {
  const _BookingHeader({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  child: Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              'Book Appointment',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.minTapTarget),
      ],
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
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.mode,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.isComingSoon,
    required this.cs,
    required this.ext,
    required this.theme,
    required this.onTap,
  });

  final ConsultMode mode;
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isComingSoon;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color borderColor = isSelected
        ? cs.primary
        : (ext?.line ?? cs.outline);
    final Color bgColor = isSelected
        ? cs.primary.withValues(alpha: 0.06)
        : cs.surface;

    final String semanticsLabel = '$label${isComingSoon ? ', coming soon' : ''}'
        '${isSelected ? ', selected' : ''}';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppDimensions.minTapTarget),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.space12,
            horizontal: AppDimensions.space16,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Icon(icon, size: AppDimensions.iconMd, color: cs.onSurface),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              label,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                          if (isComingSoon) ...[
                            const SizedBox(width: AppDimensions.space8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Soon',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: ink2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.space12),
                // Radio indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? cs.primary : (ext?.line ?? cs.outline),
                      width: isSelected ? 6 : 2,
                    ),
                    color: cs.surface,
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
