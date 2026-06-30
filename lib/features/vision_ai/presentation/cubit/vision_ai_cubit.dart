import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:opto/core/accessibility/haptic_patterns.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/voice/aura_tts.dart';
import 'package:opto/features/vision_ai/data/vision_ai_config.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_mode.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';
import 'package:opto/features/vision_ai/domain/repositories/vision_repository.dart';
import 'package:opto/features/vision_ai/presentation/cubit/vision_ai_state.dart';
import 'package:opto/features/vision_ai/presentation/widgets/scene_consent_sheet.dart';

export 'vision_ai_state.dart';

/// Cubit that drives the Vision AI screen ("Aura" camera viewfinder).
///
/// Responsibilities:
/// - Camera lifecycle (init, pause on background, resume on foreground,
///   dispose on cubit close).
/// - Mode management — emits [VisionAiReady] with the selected [VisionMode]
///   so the chip row updates via freezed state equality.
/// - Capture & analysis pipeline: shutter → [VisionAiCapturing] →
///   [VisionAiAnalyzing] → [VisionAiResult] / [VisionAiOfflineFallback].
/// - Gallery path via [ImagePicker].
/// - Flash toggle.
/// - Post-result TTS via [AuraTts] and camera-ready haptic.
/// - UU PDP consent gate for cloud scene description on the Gemini free plan:
///   emits [VisionAiConsentRequired] when consent has not been recorded yet;
///   [confirmConsent()] persists acceptance and resumes the captured image.
///
/// The [CameraController] is exposed as a public getter so the screen can
/// pass it to [CameraPreview] without rebuilding the entire widget subtree
/// on every state change.
class VisionAiCubit extends Cubit<VisionAiState> {
  VisionAiCubit({
    required VisionRepository repository,
    required Box<dynamic> consentBox,
  })  : _repository = repository,
        _consentBox = consentBox,
        super(const VisionAiState.initializing());

  final VisionRepository _repository;
  final Box<dynamic> _consentBox;
  final ImagePicker _picker = ImagePicker();

  CameraController? _controller;
  VisionResult? _lastResult;

  // Holds the image path captured when consent is pending, so we can resume
  // the analysis pipeline after the user accepts.
  String? _pendingConsentFilePath;

  // Public getter — screen builds CameraPreview from this.
  CameraController? get cameraController => _controller;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Initialises the camera and warms up ML Kit models.
  ///
  /// If [initialMode] is provided (e.g. from a voice intent), the cubit
  /// jumps straight to that mode after camera init.
  ///
  /// Handles permission-denied gracefully by emitting
  /// [VisionAiPermissionDenied] instead of crashing.
  Future<void> init({VisionMode? initialMode}) async {
    emit(const VisionAiState.initializing());

    // ── Permission check ─────────────────────────────────────────────────────
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      emit(const VisionAiState.permissionDenied());
      return;
    }

    // ── Camera discovery ─────────────────────────────────────────────────────
    late List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
    } catch (e) {
      debugPrint('[VisionAiCubit] availableCameras() error: $e');
      emit(const VisionAiState.error(message: 'Kamera tidak ditemukan.'));
      return;
    }

    if (cameras.isEmpty) {
      emit(const VisionAiState.error(message: 'Tidak ada kamera tersedia.'));
      return;
    }

    // Prefer the back camera for scanning; fall back to first available.
    final backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    // ── Controller init ──────────────────────────────────────────────────────
    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false, // audio not needed for Vision AI
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
    } catch (e) {
      debugPrint('[VisionAiCubit] CameraController.initialize() error: $e');
      emit(const VisionAiState.error(
        message: 'Gagal membuka kamera. Pastikan kamera tidak digunakan '
            'oleh aplikasi lain.',
      ));
      return;
    }

    if (isClosed) return;

    await HapticPatterns.cameraReady();

    emit(VisionAiState.ready(mode: initialMode ?? VisionMode.readText));
  }

  // ---------------------------------------------------------------------------
  // Mode management
  // ---------------------------------------------------------------------------

  /// Switches the active analysis mode and emits a new [VisionAiReady].
  ///
  /// If the current state is a completed [result] or [offlineFallback], the
  /// cubit returns to [ready] with the new mode — allowing the user to
  /// re-capture in a different mode without pressing back.
  void setMode(VisionMode mode) {
    if (isClosed) return;
    emit(VisionAiState.ready(mode: mode));
  }

  // ---------------------------------------------------------------------------
  // Capture & analysis
  // ---------------------------------------------------------------------------

  /// Triggers camera capture and runs the analysis pipeline.
  ///
  /// Guards against double-tap by returning early when already capturing
  /// or analyzing ([VisionAiState.canCapture] is `false`).
  ///
  /// For [VisionMode.describeScene] on the Gemini free plan, checks whether
  /// UU PDP consent has been recorded. If not, the image is captured silently
  /// and stored in [_pendingConsentFilePath], then [VisionAiConsentRequired]
  /// is emitted so the screen can present [SceneConsentSheet]. The analysis
  /// pipeline resumes only after [confirmConsent()] is called.
  Future<void> capture() async {
    final current = state;
    if (!current.canCapture) return;
    if (_controller == null || !_controller!.value.isInitialized) return;

    final mode = current.mode;
    emit(VisionAiState.capturing(mode: mode));

    try {
      final file = await _controller!.takePicture();

      // ── Consent gate for cloud scene description (free plan) ──────────────
      if (mode == VisionMode.describeScene &&
          VisionAiConfig.cloudSceneAllowed &&
          !SceneConsentSheet.hasConsented(_consentBox)) {
        _pendingConsentFilePath = file.path;
        if (!isClosed) {
          emit(VisionAiState.consentRequired(mode: mode));
        }
        return;
      }

      await _analyze(filePath: file.path, mode: mode);
    } catch (e) {
      debugPrint('[VisionAiCubit] capture error: $e');
      if (!isClosed) {
        emit(VisionAiState.error(
          message: 'Gagal mengambil foto: ${e.toString()}',
          mode: mode,
        ));
      }
    }
  }

  /// Called by the screen after the user taps "Setuju / Agree" on the
  /// [SceneConsentSheet]. Persists the consent and resumes the pending
  /// scene-description analysis pipeline.
  ///
  /// If there is no pending image (edge case), returns to [ready].
  Future<void> confirmConsent() async {
    await SceneConsentSheet.persistConsent(_consentBox);
    final pendingPath = _pendingConsentFilePath;
    _pendingConsentFilePath = null;

    if (pendingPath == null || isClosed) {
      if (!isClosed) {
        emit(VisionAiState.ready(mode: VisionMode.describeScene));
      }
      return;
    }
    await _analyze(filePath: pendingPath, mode: VisionMode.describeScene);
  }

  /// Called by the screen when the user cancels or dismisses the consent
  /// sheet. Clears the pending capture and returns to [ready].
  void cancelConsent() {
    _pendingConsentFilePath = null;
    if (!isClosed) {
      emit(VisionAiState.ready(mode: VisionMode.describeScene));
    }
  }

  /// Opens the system gallery picker and runs the analysis pipeline on
  /// the selected image.
  Future<void> analyzeFromGallery() async {
    final current = state;
    if (!current.canCapture) return;

    final mode = current.mode;
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return; // user cancelled
    if (isClosed) return;

    emit(VisionAiState.capturing(mode: mode));
    await _analyze(filePath: picked.path, mode: mode);
  }

  /// Re-speaks the last result via [AuraTts]. Safe to call at any time.
  Future<void> replay() async {
    final result = _lastResult;
    if (result == null) return;
    await _speak(result);
  }

  // ---------------------------------------------------------------------------
  // Flash
  // ---------------------------------------------------------------------------

  /// Toggles the camera flash between [FlashMode.torch] and [FlashMode.off].
  Future<void> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final current = _controller!.value.flashMode;
      await _controller!.setFlashMode(
        current == FlashMode.off ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('[VisionAiCubit] toggleFlash error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // App lifecycle helpers (called from screen's WidgetsBindingObserver)
  // ---------------------------------------------------------------------------

  /// Pauses the camera when the app goes to background.
  Future<void> handleBackground() async {
    try {
      await _controller?.pausePreview();
    } catch (_) {}
  }

  /// Resumes the camera when the app returns to foreground.
  Future<void> handleForeground() async {
    try {
      if (_controller?.value.isInitialized ?? false) {
        await _controller?.resumePreview();
      } else {
        // Controller was disposed while in background — re-init.
        final mode = state.mode;
        await init(initialMode: mode);
      }
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() async {
    await _controller?.dispose();
    await _repository.disposeResources();
    await super.close();
  }

  // ---------------------------------------------------------------------------
  // Private analysis pipeline
  // ---------------------------------------------------------------------------

  Future<void> _analyze({
    required String filePath,
    required VisionMode mode,
  }) async {
    if (isClosed) return;
    emit(VisionAiState.analyzing(mode: mode));

    try {
      final result = await switch (mode) {
        VisionMode.readText => _repository.analyzeText(filePath),
        VisionMode.identify => _repository.detectObjects(filePath),
        VisionMode.colors => _repository.detectColors(filePath),
        VisionMode.describeScene => _repository.describeScene(filePath),
      };

      _lastResult = result;
      if (isClosed) return;

      // Emit the appropriate state.
      // quotaExhausted shares the offlineFallback UI path (degraded display)
      // but its toSpokenString() returns a distinct BI spoken message.
      if (result is SceneResult &&
          (result.isOfflineFallback || result.isQuotaExhausted)) {
        emit(VisionAiState.offlineFallback(result: result, mode: mode));
      } else {
        emit(VisionAiState.result(result: result, mode: mode));
      }

      await HapticPatterns.success();
      await _speak(result);
    } catch (e) {
      debugPrint('[VisionAiCubit] analysis error: $e');
      if (!isClosed) {
        emit(VisionAiState.error(
          message: e.toString().replaceAll('Exception: ', ''),
          mode: mode,
        ));
      }
    }
  }

  Future<void> _speak(VisionResult result) async {
    final text = switch (result) {
      final OcrResult r => r.toSpokenString(),
      final ObjectResult r => r.toSpokenString(),
      final ColorResult r => r.toSpokenString(),
      final SceneResult r => r.toSpokenString(),
    };
    await sl<AuraTts>().speak(text);
  }
}
