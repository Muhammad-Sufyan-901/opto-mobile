import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/voice/voice.dart';

// =============================================================================
// AuraVoiceScreen — Screen 22
// =============================================================================

/// Screen 22 — Aura Voice.
///
/// Full-bleed blue voice assistant screen shown when the user activates the
/// Aura Voice feature. Displays animated waveform bars while listening and
/// suggestion chips for common commands.
///
/// Layout (top → bottom inside a blue Scaffold):
///   1. Top bar — close button, "Aura Voice" title, spacer
///   2. "Listening…" label (live region)
///   3. Animated waveform bars (decorative, ExcludeSemantics)
///   4. Heard transcript text (live region)
///   5. Spacer — pushes suggestion chips toward bottom
///   6. "TRY SAYING" label + 3 suggestion chips
///   7. Microphone button
///
/// Accessibility:
///   - Screen summary announced on mount via [announce].
///   - [liveRegion: true] on "Listening…" and transcript labels.
///   - Decorative waveform bars wrapped in [ExcludeSemantics].
///   - All interactive elements have [Semantics(button: true, label: ...)].
///   - "TRY SAYING" label wrapped in [ExcludeSemantics].
///
/// Animation:
///   - Single [AnimationController] with 800 ms duration, repeating with reverse.
///   - 13 bars each animated between 30% and 100% of their target height.
///   - Phase-offset applied per bar via `(value + i / count) % 1.0`.
class AuraVoiceScreen extends StatefulWidget {
  const AuraVoiceScreen({super.key});

  @override
  State<AuraVoiceScreen> createState() => _AuraVoiceScreenState();
}

class _AuraVoiceScreenState extends State<AuraVoiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final VoiceController _voiceCtrl;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _voiceCtrl = sl<VoiceController>();
    _voiceCtrl.addListener(_onVoiceStateChanged);

    // Announce screen to screen readers after the first frame renders,
    // then start listening automatically.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Aura Voice. Say a command or question.');
      _voiceCtrl.startListening();
    });
  }

  @override
  void dispose() {
    _voiceCtrl.removeListener(_onVoiceStateChanged);
    _voiceCtrl.stopListening();
    _animCtrl.dispose();
    super.dispose();
  }

  void _onVoiceStateChanged() {
    if (!mounted) return;
    setState(() {}); // trigger rebuild to show current state

    // Handle result state.
    final result = _voiceCtrl.lastResult;
    if (_voiceCtrl.state == VoiceControllerState.result && result != null) {
      switch (result) {
        case ResolvedIntent(:final intent):
          announce(
            context,
            'Going to ${intent.runtimeType.toString().replaceAll('Intent', '').toLowerCase()}',
          );
          // Navigate after a brief moment so the announce fires first.
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!mounted) return;
            context.go(intent.routePath);
            _voiceCtrl.reset();
          });
        case NeedsConfirmation(:final hint):
          announce(context, 'Did you mean: $hint? Tap mic to retry.');
          _voiceCtrl.reset();
        case UnknownPhrase(:final phrase):
          announce(context, "Sorry, I didn't understand: $phrase. Try again.");
          _voiceCtrl.reset();
      }
    }
  }

  // Handle a suggestion chip tap by parsing the chip text as a voice intent.
  void _onSuggestionChipTap(String rawText) {
    final parser = sl<IntentParser>();
    final result = parser.parse(rawText);
    _voiceCtrl.reset(); // clear any previous result first

    switch (result) {
      case ResolvedIntent(:final intent):
        announce(
          context,
          'Going to ${intent.runtimeType.toString().replaceAll('Intent', '').toLowerCase()}',
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          context.go(intent.routePath);
        });
      case NeedsConfirmation(:final hint):
        announce(context, 'Did you mean: $hint? Tap mic to retry.');
      case UnknownPhrase(:final phrase):
        announce(context, "Sorry, I didn't understand: $phrase. Try again.");
    }
  }

  /// Returns the reactive status label text based on controller state.
  String get _statusLabel {
    return switch (_voiceCtrl.state) {
      VoiceControllerState.listening => 'Listening…',
      VoiceControllerState.processing => 'Processing…',
      VoiceControllerState.initializing => 'Starting…',
      VoiceControllerState.idle => 'Ready',
      VoiceControllerState.result => 'Done',
      VoiceControllerState.error => 'Tap mic to start',
    };
  }

  /// Returns the semantic label for the status live region.
  String get _statusSemanticLabel {
    return switch (_voiceCtrl.state) {
      VoiceControllerState.listening => 'Aura is listening. Say a command.',
      VoiceControllerState.processing => 'Processing your command.',
      VoiceControllerState.initializing => 'Starting voice engine.',
      VoiceControllerState.idle => 'Aura Voice is ready.',
      VoiceControllerState.result => 'Command received.',
      VoiceControllerState.error => 'Voice input unavailable. Tap mic to retry.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final transcript = _voiceCtrl.lastPhrase;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.primary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 1. Top bar ─────────────────────────────────────────────
                const SizedBox(height: AppDimensions.space8),
                _TopBar(),

                // ── 2. Status label (reactive) ─────────────────────────────
                const SizedBox(height: 54),
                Semantics(
                  liveRegion: true,
                  label: _statusSemanticLabel,
                  child: Text(
                    _statusLabel,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ),

                // ── 3. Waveform bars ───────────────────────────────────────
                const SizedBox(height: 22),
                _WaveformBars(animCtrl: _animCtrl),
                const SizedBox(height: 22),

                // ── 4. Heard transcript (reactive, live region) ────────────
                Semantics(
                  liveRegion: true,
                  label: transcript != null
                      ? 'Heard: $transcript'
                      : 'Waiting for voice input.',
                  child: Text(
                    transcript != null ? '“$transcript”' : 'Say something…',
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── 5. Spacer — pushes chips toward bottom ─────────────────
                const Spacer(),

                // ── 6. Suggestion chips ────────────────────────────────────
                ExcludeSemantics(
                  child: Text(
                    'TRY SAYING',
                    style: tt.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SuggestionChip(
                  text: '"What\'s in front of me?"',
                  semanticLabel: 'Say: What\'s in front of me?',
                  onTap: () => _onSuggestionChipTap("What's in front of me?"),
                ),
                const SizedBox(height: 10),
                _SuggestionChip(
                  text: '"Navigate to the pharmacy"',
                  semanticLabel: 'Say: Navigate to the pharmacy',
                  onTap: () => _onSuggestionChipTap('Navigate to the pharmacy'),
                ),
                const SizedBox(height: 10),
                _SuggestionChip(
                  text: '"Call Dr. Anwar"',
                  semanticLabel: 'Say: Call Dr. Anwar',
                  onTap: () => _onSuggestionChipTap('Call Dr. Anwar'),
                ),

                // ── 7. Mic button (reactive) ───────────────────────────────
                const SizedBox(height: 22),
                _MicButton(
                  voiceState: _voiceCtrl.state,
                  onTap: () {
                    final s = _voiceCtrl.state;
                    if (s == VoiceControllerState.listening) {
                      _voiceCtrl.stopListening();
                    } else {
                      _voiceCtrl.startListening();
                    }
                  },
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Private sub-widgets
// =============================================================================

// ── Top Bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Close button
        Semantics(
          button: true,
          label: 'Close Aura Voice',
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home.path);
              }
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.16),
              ),
              child: const Icon(
                Icons.close,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Center: Title
        Text(
          'Aura Voice',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),

        // Right: Spacer to balance layout
        const SizedBox(width: 44),
      ],
    );
  }
}

// ── Waveform Bars ─────────────────────────────────────────────────────────────

class _WaveformBars extends StatelessWidget {
  const _WaveformBars({required this.animCtrl});

  final AnimationController animCtrl;

  static const List<double> _barHeights = [
    14, 28, 46, 30, 58, 40, 66, 38, 52, 26, 44, 20, 34,
  ];

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 72,
        child: AnimatedBuilder(
          animation: animCtrl,
          builder: (context, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(_barHeights.length, (i) {
                final t =
                    (animCtrl.value + i / _barHeights.length) % 1.0;
                final height =
                    _barHeights[i] * 0.3 + (_barHeights[i] * 0.7) * t;
                return Row(
                  children: [
                    Container(
                      width: 6,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    if (i < _barHeights.length - 1)
                      const SizedBox(width: 5),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

// ── Suggestion Chip ───────────────────────────────────────────────────────────

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
    required this.text,
    required this.semanticLabel,
    required this.onTap,
  });

  final String text;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusChip),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}

// ── Mic Button ────────────────────────────────────────────────────────────────

class _MicButton extends StatelessWidget {
  const _MicButton({
    required this.voiceState,
    required this.onTap,
  });

  final VoiceControllerState voiceState;
  final VoidCallback onTap;

  String get _semanticLabel {
    return switch (voiceState) {
      VoiceControllerState.listening => 'Microphone. Tap to stop listening',
      VoiceControllerState.processing => 'Processing voice command',
      VoiceControllerState.initializing => 'Starting microphone',
      VoiceControllerState.idle => 'Microphone. Tap to start listening',
      VoiceControllerState.result => 'Microphone. Tap to listen again',
      VoiceControllerState.error => 'Microphone unavailable. Tap to retry',
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // blueStrong = cs.secondary per task spec
    final blueStrong = cs.secondary;

    return Semantics(
      button: true,
      label: _semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.18),
          ),
          child: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                voiceState == VoiceControllerState.listening
                    ? Icons.mic
                    : Icons.mic_none,
                size: 30,
                color: blueStrong,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
