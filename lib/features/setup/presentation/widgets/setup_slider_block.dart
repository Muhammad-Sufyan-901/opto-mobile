import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/widgets/sliders/app_slider.dart';

/// A labelled slider row used in the Display and Voice setup screens.
///
/// Spec: `.set-block` / `.sld-wrap` / `.sld-track` / `.sld-fill` in
/// `Opto Onboarding.html`.
///   - Bold [label] above the slider row.
///   - Row: optional [leading] widget — [AppSlider] — optional [trailing] widget.
///   - Slider track: 8dp, `outline` inactive bg, `primary` active fill.
///
/// Accessibility: the containing row is labelled with [label] and the current
/// percentage so screen readers convey both the purpose and position.
class SetupSliderBlock extends StatelessWidget {
  const SetupSliderBlock({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.leading,
    this.trailing,
  });

  /// Section label shown above the slider (e.g. "Text size").
  final String label;

  /// Current slider value, in the range [[min], [max]].
  final double value;

  /// Called with the updated value when the user drags.
  final ValueChanged<double> onChanged;

  final double min;
  final double max;

  /// Widget rendered to the left of the track (e.g. small "A" text).
  final Widget? leading;

  /// Widget rendered to the right of the track (e.g. large "A" text or "Fast").
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();

    final double pct = ((value - min) / (max - min) * 100).clamp(0.0, 100.0);

    return Semantics(
      label: '$label, ${pct.round()}%',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section label ──────────────────────────────
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppDimensions.space16),

          // ── Slider row ─────────────────────────────────
          Row(
            children: [
              if (leading != null) ...[
                DefaultTextStyle(
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: ext?.ink2 ?? cs.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ) ??
                      const TextStyle(),
                  child: leading!,
                ),
                const SizedBox(width: AppDimensions.space12),
              ],

              Expanded(
                child: ExcludeSemantics(
                  child: AppSlider(
                    values: [value],
                    min: min,
                    max: max,
                    color: cs.primary,
                    onChanged: (vs) => onChanged(vs.first),
                  ),
                ),
              ),

              if (trailing != null) ...[
                const SizedBox(width: AppDimensions.space12),
                DefaultTextStyle(
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: ext?.ink2 ?? cs.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ) ??
                      const TextStyle(),
                  child: trailing!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
