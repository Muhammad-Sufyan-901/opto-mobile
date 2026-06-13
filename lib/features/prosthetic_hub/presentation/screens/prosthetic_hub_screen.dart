import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen 17 — Prosthetic Hub (M3 redesign)
///
/// Simplified hero status card (no ring/streak) + 2-tile quick-actions grid
/// linking to Care Guides and Order Supplies only. Specialist / appointment
/// links removed per scope decision.
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
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: cs.surface,
      bottomNavigationBar: const HomeBottomNav(activeTab: -1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 18,
            right: 18,
            top: 0,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Large M3 app bar ──────────────────────────────────────────
              _LargeAppBar(
                onListenTap: () => announce(
                  context,
                  'Right eye prosthesis. Next cleaning in 1 day. '
                  'Last cleaned 6 days ago. Status: Healthy.',
                ),
              ),

              const SizedBox(height: 16),

              // ── Hero status card ──────────────────────────────────────────
              _StatusCard(cs: cs),

              const SizedBox(height: 14),

              // ── Listen pill ───────────────────────────────────────────────
              Semantics(
                button: true,
                label: 'Listen to today\'s summary.',
                child: GestureDetector(
                  onTap: () => announce(
                    context,
                    'Right eye prosthesis. Next cleaning in 1 day. '
                    'Last cleaned 6 days ago. Status: Healthy.',
                  ),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.volume_up_outlined,
                          size: 17,
                          color: cs.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        ExcludeSemantics(
                          child: Text(
                            'Listen to today\'s summary',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: cs.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ExcludeSemantics(
                          child: _MiniWave(color: cs.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── "Quick actions" label ─────────────────────────────────────
              ExcludeSemantics(
                child: Text(
                  'QUICK ACTIONS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: ink3,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.space12),

              // ── 2-tile grid ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _QuickTile(
                      icon: Icons.menu_book_outlined,
                      label: 'Care Guides',
                      sub: 'Cleaning & handling',
                      onTap: () =>
                          context.push(AppRoutes.prostheticCareGuides.path),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: _QuickTile(
                      icon: Icons.inventory_2_outlined,
                      label: 'Order Supplies',
                      sub: 'Restock anytime',
                      onTap: () =>
                          context.push(AppRoutes.prostheticOrderSupplies.path),
                    ),
                  ),
                ],
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

/// Large M3 app bar: icon row (back + actions) + large heading below.
class _LargeAppBar extends StatelessWidget {
  const _LargeAppBar({required this.onListenTap});

  final VoidCallback onListenTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon row
          Row(
            children: [
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
              const Spacer(),
              Semantics(
                button: true,
                label: 'Listen to hub summary',
                child: GestureDetector(
                  onTap: onListenTap,
                  child: SizedBox(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    child: Center(
                      child: ExcludeSemantics(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cs.primaryContainer,
                          ),
                          child: Icon(
                            Icons.volume_up_outlined,
                            size: 22,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Large heading
          Semantics(
            header: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Prosthetic Hub',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Blue-gradient hero status card (simplified — no ring/streak per design decision).
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          'Prosthetic status: Healthy. Next cleaning in 1 day. '
          'Last cleaned 6 days ago. Double tap to log care.',
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.78],
            colors: [cs.primary, cs.secondary],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.64),
              blurRadius: 46,
              offset: const Offset(0, 22),
              spreadRadius: -18,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eyebrow + chip row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RIGHT EYE PROSTHESIS',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                  _HealthyChip(),
                ],
              ),

              const SizedBox(height: 9),

              // Title
              const Text(
                'Next cleaning in 1 day',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  height: 1.15,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 5),

              // Subtitle
              Text(
                'Last cleaned 6 days ago',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),

              const SizedBox(height: 18),

              // Log care button
              Semantics(
                button: true,
                label: 'Log today\'s care',
                child: GestureDetector(
                  onTap: () {
                    // TODO(prosthetic-hub): open care logging flow
                  },
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(27),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log today\'s care',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: cs.secondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: cs.secondary,
                        ),
                      ],
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

/// Translucent "Healthy" chip shown inside the hero card.
class _HealthyChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 14, color: Colors.white),
          SizedBox(width: 6),
          Text(
            'Healthy',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Decorative mini waveform shown inside the "Listen" pill.
class _MiniWave extends StatelessWidget {
  const _MiniWave({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const heights = [8.0, 14.0, 6.0, 16.0, 10.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final h in heights) ...[
          Container(
            width: 2.5,
            height: h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 2.5),
        ],
      ],
    );
  }
}

/// A quick-action tile (2-column grid cell).
class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.label,
    required this.sub,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color line = ext?.line ?? cs.outline;

    return Semantics(
      button: true,
      label: '$label. $sub',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 124),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 24, color: cs.onPrimaryContainer),
                ),
              ),
              const SizedBox(height: 16),
              ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      sub,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
