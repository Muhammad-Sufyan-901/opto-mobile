import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

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
      announce(context, 'Prosthetic Hub.');
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
              ProstheticHeader(title: 'Prosthetic Hub'),

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
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: ext?.ink3 ?? cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.space12),
              _HubLink(
                icon: Icons.menu_book_outlined,
                title: 'Care guides',
                subtitle: 'Cleaning, handling, sleep',
                onTap: () {
                  context.push('/prosthetic-hub/care-guides');
                },
              ),
              const SizedBox(height: AppDimensions.space12),
              _HubLink(
                icon: Icons.inventory_2_outlined,
                title: 'Order supplies',
                subtitle: 'Solution, cases & cloths',
                onTap: () {
                  context.push('/prosthetic-hub/order-supplies');
                },
              ),
              const SizedBox(height: AppDimensions.space12),
              _HubLink(
                icon: Icons.message_outlined,
                title: 'Message my specialist',
                subtitle: 'Dr. Anwar · usually replies same day',
                onTap: () {
                  context.push('/prosthetic-hub/specialists');
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

/// Blue-gradient status card showing prosthesis health and cleaning schedule.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Healthy',
                          style: theme.textTheme.labelSmall?.copyWith(
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ── Title ──────────────────────────────────────────────────
              Text(
                'Next cleaning in 1 day',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              // ── Subtitle ───────────────────────────────────────────────
              Text(
                'Last cleaned 6 days ago. Tap to log today\'s care.',
                style: theme.textTheme.bodyMedium?.copyWith(
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
                              style: theme.textTheme.titleSmall?.copyWith(
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
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
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
