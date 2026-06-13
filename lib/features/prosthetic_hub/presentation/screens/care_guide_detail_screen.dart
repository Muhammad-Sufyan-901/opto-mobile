// Screen: Care Guide detail (M3 redesign)
//
// Hero illustration → meta chips → audio player card (when hasAudio) →
// numbered step cards with per-step illustrations and optional tip boxes →
// "Mark as done" button.
// Falls back to the transcript text when steps is empty.
// All routing guards and accessibility announcements are unchanged.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/guide_illustration.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Screen 17-C — Care Guide detail.
///
/// Receives [CareGuide] via `GoRouterState.of(context).extra`.
class CareGuideDetailScreen extends StatelessWidget {
  const CareGuideDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guide = GoRouterState.of(context).extra;
    if (guide is! CareGuide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    return _CareGuideDetailView(guide: guide);
  }
}

class _CareGuideDetailView extends StatefulWidget {
  const _CareGuideDetailView({required this.guide});

  final CareGuide guide;

  @override
  State<_CareGuideDetailView> createState() => _CareGuideDetailViewState();
}

class _CareGuideDetailViewState extends State<_CareGuideDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, '${widget.guide.title} guide.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final CareGuide guide = widget.guide;
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.screenPadding,
            right: AppDimensions.screenPadding,
            top: 16,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProstheticHeader(title: guide.title),
              const SizedBox(height: AppDimensions.space16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Hero illustration ──────────────────────────────
                      GuideIllustration(
                        icon: Icons.remove_red_eye_outlined,
                        label: 'Overview illustration',
                        height: 182,
                      ),

                      const SizedBox(height: AppDimensions.space12),

                      // ── Meta row ───────────────────────────────────────
                      ExcludeSemantics(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _MetaChip(
                              icon: Icons.calendar_today_outlined,
                              label: guide.category.displayLabel,
                            ),
                            if (guide.steps.isNotEmpty)
                              _MetaChip(
                                icon: Icons.remove_red_eye_outlined,
                                label: '${guide.steps.length} step${guide.steps.length == 1 ? '' : 's'}',
                              ),
                            _MetaChip(
                              icon: Icons.schedule_outlined,
                              label: guide.durationLabel,
                            ),
                          ],
                        ),
                      ),

                      // ── Audio player ───────────────────────────────────
                      if (guide.hasAudio) ...[
                        const SizedBox(height: AppDimensions.space16),
                        _AudioPlayerCard(
                          durationLabel: guide.durationLabel,
                          onPlay: () => announce(
                            context,
                            'Playing audio guide for ${guide.title}.',
                          ),
                        ),
                      ],

                      const SizedBox(height: AppDimensions.sectionGap),

                      // ── Steps or transcript fallback ───────────────────
                      if (guide.steps.isNotEmpty) ...[
                        ExcludeSemantics(
                          child: Text(
                            'STEPS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: ink3,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space12),
                        for (int i = 0; i < guide.steps.length; i++) ...[
                          if (i > 0) const SizedBox(height: AppDimensions.space12 + 2),
                          _StepCard(step: guide.steps[i], number: i + 1),
                        ],
                      ] else ...[
                        ExcludeSemantics(
                          child: Text(
                            'GUIDE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: ink3,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space12),
                        Text(
                          guide.transcript.trim(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ],

                      const SizedBox(height: AppDimensions.space32),

                      // ── Mark as done button ────────────────────────────
                      Semantics(
                        button: true,
                        label: 'Mark guide as done',
                        child: SizedBox(
                          height: AppDimensions.buttonHeight,
                          child: FilledButton.icon(
                            onPressed: () {
                              announce(
                                context,
                                '${guide.title} marked as done.',
                              );
                              if (context.canPop()) context.pop();
                            },
                            icon: const Icon(Icons.check, size: 20),
                            label: const Text('Mark as done'),
                            style: FilledButton.styleFrom(
                              minimumSize:
                                  const Size(double.infinity, AppDimensions.buttonHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space24),
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

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// A single meta datum shown in the header meta row.
class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: cs.primary),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Tonal audio-player card shown for guides that have an audio narration.
class _AudioPlayerCard extends StatelessWidget {
  const _AudioPlayerCard({
    required this.durationLabel,
    required this.onPlay,
  });

  final String durationLabel;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    const waveHeights = [10.0, 18.0, 13.0, 24.0, 16.0, 9.0, 20.0, 14.0, 26.0, 12.0, 17.0, 8.0, 22.0, 15.0, 11.0];

    return Semantics(
      button: true,
      label: 'Play audio guide. Narrated, $durationLabel.',
      child: GestureDetector(
        onTap: onPlay,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              // Play button
              ExcludeSemantics(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.60),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Labels
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Listen to this guide',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onPrimaryContainer,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Narrated · $durationLabel',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onPrimaryContainer.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Decorative waveform
              ExcludeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final h in waveHeights)
                      Container(
                        width: 3,
                        height: h,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single numbered step card (`.hb-gstep` equivalent).
class _StepCard extends StatelessWidget {
  const _StepCard({required this.step, required this.number});

  final CareGuideStep step;
  final int number;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Semantics(
      label: 'Step $number: ${step.title}. ${step.body}'
          '${step.tip != null ? " Important: ${step.tip}" : ""}',
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge - 4),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: line, width: 1.5),
        ),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Step number + title ──────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      step.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              // ── Per-step illustration ────────────────────────────────────
              GuideIllustration(
                icon: Icons.remove_red_eye_outlined,
                label: 'Step $number illustration',
                height: 146,
              ),

              const SizedBox(height: 13),

              // ── Body text ────────────────────────────────────────────────
              Text(
                step.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: ink2,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // ── Optional tip box ─────────────────────────────────────────
              if (step.tip != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 18,
                        color: cs.onPrimaryContainer,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          step.tip!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: cs.onPrimaryContainer,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
