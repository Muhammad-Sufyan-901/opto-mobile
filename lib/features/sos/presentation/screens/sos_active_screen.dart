import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:go_router/go_router.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';

// =============================================================================
// SosActiveScreen — Screen 21
// =============================================================================

/// Screen 21 — Emergency SOS Active.
///
/// Full-bleed red emergency screen shown once the user triggers SOS. Uses the
/// reserved **pulsing danger pattern** (concentric rings expanding outward) as
/// mandated by `design_system.md §6` — this pattern must never be reused on
/// non-emergency surfaces.
///
/// Layout (top → bottom inside a red Scaffold):
///   1. Status row — shield icon + "EMERGENCY ACTIVE" label (live region)
///   2. Pulsing rings + SOS core (two animated concentric circles)
///   3. Status text — "Calling emergency services…" (live region)
///   4. Sub-text — location & responder info
///   5. Location chip — inline accuracy indicator
///   6. Contacts-notified panel — contact avatars + notification status
///   7. Spacer — pushes cancel to bottom
///   8. Hold-to-cancel button
///
/// Accessibility:
///   - Screen summary announced on mount via [SemanticsService.sendAnnouncement].
///   - [liveRegion: true] on status row and status text.
///   - Decorative rings and SOS icon are [ExcludeSemantics].
///   - Location chip and contact rows carry descriptive [Semantics] labels.
///   - Cancel button labelled for screen readers.
///   - Tap target for cancel ≥ 58dp (well above 48dp minimum).
///
/// Animation:
///   - Two independent [AnimationController]s (_ring1Ctrl / _ring2Ctrl).
///   - Ring 2 is staggered by 500 ms via [Future.delayed].
///   - Both repeat indefinitely; both disposed in [dispose].
class SosActiveScreen extends StatefulWidget {
  const SosActiveScreen({super.key});

  @override
  State<SosActiveScreen> createState() => _SosActiveScreenState();
}

class _SosActiveScreenState extends State<SosActiveScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ring1Ctrl;
  late final AnimationController _ring2Ctrl;

  @override
  void initState() {
    super.initState();

    _ring1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _ring2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Stagger ring 2 by 500 ms so rings pulse in sequence.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _ring2Ctrl.repeat();
    });

    // Announce emergency activation to screen readers after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Emergency SOS activated. Calling emergency services now.',
        TextDirection.ltr,
      );
    });
  }

  @override
  void dispose() {
    _ring1Ctrl.dispose();
    _ring2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cs = theme.colorScheme;
    final errorColor = cs.error;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: errorColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space24 + 2, // 26dp
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 1. Top status row ──────────────────────────────────────
                const SizedBox(height: AppDimensions.space8),
                _StatusRow(),

                // ── 2. Pulsing rings + SOS core ───────────────────────────
                const SizedBox(height: 26),
                _PulsingRings(
                  ring1Ctrl: _ring1Ctrl,
                  ring2Ctrl: _ring2Ctrl,
                  errorColor: errorColor,
                ),

                // ── 3. Status text ─────────────────────────────────────────
                const SizedBox(height: 14),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    'Calling emergency services…',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── 4. Sub-text ────────────────────────────────────────────
                const SizedBox(height: AppDimensions.space8),
                Text(
                  'Sharing your live location and vision profile with responders.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),

                // ── 5. Location chip ───────────────────────────────────────
                const SizedBox(height: AppDimensions.space16),
                const _LocationChip(),

                // ── 6. Contacts-notified panel ─────────────────────────────
                const SizedBox(height: 22),
                const _ContactsPanel(),

                // ── 7. Spacer ──────────────────────────────────────────────
                const Spacer(),

                // ── 8. Hold-to-cancel button ───────────────────────────────
                _CancelButton(errorColor: errorColor),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Private sub-widgets
// =============================================================================

// ── Status Row ────────────────────────────────────────────────────────────────

class _StatusRow extends StatelessWidget {
  const _StatusRow();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      label: 'Emergency services have been alerted. Emergency active.',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shield_outlined, size: 22, color: Colors.white),
          const SizedBox(width: AppDimensions.space8),
          Text(
            'EMERGENCY ACTIVE',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.6,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pulsing Rings ─────────────────────────────────────────────────────────────

class _PulsingRings extends StatelessWidget {
  const _PulsingRings({
    required this.ring1Ctrl,
    required this.ring2Ctrl,
    required this.errorColor,
  });

  final AnimationController ring1Ctrl;
  final AnimationController ring2Ctrl;
  final Color errorColor;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ring 1 — 150×150, starts immediately
            AnimatedBuilder(
              animation: ring1Ctrl,
              builder: (context, _) {
                final t = ring1Ctrl.value;
                return Transform.scale(
                  scale: lerpDouble(0.85, 1.25, t)!,
                  child: Opacity(
                    opacity: lerpDouble(0.7, 0.0, t)!,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.50),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Ring 2 — 118×118, staggered 500 ms
            AnimatedBuilder(
              animation: ring2Ctrl,
              builder: (context, _) {
                final t = ring2Ctrl.value;
                return Transform.scale(
                  scale: lerpDouble(0.85, 1.25, t)!,
                  child: Opacity(
                    opacity: lerpDouble(0.7, 0.0, t)!,
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.50),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // SOS core — 96×96 white circle with error-colored icon
            ExcludeSemantics(
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.security_outlined,
                  size: 48,
                  color: errorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Location Chip ─────────────────────────────────────────────────────────────

class _LocationChip extends StatelessWidget {
  const _LocationChip();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      label: 'Location: Jl. Merdeka No. 24, Bandung, accuracy 5 meters',
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.place_outlined,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: AppDimensions.space8),
            Flexible(
              child: Text(
                'Jl. Merdeka No. 24, Bandung — accuracy 5 m',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Contacts Panel ────────────────────────────────────────────────────────────

class _ContactsPanel extends StatelessWidget {
  const _ContactsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Builder(builder: (context) {
              final theme = Theme.of(context);
              return Text(
                'NOTIFYING YOUR CONTACTS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.6,
                  color: Colors.white.withValues(alpha: 0.80),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          const _ContactRow(
            initials: 'SI',
            name: 'Siti (Sister)',
            status: 'Notified · 3s ago',
            showCheck: true,
          ),
          const SizedBox(height: 12),
          const _ContactRow(
            initials: 'DR',
            name: 'Dr. Anwar',
            status: 'Notifying…',
            showCheck: false,
          ),
        ],
      ),
    );
  }
}

// ── Contact Row ───────────────────────────────────────────────────────────────

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.initials,
    required this.name,
    required this.status,
    required this.showCheck,
  });

  final String initials;
  final String name;
  final String status;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final semanticLabel = '$name — $status';

    return Semantics(
      label: semanticLabel,
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
          // Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          // Optional checkmark
          if (showCheck)
            const Icon(
              Icons.check_circle_outline,
              size: 18,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}

// ── Cancel Button ─────────────────────────────────────────────────────────────

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.errorColor});

  final Color errorColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      button: true,
      label: 'Hold to cancel emergency call',
      child: GestureDetector(
        onLongPress: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home.path);
          }
        },
        child: Container(
          height: 58,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          alignment: Alignment.center,
          child: Text(
            'Hold to cancel',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: errorColor,
            ),
          ),
        ),
      ),
    );
  }
}
