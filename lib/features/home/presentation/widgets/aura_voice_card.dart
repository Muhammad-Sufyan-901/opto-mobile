import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

/// Aura Voice quick-launch pill on the Opto Home screen.
///
/// A tappable banner that opens the Aura Voice listening screen.
/// Visually: blue-tint background with a blue mic chip (+ glow ring),
/// heading text, subtitle, and a decorative 5-bar waveform.
///
/// Accessibility: rendered as a `Semantics` button with the label
/// "Aura Voice. Tap to speak." per `design_system.md §12.1`.
///
/// Design: `.aura`, `.aura-ic`, `.aura-txt`, `.aura-wave` in
/// `Opto Onboarding.html` (Dashboard section).
class AuraVoiceCard extends StatelessWidget {
  const AuraVoiceCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Semantics(
      button: true,
      label: 'Aura Voice. Tap to speak.',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 66),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.28),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // ── Mic icon chip (blue circle + glow spread) ─────────────
              ExcludeSemantics(
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.14),
                        blurRadius: 0,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 22),
                ),
              ),

              const SizedBox(width: 14),

              // ── Label + hint ──────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Aura Voice',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Tap and ask Opto anything',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── Decorative waveform ────────────────────────────────────
              ExcludeSemantics(
                child: _Waveform(color: cs.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Five-bar audio waveform illustration used in [AuraVoiceCard].
///
/// Bar heights from the design: 9 / 18 / 13 / 22 / 11 dp.
class _Waveform extends StatelessWidget {
  const _Waveform({required this.color});

  final Color color;

  static const List<double> _heights = [9, 18, 13, 22, 11];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: _heights.map((h) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Container(
            width: 3,
            height: h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }).toList(),
    );
  }
}
