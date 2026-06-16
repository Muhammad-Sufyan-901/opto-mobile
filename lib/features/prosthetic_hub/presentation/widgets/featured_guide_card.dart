// Widget: FeaturedGuideCard
//
// The "Recommended today" featured card shown at the top of the Care Guides
// list. Displays a full-width illustration banner, eyebrow label, large title,
// meta row (steps + duration), and a filled "Open guide" button.
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/guide_illustration.dart';

class FeaturedGuideCard extends StatelessWidget {
  const FeaturedGuideCard({
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

    return Semantics(
      button: true,
      label: 'Recommended today: ${guide.title}. $metaText. Double tap to open guide.',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard + 6),
            border: Border.all(color: line, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Illustration banner ──────────────────────────────────────
              GuideIllustration(
                category: guide.category,
                icon: Icons.remove_red_eye_outlined,
                label: 'Cleaning illustration',
                height: 158,
              ),

              // ── Body ─────────────────────────────────────────────────────
              ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Eyebrow
                      Text(
                        'Recommended today',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Title
                      Text(
                        guide.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Meta row
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye_outlined, size: 17, color: cs.primary),
                          const SizedBox(width: 6),
                          Text(
                            metaText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ink3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Button
                      SizedBox(
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.arrow_forward, size: 20),
                          label: const Text('Open guide'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
