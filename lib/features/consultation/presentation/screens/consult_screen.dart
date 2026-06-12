import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_bloc.dart';
import 'package:opto/features/consultation/presentation/cubit/booking_cubit.dart';
import 'package:opto/features/consultation/presentation/widgets/doctor_card.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen 18 — Health & Consultation
///
/// Accessibility-first consultation hub showing the user's next appointment,
/// available doctors, and a booking CTA.
///
/// Layout: white Scaffold, SafeArea + SingleChildScrollView,
/// bottom nav active at index 3 (Consult).
///
/// BLoC providers are injected here at the outer [StatelessWidget] shell;
/// the inner [_ConsultView] consumes them.
class ConsultScreen extends StatelessWidget {
  const ConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DoctorSearchBloc>(
          create: (_) => sl<DoctorSearchBloc>()
            ..add(const DoctorSearchEvent.loadDoctors()),
        ),
        BlocProvider<BookingCubit>(
          create: (_) => sl<BookingCubit>()..loadMyBookings(),
        ),
      ],
      child: const _ConsultView(),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _ConsultView extends StatefulWidget {
  const _ConsultView();

  @override
  State<_ConsultView> createState() => _ConsultViewState();
}

class _ConsultViewState extends State<_ConsultView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Consult. Next appointment in 2 hours with Dr. Anwar Anggara.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Scaffold(
      backgroundColor: cs.surface,
      bottomNavigationBar: const HomeBottomNav(activeTab: 3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 22,
              right: 22,
              top: 14,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Screen header ──────────────────────────────────────────
                _ScreenHeader(cs: cs, ext: ext),

                const SizedBox(height: 12),

                // ── Next appointment card ──────────────────────────────────
                _AppointmentCard(cs: cs, ext: ext),

                const SizedBox(height: AppDimensions.sectionGap),

                // ── "AVAILABLE NOW" section label ──────────────────────────
                _SectionLabel(cs: cs),

                const SizedBox(height: AppDimensions.space12),

                // ── Doctor list (real data from DoctorSearchBloc) ──────────
                BlocBuilder<DoctorSearchBloc, DoctorSearchState>(
                  builder: (context, state) {
                    if (state is DoctorSearchLoading ||
                        state is DoctorSearchInitial) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state is DoctorSearchError) {
                      return Column(
                        children: [
                          Text(
                            state.message,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: cs.error),
                          ),
                          const SizedBox(height: 12),
                          Semantics(
                            button: true,
                            label: 'Retry loading doctors',
                            child: TextButton(
                              onPressed: () => context
                                  .read<DoctorSearchBloc>()
                                  .add(const DoctorSearchEvent.loadDoctors()),
                              child: const Text('Retry'),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is DoctorSearchLoaded) {
                      if (state.doctors.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                              child: Text('No doctors available.')),
                        );
                      }
                      return Column(
                        children: [
                          for (final doctor in state.doctors)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppDimensions.space12),
                              child: DoctorCard(doctor: doctor),
                            ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 18),

                // ── Book a new appointment CTA ─────────────────────────────
                _BookCta(cs: cs),
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

/// Top row: back chevron (left) · "Consult" title (center) · calendar circle (right).
class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.cs, required this.ext});

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;

    return Row(
      children: [
        // ── Back button ──────────────────────────────────────────────────
        Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home.path);
              }
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

        // ── Title (centered) ─────────────────────────────────────────────
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              'Consult',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),

        // ── Calendar icon circle ─────────────────────────────────────────
        Semantics(
          button: true,
          label: 'Open calendar',
          child: GestureDetector(
            onTap: () {
              // TODO(consult): open appointment calendar view
            },
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Container(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    decoration: BoxDecoration(
                      color: blueTint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 22,
                      color: blueStrong,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Appointment card showing the next scheduled consultation with join + message actions.
class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.cs, required this.ext});

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color line = ext?.line ?? cs.outline;

    return Container(
      decoration: BoxDecoration(
        color: blueTint,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.22),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Eyebrow text ───────────────────────────────────────────────
          ExcludeSemantics(
            child: Builder(builder: (context) {
              final theme = Theme.of(context);
              return Text(
                'NEXT APPOINTMENT · IN 2 HOURS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: blueStrong,
                ),
              );
            }),
          ),

          const SizedBox(height: 14),

          // ── Doctor info row ────────────────────────────────────────────
          ExcludeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Builder(builder: (context) {
                      final theme = Theme.of(context);
                      return Text(
                        'AA',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + role
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      final theme = Theme.of(context);
                      return Text(
                        'Dr. Anwar Anggara',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      );
                    }),
                    const SizedBox(height: 2),
                    Builder(builder: (context) {
                      final theme = Theme.of(context);
                      return Text(
                        'Ophthalmologist · Video visit',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ── Action buttons ─────────────────────────────────────────────
          Row(
            children: [
              // Join call (coming soon stub)
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'Video call with Dr. Anwar Anggara. Coming soon',
                  child: GestureDetector(
                    onTap: () {
                      HapticPatterns.focusTick();
                      SemanticsService.announce(
                        'Video calls are coming soon. You can book a non-verbal consultation instead.',
                        TextDirection.ltr,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Video calls coming soon. Try non-verbal consultation.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ExcludeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.video_call_outlined,
                              size: 22,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Builder(builder: (context) {
                              final theme = Theme.of(context);
                              return Text(
                                'Join call',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Message (ghost)
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'Message Dr. Anwar Anggara',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(consult): open message thread
                    },
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: line, width: 1.5),
                      ),
                      child: ExcludeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_outlined,
                              size: 22,
                              color: cs.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Builder(builder: (context) {
                              final theme = Theme.of(context);
                              return Text(
                                'Message',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "AVAILABLE NOW" section label row with "See all" link.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ExcludeSemantics(
          child: Text(
            'AVAILABLE NOW',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'See all doctors',
          child: GestureDetector(
            onTap: () {
              // TODO(consult): navigate to full doctor list
            },
            child: SizedBox(
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Text(
                    'See all',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dashed-border "Book a new appointment" call-to-action button.
class _BookCta extends StatelessWidget {
  const _BookCta({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Book a new appointment',
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.consultBooking.path);
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.40),
              width: 2,
            ),
          ),
          child: ExcludeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_outlined,
                  size: 22,
                  color: cs.secondary,
                ),
                const SizedBox(width: 8),
                Builder(builder: (context) {
                  final theme = Theme.of(context);
                  return Text(
                    'Book a new appointment',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.secondary,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
