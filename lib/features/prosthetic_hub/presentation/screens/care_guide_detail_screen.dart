// Screen: Care Guide detail
//
// Displays the full transcript, metadata, and optional audio playback button
// for a single [CareGuide]. Received via GoRouter [extra] parameter.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/widgets/buttons/app_button.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Returns the human-readable display label for a [CareGuideCategory].
String _categoryLabel(CareGuideCategory category) {
  switch (category) {
    case CareGuideCategory.insert:
      return 'Inserting';
    case CareGuideCategory.remove:
      return 'Removing';
    case CareGuideCategory.clean:
      return 'Cleaning';
    case CareGuideCategory.lubricate:
      return 'Lubricating';
    case CareGuideCategory.caseUse:
      return 'Case Use';
  }
}

/// Screen 17-C — Care Guide detail.
///
/// Receives [CareGuide] via `GoRouterState.of(context).extra`.
/// White Scaffold, SafeArea, no bottom nav.
class CareGuideDetailScreen extends StatefulWidget {
  const CareGuideDetailScreen({super.key});

  @override
  State<CareGuideDetailScreen> createState() => _CareGuideDetailScreenState();
}

class _CareGuideDetailScreenState extends State<CareGuideDetailScreen> {
  late final CareGuide _guide;

  @override
  void initState() {
    super.initState();
    _guide = GoRouterState.of(context).extra as CareGuide;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, '${_guide.title} guide.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 22,
            right: 22,
            top: 16,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProstheticHeader(title: _guide.title),
              const SizedBox(height: AppDimensions.space16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Duration + audio badge row ─────────────────────
                      ExcludeSemantics(
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: AppDimensions.iconSm,
                              color: ink3,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _guide.durationLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: ink3,
                              ),
                            ),
                            if (_guide.hasAudio) ...[
                              const SizedBox(width: 12),
                              _AudioBadge(
                                blueTint: blueTint,
                                blueStrong: blueStrong,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space12),

                      // ── Category chip ──────────────────────────────────
                      ExcludeSemantics(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: blueTint,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusChip,
                            ),
                          ),
                          child: Text(
                            _categoryLabel(_guide.category),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: blueStrong,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space24),

                      // ── Section label "GUIDE" ──────────────────────────
                      ExcludeSemantics(
                        child: Text(
                          'GUIDE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                            color: ink2,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space12),

                      // ── Transcript ─────────────────────────────────────
                      Semantics(
                        label: _guide.transcript,
                        child: ExcludeSemantics(
                          excluding: false,
                          child: Text(
                            _guide.transcript.trim(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),

                      // ── Audio button (only if hasAudio) ───────────────
                      if (_guide.hasAudio) ...[
                        const SizedBox(height: AppDimensions.space32),
                        AppButton.primary(
                          text: 'Play Audio Guide',
                          prefixIcon: Icons.play_circle_outline,
                          onPressed: () {
                            announce(
                              context,
                              'Playing audio guide for ${_guide.title}.',
                            );
                          },
                        ),
                      ],

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

/// Small "Audio" badge shown in the meta row.
class _AudioBadge extends StatelessWidget {
  const _AudioBadge({required this.blueTint, required this.blueStrong});

  final Color blueTint;
  final Color blueStrong;

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
            'Audio available',
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
