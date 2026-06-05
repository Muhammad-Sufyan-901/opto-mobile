import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';
import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

/// Screen 17 — Prosthetic Hub
///
/// Accessibility-first overview of the user's ocular prosthesis care status,
/// with quick links to fitting appointments, care guides, supply ordering, and
/// specialist messaging.
///
/// Layout: white Scaffold, SafeArea + SingleChildScrollView, no bottom nav.
class ProstheticHubScreen extends StatefulWidget {
  const ProstheticHubScreen({super.key});

  @override
  State<ProstheticHubScreen> createState() => _ProstheticHubScreenState();
}

class _ProstheticHubScreenState extends State<ProstheticHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Prosthetic Hub.',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 22,
            right: 22,
            top: 14,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Screen header: back + title ───────────────────────────────
              _ScreenHeader(cs: cs),

              const SizedBox(height: 14),

              // ── Status card ───────────────────────────────────────────────
              _StatusCard(cs: cs),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── "Care & support" section label ────────────────────────────
              ExcludeSemantics(
                child: Row(
                  children: [
                    Text(
                      'CARE & SUPPORT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                        color: ext?.ink3 ?? cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.space12),

              // ── Hub link rows ─────────────────────────────────────────────
              _HubLink(
                icon: Icons.calendar_today_outlined,
                title: 'Fitting appointments',
                subtitle: '1 upcoming · Apr 18',
                onTap: () {
                  // TODO(prosthetic-hub): navigate to sub-screen
                },
              ),
              const SizedBox(height: AppDimensions.space12),
              _HubLink(
                icon: Icons.menu_book_outlined,
                title: 'Care guides',
                subtitle: 'Cleaning, handling, sleep',
                onTap: () {
                  // TODO(prosthetic-hub): navigate to sub-screen
                },
              ),
              const SizedBox(height: AppDimensions.space12),
              _HubLink(
                icon: Icons.inventory_2_outlined,
                title: 'Order supplies',
                subtitle: 'Solution, cases & cloths',
                onTap: () {
                  // TODO(prosthetic-hub): navigate to sub-screen
                },
              ),
              const SizedBox(height: AppDimensions.space12),
              _HubLink(
                icon: Icons.message_outlined,
                title: 'Message my specialist',
                subtitle: 'Dr. Anwar · usually replies same day',
                onTap: () {
                  // TODO(prosthetic-hub): navigate to sub-screen
                },
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

/// Top row: 48×48 back chevron circle on the left, centered title, 48×48
/// placeholder span on the right to keep the title visually centred.
class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Back button ────────────────────────────────────────────────────
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

        // ── Title (centered) ───────────────────────────────────────────────
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              'Prosthetic Hub',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),

        // ── Trailing placeholder (mirrors back button for visual balance) ──
        const SizedBox(
          width: AppDimensions.minTapTarget,
          height: AppDimensions.minTapTarget,
        ),
      ],
    );
  }
}

/// Blue-gradient status card showing prosthesis health and cleaning schedule.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          'Prosthetic status: Healthy. Next cleaning in 1 day. Last cleaned 6 days ago. Double tap to log care.',
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primary, cs.secondary],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.60),
              blurRadius: 30,
              offset: const Offset(0, 14),
              spreadRadius: -10,
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: Healthy chip + prosthesis type ────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Healthy" chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Healthy',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Prosthesis type
                  Text(
                    'Right eye prosthesis',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ── Title ──────────────────────────────────────────────────
              const Text(
                'Next cleaning in 1 day',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              // ── Subtitle ───────────────────────────────────────────────
              Text(
                'Last cleaned 6 days ago. Tap to log today\'s care.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.90),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              // ── "Log care" button ──────────────────────────────────────
              Semantics(
                button: true,
                label: 'Log today care',
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        // TODO(prosthetic-hub): open care logging flow
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log care',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: cs.secondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: AppDimensions.iconMd,
                              color: cs.secondary,
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
        ),
      ),
    );
  }
}

/// A single "Care & support" link row with a blue-tint icon chip, title,
/// subtitle, and a trailing chevron.
class _HubLink extends StatelessWidget {
  const _HubLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: AppDimensions.space16,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Leading icon chip (48×48, radius 13) ──────────────────
              ExcludeSemantics(
                child: Container(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, size: 22, color: blueStrong),
                ),
              ),

              const SizedBox(width: 14),

              // ── Text column ────────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: ink2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ───────────────────────────────────────
              ExcludeSemantics(
                child: Icon(Icons.chevron_right, size: 22, color: ink3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
