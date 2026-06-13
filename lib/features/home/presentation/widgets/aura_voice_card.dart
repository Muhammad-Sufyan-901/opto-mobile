import 'package:flutter/material.dart';

import 'package:opto/core/themes/app_custom_colors.dart';

/// Aura Voice quick-launch pill on the Opto Home screen.
///
/// A tappable banner that opens the Aura Voice listening screen.
/// Visually: blue-tint background, a blue mic chip (+ glow ring),
/// heading text in secondary (blue-strong) colour, subtitle, and a
/// decorative 5-bar waveform.
///
/// Accessibility: rendered as a `Semantics` button with the label
/// "Aura Voice. Tap to speak." per `design_system.md §12.1`.
///
/// Design: `.aura`, `.aura-ic`, `.aura-txt`, `.aura-wave`
/// in `Android Home Dashboard.html` (V1 Card Stack).
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            // No border — borderless blueTint background per V1 spec.
            color: blueTint,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // ── Mic icon chip (46dp circle + glow spread) ─────────────
              ExcludeSemantics(
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.16),
                        blurRadius: 0,
                        spreadRadius: 5,
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
                        'Ask Opto anything',
                        style: theme.textTheme.titleLarge?.copyWith(
                          // Secondary = blue-strong / onpc per token mapping.
                          color: cs.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Read text, identify objects, navigate',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                          fontSize: 13.5,
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
