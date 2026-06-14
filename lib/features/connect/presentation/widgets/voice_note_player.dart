// Voice-note player widget for community posts and replies.
//
// Matches the `co-vnote` design: a round play/pause button on the left,
// a waveform visualisation with a "played" fraction, and a time label.
//
// Audio playback via `audioplayers` when a real URL is provided.
// When [voiceUrl] is null or playback is not yet implemented, the button
// renders as a visible stub (no-op) with a TODO marker.
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Accessible voice-note player rendered inline in a post or reply card.
///
/// [voiceUrl] — remote URL of the audio recording; when null the widget
///   renders but playback is a no-op (stub).
/// [durationLabel] — human-readable duration string (e.g. "0:48"); shown
///   below the waveform.
class VoiceNotePlayer extends StatefulWidget {
  const VoiceNotePlayer({
    super.key,
    required this.durationLabel,
    this.voiceUrl,
  });

  final String durationLabel;
  final String? voiceUrl;

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _played = 0.0; // 0.0–1.0 fraction of waveform shown as "played"

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });
    _player.onPositionChanged.listen((pos) {
      if (!mounted) return;
      _player.getDuration().then((dur) {
        if (dur != null && dur.inMilliseconds > 0 && mounted) {
          setState(() {
            _played = pos.inMilliseconds / dur.inMilliseconds;
          });
        }
      });
    });
    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _played = 0;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (widget.voiceUrl == null) {
      // TODO(community): voice-note recording/upload not yet implemented.
      return;
    }
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(UrlSource(widget.voiceUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color onTint = ext?.ink2 ?? cs.onSurfaceVariant;

    // 24 bars mimicking the design waveform heights.
    const List<double> bars = [
      10, 18, 13, 22, 16, 24, 12, 20, 9, 17,
      14, 21, 11, 19, 15, 23, 13, 18, 10, 16,
      20, 12, 17, 14,
    ];
    final int playedCount = (bars.length * _played).floor();

    return Container(
      decoration: BoxDecoration(
        color: blueTint,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard - 4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // ── Play / pause button ───────────────────────────────────────────
          Semantics(
            button: true,
            label: _isPlaying
                ? 'Pause voice note'
                : 'Play voice note, ${widget.durationLabel}',
            child: GestureDetector(
              onTap: _togglePlayback,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.38),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: ExcludeSemantics(
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: AppDimensions.iconLg,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 13),

          // ── Waveform + time label ─────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waveform bars
                ExcludeSemantics(
                  child: SizedBox(
                    height: 26,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: bars.asMap().entries.map((entry) {
                        final bool played = entry.key < playedCount;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Container(
                              height: entry.value,
                              decoration: BoxDecoration(
                                color: cs.primary
                                    .withValues(alpha: played ? 1.0 : 0.38),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Time label
                Text(
                  'Voice note · ${widget.durationLabel} · tap to listen',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onTint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
