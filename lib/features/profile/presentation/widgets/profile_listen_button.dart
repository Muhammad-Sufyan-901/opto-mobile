import 'package:flutter/material.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/voice/aura_tts.dart';

/// The "Listen" TTS affordance pill (CSS: `.hb-listen`).
///
/// On tap, speaks [summary] via [AuraTts] and fires [HapticPatterns.focusTick].
/// Conforms to the design system's waveform animation styling.
///
/// Accessibility: wrapped in [Semantics] with a button role and descriptive
/// label so TalkBack users can activate it without seeing the icon.
class ProfileListenButton extends StatelessWidget {
  const ProfileListenButton({
    super.key,
    required this.summary,
    this.label = 'Listen to your profile summary',
  });

  /// The text string that will be spoken aloud.
  final String summary;

  /// The visible + accessible label on the pill.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color bg = ext?.blueTint ?? cs.primaryContainer;
    final Color fg = ext?.ink2 ?? cs.secondary;

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: () {
          HapticPatterns.focusTick();
          sl<AuraTts>().speak(summary);
        },
        child: ExcludeSemantics(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Waveform bars (decorative)
                _WaveBars(color: fg),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: fg,
                    fontSize: 13.5,
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

/// Three animated waveform bars matching the `.hb-listen .wave` design.
class _WaveBars extends StatelessWidget {
  const _WaveBars({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [8.0, 14.0, 10.0].map((h) {
        return Container(
          width: 2.5,
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 1.25),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }).toList(),
    );
  }
}
