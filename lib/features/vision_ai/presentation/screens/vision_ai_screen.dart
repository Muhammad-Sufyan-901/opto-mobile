import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/voice/aura_tts.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_mode.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';
import 'package:opto/features/vision_ai/presentation/cubit/vision_ai_cubit.dart';

/// Screen 16 — Vision AI Camera Viewfinder ("Aura").
///
/// A full-bleed dark camera UI that lets blind / low-vision users point
/// their device camera at the world and get audio + text readouts via
/// Aura AI.
///
/// Layout (top → bottom):
///   1. Top bar — close (×) · "Vision AI" title · flash toggle
///   2. Camera viewfinder (live preview + decorative reticle)
///   3. Readout pill — glassy live-region card with the latest AI result
///   4. Mode chips — Read text / Identify / Describe scene / Colors
///   5. Shutter row — gallery · shutter · mic
///
/// State is managed by [VisionAiCubit] (provided via [BlocProvider] in the
/// router). The screen uses [WidgetsBindingObserver] to pause / resume the
/// camera on app-lifecycle transitions.
///
/// Accessibility:
///   - Screen announced on mount (design_system.md §21.3).
///   - Readout pill is a `liveRegion` → TalkBack/VoiceOver reads new results.
///   - Results also spoken via [AuraTts] (independent of screen readers).
///   - Offline status announced both verbally and via `SemanticsService`.
///   - Camera preview wrapped in `ExcludeSemantics` (decorative).
///   - All interactive elements carry descriptive [Semantics] labels.
///   - Tap targets ≥ 48 × 48 dp (design_system.md §9).
class VisionAiScreen extends StatefulWidget {
  /// Optional initial mode set by a voice intent (e.g. [VisionMode.readText]
  /// from "Baca teks" / "Read text" voice command). Null → defaults to
  /// [VisionMode.readText].
  final VisionMode? initialMode;

  const VisionAiScreen({super.key, this.initialMode});

  @override
  State<VisionAiScreen> createState() => _VisionAiScreenState();
}

class _VisionAiScreenState extends State<VisionAiScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Start the camera + ML Kit warm-up.
      context.read<VisionAiCubit>().init(
            initialMode: widget.initialMode,
          );
      // Screen-arrival announcement (design_system.md §21.3).
      announce(
        context,
        'Vision AI. Point your camera to read text, '
        'identify objects, or describe scenes.',
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final cubit = context.read<VisionAiCubit>();
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        cubit.handleBackground();
      case AppLifecycleState.resumed:
        cubit.handleForeground();
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _close() {
    sl<AuraTts>().stop();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home.path);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VisionAiCubit, VisionAiState>(
      listenWhen: (_, curr) =>
          curr is VisionAiResult ||
          curr is VisionAiOfflineFallback ||
          curr is VisionAiError,
      listener: _onStateChange,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF0E1422),
          extendBodyBehindAppBar: true,
          body: _buildBody(context, state),
        );
      },
    );
  }

  // ── State listener ─────────────────────────────────────────────────────────

  void _onStateChange(BuildContext context, VisionAiState state) {
    switch (state) {
      case VisionAiResult(:final result):
        // Announce to screen reader as well (belt-and-suspenders with TTS).
        final text = _resultText(result);
        announce(context, text);
        HapticPatterns.success();

      case VisionAiOfflineFallback(:final result):
        // Must announce offline status via BOTH paths (risk flag #2).
        const offlineMsg =
            'Scene description needs internet — OCR still works.';
        announce(context, offlineMsg);
        sl<AuraTts>().speak(offlineMsg);
        final text = _resultText(result);
        announce(context, text);

      case VisionAiError(:final message):
        announce(context, 'Error: $message');
        HapticPatterns.warning();

      default:
        break;
    }
  }

  // ── Body builder ──────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context, VisionAiState state) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 1.2,
          colors: [Color(0xFF1B2640), Color(0xFF0A0F1C)],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Top bar ─────────────────────────────────────────────────
            _TopBar(
              onClose: _close,
              onToggleFlash: () =>
                  context.read<VisionAiCubit>().toggleFlash(),
              isFlashActive: context
                      .read<VisionAiCubit>()
                      .cameraController
                      ?.value
                      .flashMode ==
                  FlashMode.torch,
            ),

            // ── 2–5. Camera body ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // ── 2. Viewfinder / permission / loading ─────────────────
                  Expanded(
                    flex: 5,
                    child: _buildViewfinder(context, state),
                  ),

                  const Spacer(),

                  // ── 3. Readout pill ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18)
                        .copyWith(bottom: AppDimensions.space16),
                    child: _ReadoutPill(
                      primaryColor: cs.primary,
                      state: state,
                    ),
                  ),

                  // ── 4. Mode chips ─────────────────────────────────────────
                  _ModeChipRow(
                    activeMode: state.mode,
                    onSelect: (mode) =>
                        context.read<VisionAiCubit>().setMode(mode),
                  ),

                  // ── 5. Shutter row ────────────────────────────────────────
                  _ShutterRow(
                    isLoading: state.isLoading,
                    onCapture: () =>
                        context.read<VisionAiCubit>().capture(),
                    onGallery: () =>
                        context.read<VisionAiCubit>().analyzeFromGallery(),
                    onMic: _openVoiceSheet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Viewfinder area ────────────────────────────────────────────────────────

  Widget _buildViewfinder(BuildContext context, VisionAiState state) {
    return switch (state) {
      VisionAiPermissionDenied() => _PermissionDeniedView(
          onOpenSettings: openAppSettings,
        ),
      VisionAiInitializing() => const _LoadingView(
          message: 'Mempersiapkan kamera… Getting camera ready…',
        ),
      _ => _CameraView(
          controller:
              context.read<VisionAiCubit>().cameraController,
          isLoading: state.isLoading,
        ),
    };
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _resultText(VisionResult result) => switch (result) {
        final OcrResult r => r.toSpokenString(),
        final ObjectResult r => r.toSpokenString(),
        final ColorResult r => r.toSpokenString(),
        final SceneResult r => r.toSpokenString(),
      };

  void _openVoiceSheet() {
    // TODO(voice): open Aura Voice command bottom sheet.
    announce(context, 'Aura Voice — say a command.');
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Sub-widgets
// ══════════════════════════════════════════════════════════════════════════════

// ── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onClose,
    required this.onToggleFlash,
    required this.isFlashActive,
  });

  final VoidCallback onClose;
  final VoidCallback onToggleFlash;
  final bool isFlashActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: AppDimensions.space12,
      ),
      child: Row(
        children: [
          // Close button.
          Semantics(
            button: true,
            label: 'Close Vision AI',
            child: GestureDetector(
              onTap: onClose,
              child: const _DarkCircleButton(
                child: Icon(Icons.close, color: Colors.white, size: 22),
              ),
            ),
          ),

          const Expanded(
            child: Text(
              'Vision AI',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),

          // Flash toggle.
          Semantics(
            button: true,
            label: isFlashActive ? 'Turn flash off' : 'Turn flash on',
            child: GestureDetector(
              onTap: onToggleFlash,
              child: _DarkCircleButton(
                child: Icon(
                  isFlashActive ? Icons.bolt : Icons.bolt_outlined,
                  color: isFlashActive
                      ? Colors.yellow
                      : Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dark circle button ─────────────────────────────────────────────────────

class _DarkCircleButton extends StatelessWidget {
  const _DarkCircleButton({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ── Camera view (live preview + reticle + optional loading overlay) ──────────

class _CameraView extends StatelessWidget {
  const _CameraView({required this.controller, required this.isLoading});
  final CameraController? controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Camera preview — decorative; excluded from semantics tree.
        ExcludeSemantics(
          child: controller != null && controller!.value.isInitialized
              ? ClipRect(child: CameraPreview(controller!))
              : const SizedBox.expand(
                  child: ColoredBox(color: Color(0xFF0A0F1C)),
                ),
        ),

        // Viewfinder L-bracket reticle — decorative.
        const Center(child: _ViewfinderReticle()),

        // Analyzing overlay — semi-transparent with a spinner.
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.45),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Analyzing…',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Permission denied state ───────────────────────────────────────────────

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView({required this.onOpenSettings});
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              color: Colors.white54,
              size: 64,
            ),
            const SizedBox(height: 24),
            const Text(
              'Camera access needed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Opto needs camera access so Aura can read text and '
              'describe scenes for you. Open Settings to allow it.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: 'Open Settings to grant camera access',
              child: GestureDetector(
                onTap: onOpenSettings,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Open Settings',
                    style: TextStyle(
                      color: Color(0xFF0E1422),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

// ── Loading view ─────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white54),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ── Viewfinder reticle (4-corner L-brackets) ─────────────────────────────────

class _ViewfinderReticle extends StatelessWidget {
  const _ViewfinderReticle();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 200,
        height: 130,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: _Corner(
                topBorder: true,
                leftBorder: true,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(4)),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _Corner(
                topBorder: true,
                rightBorder: true,
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(4)),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _Corner(
                bottomBorder: true,
                leftBorder: true,
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(4)),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _Corner(
                bottomBorder: true,
                rightBorder: true,
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({
    this.topBorder = false,
    this.bottomBorder = false,
    this.leftBorder = false,
    this.rightBorder = false,
    required this.borderRadius,
  });

  final bool topBorder;
  final bool bottomBorder;
  final bool leftBorder;
  final bool rightBorder;
  final BorderRadius borderRadius;

  static const Color _color = Color(0xFF78AAFF);
  static const double _size = 30;
  static const double _width = 3;

  BorderSide get _active =>
      const BorderSide(color: _color, width: _width);
  BorderSide get _none => BorderSide.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        border: Border(
          top: topBorder ? _active : _none,
          bottom: bottomBorder ? _active : _none,
          left: leftBorder ? _active : _none,
          right: rightBorder ? _active : _none,
        ),
        borderRadius: borderRadius,
      ),
    );
  }
}

// ── Readout pill ──────────────────────────────────────────────────────────────

/// Glassy pill showing the latest AI readout as a live region.
///
/// During analysis, shows a bilingual "Analyzing…" placeholder.
/// After a result, shows the result text. Offline fallback includes
/// the offline notice.
class _ReadoutPill extends StatelessWidget {
  const _ReadoutPill({
    required this.primaryColor,
    required this.state,
  });

  final Color primaryColor;
  final VisionAiState state;

  String get _text => switch (state) {
        VisionAiInitializing() =>
          'Point your camera at something to analyse.',
        VisionAiPermissionDenied() => 'Camera access required.',
        VisionAiReady() =>
          'Point your camera and press the shutter.',
        VisionAiCapturing() => 'Capturing…',
        VisionAiAnalyzing(:final mode) =>
          mode == VisionMode.describeScene
              ? 'Describing scene…'
              : 'Analyzing…',
        VisionAiResult(:final result) => _toDisplayText(result),
        VisionAiOfflineFallback(:final result) =>
          'Offline — ${_toDisplayText(result)}',
        VisionAiError(:final message) => 'Error: $message',
      };

  String _toDisplayText(VisionResult r) => switch (r) {
        final OcrResult r =>
          r.text.isNotEmpty ? r.text : 'No text found.',
        final ObjectResult r =>
          r.labels.isEmpty ? 'Nothing identified.' : r.labels.take(3).join(', '),
        final ColorResult r =>
          r.dominantColors.isEmpty
              ? 'No dominant color.'
              : r.dominantColors.join(', '),
        final SceneResult r => r.description,
      };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Read aloud: $_text',
      child: GestureDetector(
        // Single tap replays the spoken result (design_system.md §12.2).
        onTap: () => context.read<VisionAiCubit>().replay(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFF2F6FF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
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

// ── Mode chip row ─────────────────────────────────────────────────────────────

class _ModeChipRow extends StatelessWidget {
  const _ModeChipRow({
    required this.activeMode,
    required this.onSelect,
  });

  final VisionMode activeMode;
  final ValueChanged<VisionMode> onSelect;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18)
          .copyWith(bottom: AppDimensions.space16),
      child: Row(
        children: [
          for (int i = 0; i < VisionMode.values.length; i++) ...[
            _ModeChip(
              mode: VisionMode.values[i],
              isActive: VisionMode.values[i] == activeMode,
              primaryColor: cs.primary,
              onTap: () => onSelect(VisionMode.values[i]),
            ),
            if (i < VisionMode.values.length - 1)
              const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.mode,
    required this.isActive,
    required this.primaryColor,
    required this.onTap,
  });

  final VisionMode mode;
  final bool isActive;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: '${mode.label} mode${isActive ? ", selected" : ""}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space8,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? primaryColor
                : Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            mode.label,
            style: TextStyle(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.70),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shutter row ───────────────────────────────────────────────────────────────

class _ShutterRow extends StatelessWidget {
  const _ShutterRow({
    required this.isLoading,
    required this.onCapture,
    required this.onGallery,
    required this.onMic,
  });

  final bool isLoading;
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 36,
        vertical: AppDimensions.space24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left — gallery button.
          Semantics(
            button: true,
            label: 'Open gallery',
            child: GestureDetector(
              onTap: isLoading ? null : onGallery,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.article_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Center — shutter button.
          Semantics(
            button: true,
            label: isLoading ? 'Analyzing' : 'Capture photo',
            child: GestureDetector(
              onTap: isLoading ? null : onCapture,
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLoading
                        ? Colors.white38
                        : Colors.white,
                    width: 4,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isLoading
                        ? Colors.white38
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(18),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Right — mic / Aura Voice button.
          Semantics(
            button: true,
            label: 'Open Aura Voice commands',
            child: GestureDetector(
              onTap: onMic,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.mic, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
