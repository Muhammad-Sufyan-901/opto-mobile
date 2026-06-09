import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Emergency SOS banner card on the Opto Home screen.
///
/// Renders a danger-tinted card with the SOS label and instructions.
/// Semantics are correct (role=button, accessible label per design spec).
///
/// ⚠️ IMPORTANT — TODOs for the SOS module (⛔ Planned):
///   - Implement "hold 3 seconds" `GestureDetector.onLongPressStart` flow.
///   - Trigger the **reserved** long-pulsing danger haptic pattern from
///     `design_system.md §6`. This pattern MUST NOT be reused anywhere else.
///   - Wire "Call emergency" Aura Voice intent → `opto://sos` deep link.
///   - On activation: show `ScreenSOS` (artboard 21 in Opto Onboarding.html).
///
/// Design: `.sos`, `.sos-ic`, `.sos-txt`, `.sos-label`, `.sos-sub` in
/// `Opto Onboarding.html` (Dashboard section).
class SosCard extends StatelessWidget {
  const SosCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color dangerTint = ext?.dangerTint ?? cs.errorContainer;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Semantics(
      button: true,
      label: 'Emergency SOS. Hold 3 seconds or say call emergency.',
      child: GestureDetector(
        onTap: onTap,
        // TODO: replace onTap with onLongPressStart for the real hold-3s gesture.
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
              // ── Danger icon chip (56dp, radius 16) ────────────────────
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

              // ── Label + instructions ───────────────────────────────────
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
