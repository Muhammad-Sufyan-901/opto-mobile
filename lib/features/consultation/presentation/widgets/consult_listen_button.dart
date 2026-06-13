import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// "Listen to …" pill button used on the Doctor Profile and Consult Summary
/// screens to trigger an audio read-aloud of the screen's key content.
///
/// Shows a waveform icon + label. Tapping announces the [announcement] string
/// via TalkBack/VoiceOver [SemanticsService.announce] and fires [HapticPatterns.focusTick].
///
/// Waveform bars animate when the device's reduce-motion setting is OFF.
class ConsultListenButton extends StatefulWidget {
  const ConsultListenButton({
    required this.label,
    required this.announcement,
    super.key,
  });

  /// Short label shown on the pill, e.g. "Listen to doctor's profile".
  final String label;

  /// Full text announced via [SemanticsService.announce] on tap.
  final String announcement;

  @override
  State<ConsultListenButton> createState() => _ConsultListenButtonState();
}

class _ConsultListenButtonState extends State<ConsultListenButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.of(context).disableAnimations;
    if (!reduce) {
      _ctrl.repeat(reverse: true);
    } else {
      _ctrl.value = 0.5;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color bgColor = ext?.blueTint ?? cs.primaryContainer;
    final Color fgColor = cs.primary;

    // Fixed bar heights: 6, 12, 8, 14, 10, 16, 8, 12, 6
    const List<double> baseHeights = [6, 12, 8, 14, 10, 16, 8, 12, 6];

    return Semantics(
      button: true,
      label: 'Listen aloud: ${widget.label}',
      child: GestureDetector(
        onTap: () {
          HapticPatterns.focusTick();
          SemanticsService.announce(widget.announcement, TextDirection.ltr);
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppDimensions.minTapTarget,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ExcludeSemantics(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Animated waveform ─────────────────────────────────
                      AnimatedBuilder(
                        animation: _anim,
                        builder: (context, _) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              baseHeights.length,
                              (i) {
                                final phase = (i * 0.35) % 1.0;
                                final t =
                                    (_anim.value + phase) % 1.0;
                                // Sinusoidal per-bar scale
                                final scale = 0.35 +
                                    0.65 *
                                        ((1 +
                                                _sineWave(t)) /
                                            2);
                                final h = baseHeights[i] * scale;
                                return Container(
                                  width: 2.5,
                                  height: h.clamp(4.0, 16.0),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: fgColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      // ── Label ──────────────────────────────────────────────
                      Text(
                        widget.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: fgColor,
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

  // Sine over [0..1] normalised to [0..1].
  double _sineWave(double t) => math.sin(t * 2 * math.pi);
}
