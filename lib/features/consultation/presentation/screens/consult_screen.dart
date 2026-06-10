import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen 18 — Health & Consultation
///
/// Accessibility-first consultation hub showing the user's next appointment,
/// available doctors, and a booking CTA.
///
/// Layout: white Scaffold, SafeArea + SingleChildScrollView,
/// bottom nav active at index 3 (Consult).
class ConsultScreen extends StatefulWidget {
  const ConsultScreen({super.key});

  @override
  State<ConsultScreen> createState() => _ConsultScreenState();
}

class _ConsultScreenState extends State<ConsultScreen> {
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

                // ── Doctor list ────────────────────────────────────────────
                _DoctorRow(
                  avatarColor: const Color(0xFF1F8A5B),
                  initials: 'SR',
                  name: 'Dr. Sari Rahmawati',
                  role: 'Low-vision specialist',
                  status: 'Online',
                  cs: cs,
                  ext: ext,
                ),
                const SizedBox(height: AppDimensions.space12),
                _DoctorRow(
                  avatarColor: const Color(0xFF8A5CFF),
                  initials: 'BP',
                  name: 'Dr. Budi Pratama',
                  role: 'Prosthetic fitting',
                  status: 'Online',
                  cs: cs,
                  ext: ext,
                ),
                const SizedBox(height: AppDimensions.space12),
                _DoctorRow(
                  avatarColor: const Color(0xFFD97757),
                  initials: 'MN',
                  name: 'Dr. Maya Nuraini',
                  role: 'Optometrist',
                  status: 'In 30 min',
                  cs: cs,
                  ext: ext,
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
              // Join call (primary)
              Expanded(
                child: Semantics(
                  button: true,
                  label: 'Join video call with Dr. Anwar Anggara',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(consult): launch video call
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
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'AVAILABLE NOW',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: cs.onSurfaceVariant,
            ),
          ),
          Text(
            'See all',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single doctor row with avatar, name, role, and availability status pill.
class _DoctorRow extends StatelessWidget {
  const _DoctorRow({
    required this.avatarColor,
    required this.initials,
    required this.name,
    required this.role,
    required this.status,
    required this.cs,
    required this.ext,
  });

  final Color avatarColor;
  final String initials;
  final String name;
  final String role;
  final String status;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Semantics(
      button: true,
      label: '$name, $role, $status',
      child: GestureDetector(
        onTap: () {
          // TODO(consult): navigate to doctor profile / booking
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Builder(builder: (context) {
                      final theme = Theme.of(context);
                      return Text(
                        initials,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(builder: (context) {
                        final theme = Theme.of(context);
                        return Text(
                          name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        );
                      }),
                      const SizedBox(height: 2),
                      Builder(builder: (context) {
                        final theme = Theme.of(context);
                        return Text(
                          role,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink2,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status pill
                _StatusPill(status: status, cs: cs, ext: ext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pill-shaped availability badge — green for "Online", grey for unavailable.
class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.status,
    required this.cs,
    required this.ext,
  });

  final String status;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    final bool isOnline = status == 'Online';

    final Color bgColor = isOnline
        ? (ext?.greenTint ?? cs.secondaryContainer)
        : (ext?.line ?? cs.outline);

    final Color textColor = isOnline
        ? (ext?.green ?? cs.secondary)
        : (ext?.ink3 ?? cs.onSurfaceVariant);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Builder(builder: (context) {
        final theme = Theme.of(context);
        return Text(
          status,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        );
      }),
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
          // TODO(consult): open appointment booking flow
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
