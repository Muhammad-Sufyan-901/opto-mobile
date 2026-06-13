import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

/// Screen C6 — Live Consultation Call Room (voice-first; visual stub).
///
/// Receives `Map<String, dynamic> {'doctor': DoctorEntity?}` via GoRouter extra.
///
/// Features:
/// - "LIVE · Voice consult" status chip + blinking red dot + ticking timer.
/// - Doctor presence avatar + "Speaking…" label + animated waveform.
/// - Live-captions card (liveRegion: true) — large text at high contrast / 300 %.
/// - Mute / Speaker / Captions / Video control toggles (local state).
/// - Red "End consult" button → pushReplacement to [SummaryScreen].
///
/// All animations (waveform, blink) are gated on [MediaQuery.disableAnimations].
/// The high-contrast + large-text skin is driven by the app's global theme +
/// [MediaQuery.textScaler], not a separate screen.
class CallRoomScreen extends StatelessWidget {
  const CallRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final doctor = extra?['doctor'] as DoctorEntity?;
    return _CallRoomView(doctor: doctor);
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _CallRoomView extends StatefulWidget {
  const _CallRoomView({this.doctor});

  final DoctorEntity? doctor;

  @override
  State<_CallRoomView> createState() => _CallRoomViewState();
}

class _CallRoomViewState extends State<_CallRoomView>
    with TickerProviderStateMixin {
  // ── Call state ──────────────────────────────────────────────────────────────
  int _seconds = 0;
  Timer? _ticker;

  // ── Control toggles ─────────────────────────────────────────────────────────
  bool _muted = false;
  bool _speakerOn = true;
  bool _captionsOn = true;
  bool _videoOn = false;

  // ── Animations ──────────────────────────────────────────────────────────────
  late final AnimationController _waveCtrl;
  late final AnimationController _blinkCtrl;

  bool _reduceMotion = false;

  // Mock caption text rotated to simulate live speech.
  static const _captions = [
    '"Let\'s keep cleaning the prosthesis twice a day with the saline. '
        'The redness should settle within',
    '"The slight discharge is normal while healing. Use the lubricating gel '
        'each night. If it gets worse',
    '"You\'re doing everything right. Bring the prosthesis to the clinic in '
        'two weeks for a fit check."',
  ];
  int _captionIdx = 0;
  Timer? _captionTimer;

  @override
  void initState() {
    super.initState();

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reduceMotion = MediaQuery.of(context).disableAnimations;

      if (!_reduceMotion) {
        _waveCtrl.repeat(reverse: true);
        _blinkCtrl.repeat(reverse: true);
      }

      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });

      // Rotate caption every 6 s for demo effect.
      _captionTimer = Timer.periodic(const Duration(seconds: 6), (_) {
        if (mounted) {
          setState(() {
            _captionIdx = (_captionIdx + 1) % _captions.length;
          });
          SemanticsService.announce(
            _captions[_captionIdx],
            TextDirection.ltr,
          );
        }
      });

      announce(
        context,
        'Live consultation with ${widget.doctor?.fullName ?? 'your doctor'}. '
        'Voice call in progress. Live captions are on.',
      );
    });
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _blinkCtrl.dispose();
    _ticker?.cancel();
    _captionTimer?.cancel();
    super.dispose();
  }

  String get _initials {
    final name = widget.doctor?.fullName;
    if (name == null || name.trim().isEmpty) return 'NS';
    return name.trim().split(' ').take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }

  String get _timerLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _toggleControl(String label, bool newValue, VoidCallback update) {
    HapticPatterns.focusTick();
    update();
    SemanticsService.announce(
      '$label ${newValue ? 'on' : 'off'}.',
      TextDirection.ltr,
    );
  }

  void _endCall() {
    HapticPatterns.warning();
    _ticker?.cancel();
    _captionTimer?.cancel();
    SemanticsService.announce(
      'Consultation ended. Loading your summary.',
      TextDirection.ltr,
    );
    context.pushReplacement(
      AppRoutes.consultSummary.path,
      extra: {'doctor': widget.doctor},
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Column(
            children: [
              // ── Top status bar ─────────────────────────────────────────
              _TopBar(
                timerLabel: _timerLabel,
                blinkCtrl: _blinkCtrl,
                reduceMotion: _reduceMotion,
                cs: cs,
                ext: ext,
                theme: theme,
              ),

              const SizedBox(height: AppDimensions.space16),

              // ── Doctor stage (avatar + waveform) ───────────────────────
              Expanded(
                child: _DoctorStage(
                  initials: _initials,
                  doctorName: widget.doctor?.fullName ?? 'Your Doctor',
                  waveCtrl: _waveCtrl,
                  reduceMotion: _reduceMotion,
                  cs: cs,
                  ext: ext,
                  theme: theme,
                ),
              ),

              const SizedBox(height: AppDimensions.space12),

              // ── Live captions ──────────────────────────────────────────
              if (_captionsOn) ...[
                _CaptionsCard(
                  text: _captions[_captionIdx],
                  cs: cs,
                  ext: ext,
                  theme: theme,
                ),
                const SizedBox(height: 14),
              ],

              // ── Controls row ───────────────────────────────────────────
              _Controls(
                muted: _muted,
                speakerOn: _speakerOn,
                captionsOn: _captionsOn,
                videoOn: _videoOn,
                onMute: () => _toggleControl('Mute', !_muted, () => setState(() => _muted = !_muted)),
                onSpeaker: () => _toggleControl('Speaker', !_speakerOn, () => setState(() => _speakerOn = !_speakerOn)),
                onCaptions: () => _toggleControl('Captions', !_captionsOn, () => setState(() => _captionsOn = !_captionsOn)),
                onVideo: () => _toggleControl('Video', !_videoOn, () => setState(() => _videoOn = !_videoOn)),
                cs: cs,
                ext: ext,
                theme: theme,
              ),

              const SizedBox(height: AppDimensions.space12),

              // ── End consult ────────────────────────────────────────────
              _EndButton(onEnd: _endCall, cs: cs),
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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.timerLabel,
    required this.blinkCtrl,
    required this.reduceMotion,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final String timerLabel;
  final AnimationController blinkCtrl;
  final bool reduceMotion;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Status chip
        MergeSemantics(
          child: Semantics(
            label: 'Live voice consult in progress.',
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: ext?.line ?? cs.outline,
                  width: 1.5,
                ),
              ),
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Blinking live dot
                    AnimatedBuilder(
                      animation: blinkCtrl,
                      builder: (_, __) {
                        final opacity = reduceMotion
                            ? 1.0
                            : (0.3 + 0.7 * blinkCtrl.value).clamp(0.3, 1.0);
                        return Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ext?.dangerTint != null
                                  ? cs.error
                                  : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Live · Voice consult',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Timer
        Semantics(
          label: 'Call duration: $timerLabel',
          child: ExcludeSemantics(
            child: Text(
              timerLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
                letterSpacing: 0.5,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DoctorStage extends StatelessWidget {
  const _DoctorStage({
    required this.initials,
    required this.doctorName,
    required this.waveCtrl,
    required this.reduceMotion,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final String initials;
  final String doctorName;
  final AnimationController waveCtrl;
  final bool reduceMotion;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  static const _barBases = [14.0, 28.0, 20.0, 40.0, 30.0, 48.0,
      26.0, 38.0, 18.0, 44.0, 24.0, 34.0, 16.0, 30.0, 22.0, 42.0, 28.0, 20.0];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Avatar
        ExcludeSemantics(
          child: Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primary, cs.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.45),
                  blurRadius: 36,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        ExcludeSemantics(
          child: Text(
            doctorName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),

        const SizedBox(height: 4),

        ExcludeSemantics(
          child: Text(
            'Speaking…',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Animated waveform
        SizedBox(
          height: 54,
          child: AnimatedBuilder(
            animation: waveCtrl,
            builder: (_, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < _barBases.length; i++) ...[
                    if (i > 0) const SizedBox(width: 4),
                    Container(
                      width: 5,
                      height: reduceMotion
                          ? _barBases[i] * 0.7
                          : (_barBases[i] *
                                  (0.34 +
                                      0.66 *
                                          ((1 +
                                                  math.sin(waveCtrl.value *
                                                          2 *
                                                          math.pi +
                                                      i * 0.35)) /
                                              2)))
                              .clamp(4.0, 54.0),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CaptionsCard extends StatelessWidget {
  const _CaptionsCard({
    required this.text,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final String text;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isHighContrast = MediaQuery.of(context).highContrast;

    return Semantics(
      liveRegion: true,
      label: 'Live captions. $text',
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isHighContrast ? cs.primary : (ext?.line ?? cs.outline),
            width: isHighContrast ? 2.5 : 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Row(
                children: [
                  Icon(Icons.closed_caption_outlined,
                      size: isHighContrast ? 22 : 20, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    isHighContrast ? 'CAPTIONS' : 'Live captions',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                      letterSpacing: isHighContrast ? 0.8 : 0.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ExcludeSemantics(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  text,
                  key: ValueKey(text),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                    height: 1.5,
                    fontSize: isHighContrast ? 22 : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.muted,
    required this.speakerOn,
    required this.captionsOn,
    required this.videoOn,
    required this.onMute,
    required this.onSpeaker,
    required this.onCaptions,
    required this.onVideo,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final bool muted;
  final bool speakerOn;
  final bool captionsOn;
  final bool videoOn;
  final VoidCallback onMute;
  final VoidCallback onSpeaker;
  final VoidCallback onCaptions;
  final VoidCallback onVideo;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isHC = MediaQuery.of(context).highContrast;
    final btnH = isHC ? 66.0 : 58.0;

    return Row(
      children: [
        _Ctrl(
          icon: muted ? Icons.mic_off_outlined : Icons.mic_none_rounded,
          label: muted ? 'Unmute' : 'Mute',
          isOn: muted,
          btnH: btnH,
          onTap: onMute,
          cs: cs,
          ext: ext,
          theme: theme,
        ),
        const SizedBox(width: 10),
        _Ctrl(
          icon: Icons.volume_up_outlined,
          label: speakerOn ? 'Speaker on' : 'Speaker off',
          isOn: speakerOn,
          btnH: btnH,
          onTap: onSpeaker,
          cs: cs,
          ext: ext,
          theme: theme,
        ),
        const SizedBox(width: 10),
        _Ctrl(
          icon: Icons.closed_caption_outlined,
          label: captionsOn ? 'Captions on' : 'Captions off',
          isOn: captionsOn,
          btnH: btnH,
          onTap: onCaptions,
          cs: cs,
          ext: ext,
          theme: theme,
        ),
        const SizedBox(width: 10),
        _Ctrl(
          icon: videoOn ? Icons.videocam_outlined : Icons.videocam_off_outlined,
          label: videoOn ? 'Video on' : 'Video off',
          isOn: videoOn,
          btnH: btnH,
          onTap: onVideo,
          cs: cs,
          ext: ext,
          theme: theme,
        ),
      ],
    );
  }
}

class _Ctrl extends StatelessWidget {
  const _Ctrl({
    required this.icon,
    required this.label,
    required this.isOn,
    required this.btnH,
    required this.onTap,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final bool isOn;
  final double btnH;
  final VoidCallback onTap;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isHC = MediaQuery.of(context).highContrast;
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                height: btnH,
                decoration: BoxDecoration(
                  color: isOn ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ext?.line ?? cs.outline,
                    width: isHC ? 2.5 : 1.5,
                  ),
                ),
                child: ExcludeSemantics(
                  child: Icon(
                    icon,
                    size: isHC ? 28 : AppDimensions.iconLg,
                    color: isOn ? Colors.white : cs.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              ExcludeSemantics(
                child: Text(
                  label.split(' ').first,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isHC
                        ? cs.onSurface
                        : (ext?.ink2 ?? cs.onSurfaceVariant),
                    fontSize: isHC ? 13.5 : null,
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

class _EndButton extends StatelessWidget {
  const _EndButton({required this.onEnd, required this.cs});

  final VoidCallback onEnd;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final isHC = MediaQuery.of(context).highContrast;
    return Semantics(
      button: true,
      label: 'End consultation',
      child: SizedBox(
        width: double.infinity,
        height: isHC ? 68 : AppDimensions.buttonHeight,
        child: ElevatedButton(
          onPressed: onEnd,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusButton),
            ),
            elevation: 0,
          ),
          child: ExcludeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call_end_rounded, size: 26),
                const SizedBox(width: 10),
                Text(
                  isHC ? 'END CONSULT' : 'End consult',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: isHC ? 19 : 17,
                    letterSpacing: isHC ? 0.4 : 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

