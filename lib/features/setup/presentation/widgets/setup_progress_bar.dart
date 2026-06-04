import 'package:flutter/material.dart';

/// Linear progress indicator for the Onboarding & Setup flow.
///
/// Spec: `.opt-progress` / `.opt-progress-fill` in `Opto Onboarding.html`
///   - Track: 8dp tall, `colorScheme.outline` background, radius 5.
///   - Fill: `colorScheme.primary`, full-radius fill, width = [step] / [totalSteps].
///
/// Accessibility: announced as "Step [step] of [totalSteps]" so the current
/// progress is never conveyed by visual bar width alone.
class SetupProgressBar extends StatelessWidget {
  const SetupProgressBar({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  /// The 1-based current step number.
  final int step;

  /// The total number of setup steps.
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final double fraction = (step / totalSteps).clamp(0.0, 1.0);

    return Semantics(
      label: 'Step $step of $totalSteps',
      value: '${(fraction * 100).round()}%',
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: cs.outline.withValues(alpha: 0.28),
              color: cs.primary,
              minHeight: 8,
            ),
          ),
        ),
      ),
    );
  }
}
