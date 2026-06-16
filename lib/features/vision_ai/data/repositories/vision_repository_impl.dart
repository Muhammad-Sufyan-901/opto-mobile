import 'package:flutter/foundation.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/network/connectivity_service.dart';
import 'package:opto/features/vision_ai/data/datasources/color_detector.dart';
import 'package:opto/features/vision_ai/data/datasources/ml_kit_vision_datasource.dart';
import 'package:opto/features/vision_ai/data/datasources/scene_describe_remote_datasource.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';
import 'package:opto/features/vision_ai/domain/repositories/vision_repository.dart';

/// Concrete implementation of [VisionRepository].
///
/// Composes three data sources:
/// - [MlKitVisionDatasource] — on-device OCR and object detection.
/// - [ColorDetector] — on-device dominant-color pixel analysis.
/// - [SceneDescribeRemoteDatasource] — cloud scene description via
///   the `scene-describe` Edge Function (Anthropic Claude).
///
/// For [describeScene], this implementation gates on connectivity:
/// - **Online** → delegates to the Edge Function.
/// - **Offline** → runs on-device object detection and composes a
///   bilingual fallback description, emitting
///   [SceneResultSource.offlineFallback].
///
/// All other methods are fully on-device and do not check connectivity.
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
    final online = await _connectivity.isOnline;
    if (!online) {
      return _offlineFallback(filePath);
    }
    try {
      return await _remote.describeScene(filePath);
    } on NetworkFailure {
      // Cloud timed out — degrade gracefully rather than crashing.
      debugPrint(
        '[VisionRepositoryImpl] Cloud timeout — using offline fallback.',
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
  /// Edge Function times out.
  ///
  /// Uses object-detection labels as a proxy description and marks the
  /// result with [SceneResultSource.offlineFallback] so the cubit and
  /// screen can announce the degraded state to the user.
  Future<SceneResult> _offlineFallback(String filePath) async {
    try {
      final objects = await _mlKit.detectObjects(filePath);
      final description = objects.labels.isEmpty
          ? 'Deskripsi adegan memerlukan internet — OCR masih berfungsi. '
              'Scene description needs internet — OCR still works.'
          : 'Objek terdeteksi: ${objects.labels.take(3).join(', ')}. '
              'Objects detected: ${objects.labels.take(3).join(', ')}. '
              'Scene description needs internet — OCR still works.';
      return SceneResult(
        description: description,
        source: SceneResultSource.offlineFallback,
      );
    } catch (_) {
      // If even object detection fails, return a minimal fallback.
      return const SceneResult(
        description:
            'Deskripsi adegan memerlukan internet — OCR masih berfungsi. '
            'Scene description needs internet — OCR still works.',
        source: SceneResultSource.offlineFallback,
      );
    }
  }
}
