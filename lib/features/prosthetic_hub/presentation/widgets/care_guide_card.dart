// Widget: CareGuideCard
//
// Restyled for the M3 redesign — mini illustration thumbnail, large title,
// meta row with step count + duration, and a trailing chevron.
// Mirrors the `.hb-grow` layout from the design.
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/guide_illustration.dart';

/// An accessible, tappable row card representing a single [CareGuide].
///
/// Semantics label: "{title}. {stepCount} steps · {durationLabel}[. Audio available]".
class CareGuideCard extends StatelessWidget {
  const CareGuideCard({
    super.key,
    required this.guide,
    required this.onTap,
  });

  final CareGuide guide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final int stepCount = guide.steps.length;
    final String metaText = stepCount > 0
        ? '$stepCount step${stepCount == 1 ? '' : 's'} · ${guide.durationLabel}'
        : guide.durationLabel;

    final String semanticsLabel =
        '${guide.title}. $metaText'
        '${guide.hasAudio ? '. Audio available' : ''}';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 2),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Mini illustration thumbnail ──────────────────────────────
              ExcludeSemantics(
                child: GuideIllustration(
                  category: guide.category,
                  mini: true,
                  icon: Icons.remove_red_eye_outlined,
                ),
              ),

              const SizedBox(width: 15),

              // ── Text column ──────────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        guide.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (guide.hasAudio) ...[
                            Icon(
                              Icons.volume_up_outlined,
                              size: 15,
                              color: cs.primary,
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            metaText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ─────────────────────────────────────────
              ExcludeSemantics(
                child: Icon(Icons.chevron_right, size: 22, color: ink3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
