// Tutorial Player Screen — Prosthetic Hub tutorial video player.
//
// Accessibility-first:
//   - Screen reader announcement on load.
//   - Transcript is ALWAYS visible below the player (WCAG equivalent text).
//   - Video player wrapped with Semantics label (ExcludeSemantics on player).
//   - Audio narration button if available.
//   - All tap targets ≥ 48dp.
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_tutorial_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/tutorials/tutorials_cubit.dart';

/// Screen — Tutorial video player for a single [CareTutorialEntity].
///
/// Receives [tutorialId] from the route path parameter and loads the tutorial
/// via [TutorialsCubit.loadTutorialById]. Provides its own [TutorialsCubit]
/// from DI (via [BlocProvider] in the route).
class TutorialPlayerScreen extends StatefulWidget {
  const TutorialPlayerScreen({
    super.key,
    required this.tutorialId,
  });

  final String tutorialId;

  @override
  State<TutorialPlayerScreen> createState() => _TutorialPlayerScreenState();
}

class _TutorialPlayerScreenState extends State<TutorialPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _videoInitialised = false;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    context.read<TutorialsCubit>().loadTutorialById(widget.tutorialId);
  }

  Future<void> _initVideo(String videoPath) async {
    if (_videoInitialised) return;
    try {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(videoPath));
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
      );
      if (mounted) {
        setState(() => _videoInitialised = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _videoError = 'Unable to load video.');
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocConsumer<TutorialsCubit, TutorialsState>(
          listenWhen: (prev, curr) =>
              curr is TutorialsLoaded && prev is! TutorialsLoaded,
          listener: (context, state) {
            if (state is TutorialsLoaded && state.tutorials.isNotEmpty) {
              final tutorial = state.tutorials.first;
              announce(context, tutorial.title);
              if (tutorial.videoPath != null) {
                _initVideo(tutorial.videoPath!);
              }
            }
          },
          builder: (context, state) {
            return switch (state) {
              TutorialsInitial() || TutorialsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              TutorialsLoaded(:final tutorials) when tutorials.isEmpty =>
                _buildNotFound(context, cs),
              TutorialsLoaded(:final tutorials) =>
                _buildContent(context, tutorials.first),
              TutorialsError(:final message) =>
                _buildError(context, cs, message),
            };
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONTENT BUILDERS
  // ---------------------------------------------------------------------------

  Widget _buildContent(BuildContext context, CareTutorialEntity tutorial) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    return CustomScrollView(
      slivers: [
        // ── Header ──────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _PlayerHeader(cs: cs),
        ),

        // ── Title ────────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
              vertical: AppDimensions.space8,
            ),
            child: Text(
              tutorial.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),

        // ── Category chip ────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
            ),
            child: _CategoryChip(category: tutorial.category, cs: cs),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.space16),
        ),

        // ── Video player (or placeholder) ────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingMin,
            ),
            child: _VideoSection(
              tutorial: tutorial,
              chewieController: _chewieController,
              videoInitialised: _videoInitialised,
              videoError: _videoError,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.space24),
        ),

        // ── Transcript card (always visible — WCAG requirement) ───────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingMin,
            ),
            child: _TranscriptCard(
              transcript: tutorial.transcript,
              cs: cs,
              line: line,
            ),
          ),
        ),

        // ── Audio narration button (conditional) ─────────────────────────────
        if (tutorial.audioNarrationPath != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingMin,
                vertical: AppDimensions.space16,
              ),
              child: _AudioNarrationButton(
                audioPath: tutorial.audioNarrationPath!,
                cs: cs,
              ),
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.space32),
        ),
      ],
    );
  }

  Widget _buildNotFound(BuildContext context, ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.video_library_outlined, size: 64, color: cs.onSurfaceVariant),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'Tutorial not found.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space24),
            Semantics(
              button: true,
              label: 'Go back to tutorials list',
              child: SizedBox(
                height: AppDimensions.minTapTarget,
                child: ElevatedButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.careTutorials.name);
                    }
                  },
                  child: const ExcludeSemantics(child: Text('Back to Tutorials')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
      BuildContext context, ColorScheme cs, String message) {
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: cs.error),
              const SizedBox(height: AppDimensions.space16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: cs.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space24),
              Semantics(
                button: true,
                label: 'Retry loading tutorial',
                child: SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<TutorialsCubit>()
                        .loadTutorialById(widget.tutorialId),
                    child: const ExcludeSemantics(child: Text('Retry')),
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

/// Screen header: back button + centred title.
class _PlayerHeader extends StatelessWidget {
  const _PlayerHeader({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 22,
        top: 14,
        bottom: 4,
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(AppRoutes.careTutorials.name);
                }
              },
              child: const SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.chevron_left, size: 28),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                'Tutorial',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: AppDimensions.minTapTarget,
            height: AppDimensions.minTapTarget,
          ),
        ],
      ),
    );
  }
}

/// Category chip shown below the tutorial title.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category, required this.cs});

  final TutorialCategory category;
  final ColorScheme cs;

  static const _labels = <TutorialCategory, String>{
    TutorialCategory.insert: 'Insert',
    TutorialCategory.remove: 'Remove',
    TutorialCategory.clean: 'Clean',
    TutorialCategory.lubricate: 'Lubricate',
    TutorialCategory.caseUse: 'Case Use',
  };

  @override
  Widget build(BuildContext context) {
    final label = _labels[category] ?? category.dbValue;
    return Semantics(
      label: 'Category: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space4,
        ),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
        ),
        child: ExcludeSemantics(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

/// Video player section: Chewie player if available, placeholder card if null.
class _VideoSection extends StatelessWidget {
  const _VideoSection({
    required this.tutorial,
    required this.chewieController,
    required this.videoInitialised,
    required this.videoError,
  });

  final CareTutorialEntity tutorial;
  final ChewieController? chewieController;
  final bool videoInitialised;
  final String? videoError;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    if (tutorial.videoPath == null) {
      return _VideoPlaceholder(
        label: 'No video available',
        cs: cs,
      );
    }

    if (videoError != null) {
      return _VideoPlaceholder(label: videoError!, cs: cs);
    }

    if (!videoInitialised || chewieController == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accessible label above the player so TalkBack users know what it is.
        Semantics(
          label: 'Video player for ${tutorial.title}',
          child: const SizedBox.shrink(),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            // ExcludeSemantics wraps the player itself — the label above handles
            // screen reader focus.
            child: ExcludeSemantics(
              child: Chewie(controller: chewieController!),
            ),
          ),
        ),
      ],
    );
  }
}

/// Placeholder shown when no video path is set or video fails to load.
class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder({required this.label, required this.cs});

  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.videocam_off_outlined,
                  size: 48,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
              ExcludeSemantics(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Always-visible transcript card (WCAG equivalent text alternative).
class _TranscriptCard extends StatelessWidget {
  const _TranscriptCard({
    required this.transcript,
    required this.cs,
    required this.line,
  });

  final String transcript;
  final ColorScheme cs;
  final Color line;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      label: 'Transcript',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Text(
                'Transcript',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              transcript,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Audio narration play button — shown only when [audioPath] is non-null.
///
/// NOTE: Full audio playback integration (just_audio / audioplayers) is outside
/// the scope of this task. This button is a placeholder that will be wired up
/// in a future task. The button is included per the task spec and is accessible.
class _AudioNarrationButton extends StatelessWidget {
  const _AudioNarrationButton({
    required this.audioPath,
    required this.cs,
  });

  final String audioPath;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Play audio narration',
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeight,
        child: OutlinedButton.icon(
          onPressed: () {
            // TODO(audio): wire up audio playback (just_audio / audioplayers).
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Audio narration coming soon.'),
              ),
            );
          },
          icon: ExcludeSemantics(
            child: Icon(Icons.headphones_outlined, color: cs.primary),
          ),
          label: ExcludeSemantics(
            child: Text(
              'Play Audio Narration',
              style: TextStyle(color: cs.primary),
            ),
          ),
        ),
      ),
    );
  }
}
