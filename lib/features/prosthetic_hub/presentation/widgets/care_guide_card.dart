// Widget: CareGuideCard
//
// Single row card in the Care Guides list. Mirrors the visual style of
// [_HubLink] in `prosthetic_hub_screen.dart` — icon chip, title, meta row,
// optional audio chip, trailing chevron.
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';


/// An accessible, tappable card representing a single [CareGuide].
///
/// Semantics label: "{title}. {durationLabel}[. Audio available]".
/// All decorative icons/chips are wrapped in [ExcludeSemantics].
/// Minimum tap target is 48dp.
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

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final String semanticsLabel =
        '${guide.title}. ${guide.durationLabel}'
        '${guide.hasAudio ? '. Audio available' : ''}';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // Enforce a minimum tap target height.
          constraints: const BoxConstraints(
            minHeight: AppDimensions.minTapTarget,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: AppDimensions.space16,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Leading icon chip (48×48, radius 13) ────────────────────
              ExcludeSemantics(
                child: Container(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: 22,
                    color: blueStrong,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── Text + meta column ────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        guide.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Meta row: category label + duration
                      Row(
                        children: [
                          Text(
                            guide.category.displayLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ink2,
                            ),
                          ),
                          Text(
                            ' · ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ink3,
                            ),
                          ),
                          Text(
                            guide.durationLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ink3,
                            ),
                          ),
                        ],
                      ),
                      // Optional audio chip
                      if (guide.hasAudio) ...[
                        const SizedBox(height: 6),
                        _AudioChip(blueStrong: blueStrong, blueTint: blueTint),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ──────────────────────────────────────────
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

/// Small "Audio" label chip shown on guides that have an audio version.
class _AudioChip extends StatelessWidget {
  const _AudioChip({required this.blueStrong, required this.blueTint});

  final Color blueStrong;
  final Color blueTint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: blueTint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.headphones_outlined,
            size: AppDimensions.iconSm,
            color: blueStrong,
          ),
          const SizedBox(width: 4),
          Text(
            'Audio',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: blueStrong,
            ),
          ),
        ],
      ),
    );
  }
}
