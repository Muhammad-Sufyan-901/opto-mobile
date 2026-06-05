import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';
import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/home_bottom_nav.dart';

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
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Consult. Next appointment in 2 hours with Dr. Anwar Anggara.',
        TextDirection.ltr,
      );
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
              style: TextStyle(
                fontSize: 21,
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
            child: Text(
              'NEXT APPOINTMENT · IN 2 HOURS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: blueStrong,
              ),
            ),
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
                  child: const Center(
                    child: Text(
                      'AA',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + role
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Anwar Anggara',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ophthalmologist · Video visit',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: ink2,
                      ),
                    ),
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
                          children: const [
                            Icon(
                              Icons.video_call_outlined,
                              size: 22,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Join call',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
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
                            Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
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
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'AVAILABLE NOW',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: cs.onSurfaceVariant,
            ),
          ),
          Text(
            'See all',
            style: TextStyle(
              fontSize: 15,
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
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 14,
                          color: ink2,
                        ),
                      ),
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
      child: Text(
        status,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
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
                Text(
                  'Book a new appointment',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: cs.secondary,
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
