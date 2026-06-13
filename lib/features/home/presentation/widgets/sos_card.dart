import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Emergency SOS banner card on the Opto Home screen.
///
/// Two variants are supported:
/// - **Default** ([bold] = false) — the original flat danger-tinted card.
/// - **Bold hero** ([bold] = true) — prominent red-gradient card placed at the
///   top of the dashboard (directly after the greeting). Used by [HomeScreen].
///   Features a pulsing glow ring that respects `MediaQuery.disableAnimations`.
///
/// ⚠️ IMPORTANT — TODOs for the SOS module (⛔ Planned):
///   - Implement "hold 3 seconds" `GestureDetector.onLongPressStart` flow.
///   - Trigger the **reserved** long-pulsing danger haptic pattern from
///     `design_system.md §6`. This pattern MUST NOT be reused anywhere else.
///   - Wire "Call emergency" Aura Voice intent → `opto://sos` deep link.
///   - On activation: show `ScreenSOS` (artboard 21 in Opto Onboarding.html).
///
/// Design: `.sos`, `.sos-bold` in `Android Home Dashboard.html` (V1 Card Stack).
class SosCard extends StatefulWidget {
  const SosCard({super.key, this.onTap, this.bold = false});

  final VoidCallback? onTap;

  /// When true renders the bold red-gradient hero treatment.
  final bool bold;

  @override
  State<SosCard> createState() => _SosCardState();
}

class _SosCardState extends State<SosCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeOut),
    );

    // Start animation after first frame so we can check MediaQuery.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (widget.bold && !reduceMotion) {
        _pulse.repeat();
      }
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bold) return _buildBold(context);
    return _buildDefault(context);
  }

  // ── Bold hero variant ──────────────────────────────────────────────────────

  Widget _buildBold(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    // Gradient from cs.error towards a darker shade to avoid hardcoded hex.
    final Color errorDark = Color.lerp(cs.error, Colors.black, 0.16) ?? cs.error;

    return Semantics(
      button: true,
      label: 'Emergency SOS. Hold 3 seconds or say call emergency.',
      child: GestureDetector(
        onTap: widget.onTap,
        // TODO: replace onTap with onLongPressStart for the real hold-3s gesture.
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // 135° gradient: `oklch(0.57 0.21 27)` → `oklch(0.48 0.19 25)`.
              colors: [cs.error, errorDark],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: [
              BoxShadow(
                color: cs.error.withValues(alpha: 0.38),
                blurRadius: 30,
                spreadRadius: -10,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // ── Pulsing icon chip ────────────────────────────────────
              ExcludeSemantics(
                child: _PulsingChip(animation: _pulseAnim),
              ),

              const SizedBox(width: 16),

              // ── Text ─────────────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Emergency SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Hold 3 seconds or say "Call emergency"',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ── White CTA button (arrow) ──────────────────────────────
              ExcludeSemantics(
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: AppDimensions.iconLg,
                    color: cs.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Default (flat) variant ─────────────────────────────────────────────────

  Widget _buildDefault(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color dangerTint = ext?.dangerTint ?? cs.errorContainer;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Semantics(
      button: true,
      label: 'Emergency SOS. Hold 3 seconds or say call emergency.',
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.cardPadding,
          ),
          decoration: BoxDecoration(
            color: dangerTint,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: cs.error.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: cs.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Emergency SOS',
                        style: TextStyle(
                          color: cs.error,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Hold 3 seconds or say "Call emergency"',
                        style: TextStyle(
                          color: ink2,
                          fontSize: 14.5,
                          height: 1.35,
                        ),
                      ),
                    ],
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

// ── Pulsing icon chip widget ──────────────────────────────────────────────────

class _PulsingChip extends StatelessWidget {
  const _PulsingChip({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated pulsing ring
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Opacity(
                opacity: (1 - animation.value).clamp(0.0, 0.5),
                child: Transform.scale(
                  scale: 1 + animation.value * 0.35,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Icon chip
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
