import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_mode.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';

part 'vision_ai_state.freezed.dart';

/// State machine for [VisionAiCubit].
///
/// Transitions (normal flow):
///   [initializing] → [ready] (camera + ML Kit warmed up)
///   [ready]        → [capturing] (shutter or gallery pressed)
///   [capturing]    → [analyzing] (image captured, ML / cloud running)
///   [analyzing]    → [result] or [offlineFallback] or [error]
///   [result]       → [ready] (user changes mode or taps again)
///
/// Alternative paths:
///   [initializing] → [permissionDenied] (camera permission not granted)
///   Any state      → [error] (unexpected failure)
///
/// The [mode] field is carried through all post-initialization states so
/// that mode-chip rebuilds are triggered by a proper state inequality
/// (freezed equality compares [mode] by enum value).
@freezed
sealed class VisionAiState with _$VisionAiState {
  /// Camera and ML Kit are being initialised (permission check + warm-up).
  const factory VisionAiState.initializing() = VisionAiInitializing;

  /// Camera or microphone permission was denied by the user.
  ///
  /// The screen shows a recoverable "open Settings" prompt instead
  /// of a blank viewfinder.
  const factory VisionAiState.permissionDenied() = VisionAiPermissionDenied;

  /// Camera is live and ready; [mode] reflects the currently selected chip.
  const factory VisionAiState.ready({
    @Default(VisionMode.readText) VisionMode mode,
  }) = VisionAiReady;

  /// Shutter or gallery button pressed; image capture in progress.
  const factory VisionAiState.capturing({
    required VisionMode mode,
  }) = VisionAiCapturing;

  /// Image captured; ML Kit or Edge Function analysis is running.
  const factory VisionAiState.analyzing({
    required VisionMode mode,
  }) = VisionAiAnalyzing;

  /// Analysis completed successfully.
  ///
  /// [result] is one of [OcrResult], [ObjectResult], [ColorResult],
  /// or [SceneResult] depending on [mode].
  const factory VisionAiState.result({
    required VisionResult result,
    required VisionMode mode,
  }) = VisionAiResult;

  /// Cloud scene description was unavailable; an on-device fallback
  /// [result] was produced instead.
  ///
  /// The screen must announce the offline status via both
  /// [SemanticsService.sendAnnouncement] and [AuraTts] (risk flag #2).
  const factory VisionAiState.offlineFallback({
    required VisionResult result,
    required VisionMode mode,
  }) = VisionAiOfflineFallback;

  /// An unexpected error occurred. [message] is displayed and spoken.
  const factory VisionAiState.error({
    required String message,
    @Default(VisionMode.readText) VisionMode mode,
  }) = VisionAiError;
}

// ---------------------------------------------------------------------------
// Convenience extension — avoids repeated switch boilerplate in the screen.
// ---------------------------------------------------------------------------

extension VisionAiStateX on VisionAiState {
  /// The active [VisionMode], or [VisionMode.readText] for states
  /// where mode is not meaningful (initializing / permissionDenied).
  VisionMode get mode => switch (this) {
        VisionAiReady(:final mode) => mode,
        VisionAiCapturing(:final mode) => mode,
        VisionAiAnalyzing(:final mode) => mode,
        VisionAiResult(:final mode) => mode,
        VisionAiOfflineFallback(:final mode) => mode,
        VisionAiError(:final mode) => mode,
        VisionAiInitializing() => VisionMode.readText,
        VisionAiPermissionDenied() => VisionMode.readText,
      };

  /// The latest [VisionResult], or `null` if none is available yet.
  VisionResult? get latestResult => switch (this) {
        VisionAiResult(:final result) => result,
        VisionAiOfflineFallback(:final result) => result,
        _ => null,
      };

  /// True when the camera can accept new captures.
  bool get canCapture => switch (this) {
        VisionAiReady() => true,
        VisionAiResult() => true,
        VisionAiOfflineFallback() => true,
        VisionAiError() => true,
        _ => false,
      };

  /// True when a long-running async operation is in progress.
  bool get isLoading => switch (this) {
        VisionAiInitializing() => true,
        VisionAiCapturing() => true,
        VisionAiAnalyzing() => true,
        _ => false,
      };
}
