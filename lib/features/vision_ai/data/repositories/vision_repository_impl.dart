import 'package:flutter/foundation.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/network/connectivity_service.dart';
import 'package:opto/features/vision_ai/data/datasources/color_detector.dart';
import 'package:opto/features/vision_ai/data/datasources/ml_kit_vision_datasource.dart';
import 'package:opto/features/vision_ai/data/datasources/scene_describe_remote_datasource.dart';
import 'package:opto/features/vision_ai/data/vision_ai_config.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';
import 'package:opto/features/vision_ai/domain/repositories/vision_repository.dart';

/// Concrete implementation of [VisionRepository].
///
/// Composes three data sources:
/// - [MlKitVisionDatasource] — on-device OCR and object detection.
/// - [ColorDetector] — on-device dominant-color pixel analysis.
/// - [SceneDescribeRemoteDatasource] — cloud scene description via the
///   `scene-describe` Edge Function (Google Gemini 2.5 Flash-Lite).
///
/// For [describeScene], this implementation applies a layered degradation
/// strategy:
///
///   0. **Cloud gate** — if [VisionAiConfig.cloudSceneAllowed] is `false`
///      (free tier + production build), the cloud call is skipped entirely
///      and the on-device fallback is returned immediately with a spoken
///      notice. No network request is made.
///
///   1. **Online + Gemini available** → delegates to the Edge Function.
///      Returns [SceneResultSource.cloud] with a Bahasa Indonesia caption.
///
///   2. **Offline** (no connectivity) → runs on-device ML Kit object detection
///      and composes a bilingual fallback, emitting
///      [SceneResultSource.offlineFallback].
///
///   3. **Cloud failure** ([NetworkFailure] timeout or [ServerFailure] from
///      Gemini, e.g. 502 / 503) → same on-device fallback path as offline.
///      The user is never left with a silent UI.
///
///   4. **Quota exhausted** ([RateLimitFailure] from HTTP 429) → on-device
///      fallback tagged [SceneResultSource.quotaExhausted] with a distinct
///      spoken BI message ("Batas harian deskripsi tercapai — coba lagi
///      besok. OCR masih berfungsi.").
///
/// All other methods ([analyzeText], [detectObjects], [detectColors]) are
/// fully on-device and do not check connectivity.
class VisionRepositoryImpl implements VisionRepository {
  const VisionRepositoryImpl({
    required MlKitVisionDatasource mlKit,
    required ColorDetector colorDetector,
    required SceneDescribeRemoteDatasource remote,
    required ConnectivityService connectivity,
  })  : _mlKit = mlKit,
        _colorDetector = colorDetector,
        _remote = remote,
        _connectivity = connectivity;

  final MlKitVisionDatasource _mlKit;
  final ColorDetector _colorDetector;
  final SceneDescribeRemoteDatasource _remote;
  final ConnectivityService _connectivity;

  // ---------------------------------------------------------------------------
  // VisionRepository interface
  // ---------------------------------------------------------------------------

  @override
  Future<OcrResult> analyzeText(String filePath) =>
      _mlKit.analyzeText(filePath);

  @override
  Future<ObjectResult> detectObjects(String filePath) =>
      _mlKit.detectObjects(filePath);

  @override
  Future<ColorResult> detectColors(String filePath) =>
      _colorDetector.detectColors(filePath);

  @override
  Future<SceneResult> describeScene(String filePath) async {
    // ── Cloud gate (free tier + production → skip entirely) ───────────────────
    if (!VisionAiConfig.cloudSceneAllowed) {
      debugPrint(
        '[VisionRepositoryImpl] Cloud scene description disabled '
        '(free tier + production build). Using on-device fallback.',
      );
      return _disabledFallback(filePath);
    }

    // ── Offline gate ─────────────────────────────────────────────────────────
    final online = await _connectivity.isOnline;
    if (!online) {
      return _offlineFallback(filePath);
    }

    // ── Cloud attempt ─────────────────────────────────────────────────────────
    try {
      return await _remote.describeScene(filePath);
    } on NetworkFailure {
      // Request timed out (> 8 s) — degrade gracefully.
      debugPrint(
        '[VisionRepositoryImpl] Cloud timeout — using offline fallback.',
      );
      return _offlineFallback(filePath);
    } on RateLimitFailure catch (e) {
      // Gemini free-tier daily/per-minute quota hit (HTTP 429). Return the
      // on-device fallback tagged quotaExhausted so the cubit+screen can
      // surface a distinct spoken message ("Batas harian deskripsi tercapai").
      debugPrint(
        '[VisionRepositoryImpl] Quota exhausted — using on-device fallback. '
        'Detail: ${e.message}',
      );
      return _quotaFallback(filePath);
    } on ServerFailure catch (e) {
      // Gemini returned a server error (502/503 unavailable, etc.).
      // Degrade to on-device rather than surfacing a raw server error to the
      // user — the UI must never go silent (design_system.md §12.2).
      debugPrint(
        '[VisionRepositoryImpl] Cloud ServerFailure — using offline fallback. '
        'Detail: ${e.message}',
      );
      return _offlineFallback(filePath);
    }
  }

  @override
  Future<void> disposeResources() => _mlKit.close();

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// On-device fallback for scene description when offline or when the
  /// Edge Function is unavailable / returns a server error.
  ///
  /// Uses ML Kit object-detection labels as a proxy description and marks
  /// the result with [SceneResultSource.offlineFallback] so the cubit and
  /// screen can announce the degraded state to the user.
  ///
  /// The fallback message is bilingual (Bahasa Indonesia first, English
  /// second) so TalkBack users in either language get useful feedback.
  Future<SceneResult> _offlineFallback(String filePath) async {
    return _buildOnDeviceFallback(
      filePath: filePath,
      source: SceneResultSource.offlineFallback,
      unavailableMessage: 'Deskripsi tidak tersedia, coba lagi. '
          'Scene description unavailable, try again.',
      degradedMessage: 'Objek terdeteksi: {labels}. '
          'Deskripsi adegan memerlukan internet — OCR masih berfungsi. '
          'Scene description needs internet — OCR still works.',
    );
  }

  /// On-device fallback returned when cloud scene description is disabled
  /// (free tier + production build). Informs the user that the feature is
  /// unavailable in this build without exposing implementation details.
  Future<SceneResult> _disabledFallback(String filePath) async {
    return _buildOnDeviceFallback(
      filePath: filePath,
      source: SceneResultSource.offlineFallback,
      unavailableMessage: 'Deskripsi adegan tidak tersedia di build ini. '
          'OCR dan identifikasi objek masih berfungsi. '
          'Scene description is disabled in this build — '
          'OCR and object identification still work.',
      degradedMessage: 'Objek terdeteksi: {labels}. '
          'Deskripsi adegan tidak tersedia di build ini — OCR masih berfungsi. '
          'Scene description is disabled in this build — OCR still works.',
    );
  }

  /// On-device fallback returned when the Gemini free-tier quota is exhausted
  /// (HTTP 429). Tagged [SceneResultSource.quotaExhausted] so the cubit and
  /// screen surface the distinct spoken BI message from
  /// [SceneResult.toSpokenString()] rather than the generic offline notice.
  Future<SceneResult> _quotaFallback(String filePath) async {
    return _buildOnDeviceFallback(
      filePath: filePath,
      source: SceneResultSource.quotaExhausted,
      unavailableMessage: 'Batas harian deskripsi tercapai — coba lagi besok. '
          'OCR masih berfungsi.',
      degradedMessage: 'Batas harian deskripsi tercapai — coba lagi besok. '
          'OCR masih berfungsi. Objek terdeteksi: {labels}.',
    );
  }

  /// Shared helper: runs on-device object detection and builds a [SceneResult]
  /// with [source]. Substitutes `{labels}` in [degradedMessage] with detected
  /// labels. Falls back to [unavailableMessage] when detection fails or returns
  /// no labels.
  Future<SceneResult> _buildOnDeviceFallback({
    required String filePath,
    required SceneResultSource source,
    required String unavailableMessage,
    required String degradedMessage,
  }) async {
    try {
      final objects = await _mlKit.detectObjects(filePath);
      if (objects.labels.isEmpty) {
        return SceneResult(description: unavailableMessage, source: source);
      }
      final labelList = objects.labels.take(3).join(', ');
      return SceneResult(
        description: degradedMessage.replaceFirst('{labels}', labelList),
        source: source,
      );
    } catch (_) {
      // If even object detection fails, return a minimal spoken fallback.
      return SceneResult(description: unavailableMessage, source: source);
    }
  }
}
