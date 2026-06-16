import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';

/// On-device Vision AI data source backed by Google ML Kit.
///
/// Wraps [TextRecognizer] (OCR) and [ObjectDetector] (object labelling).
/// Both models run on-device — no network required.
///
/// Lifecycle: call [close] when the feature is permanently torn down
/// (not just backgrounded) to release ML Kit resources.
///
/// Thread-safety: ML Kit Flutter plugins dispatch results on the main
/// isolate, so [analyzeText] and [detectObjects] must be called from
/// the main thread (e.g. from a Cubit that runs on the main event loop).
class MlKitVisionDatasource {
  MlKitVisionDatasource()
      : _textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin,
        ),
        _objectDetector = ObjectDetector(
          options: ObjectDetectorOptions(
            // Single-image mode (not stream); suitable for still captures.
            mode: DetectionMode.single,
            classifyObjects: true,
            multipleObjects: true,
          ),
        );

  final TextRecognizer _textRecognizer;
  final ObjectDetector _objectDetector;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Runs ML Kit OCR on the image at [filePath].
  ///
  /// Returns [OcrResult] with the full recognised text and individual
  /// text blocks. Throws [SensorFailure] on processing error.
  Future<OcrResult> analyzeText(String filePath) async {
    try {
      final inputImage = InputImage.fromFilePath(filePath);
      final recognised = await _textRecognizer.processImage(inputImage);
      final blocks =
          recognised.blocks.map((b) => b.text.trim()).toList();
      return OcrResult(
        text: recognised.text.trim(),
        blocks: blocks,
      );
    } catch (e) {
      debugPrint('[MlKitVisionDatasource] OCR error: $e');
      throw SensorFailure('OCR gagal: ${e.toString()}');
    }
  }

  /// Runs ML Kit object detection on the image at [filePath].
  ///
  /// Returns [ObjectResult] with labels sorted by confidence.
  /// Throws [SensorFailure] on processing error.
  Future<ObjectResult> detectObjects(String filePath) async {
    try {
      final inputImage = InputImage.fromFilePath(filePath);
      final detected = await _objectDetector.processImage(inputImage);

      // Collect all labels across all detected objects, highest
      // confidence first.  Deduplicate by label text.
      final seen = <String>{};
      final labels = <String>[];
      for (final obj in detected) {
        final sorted = List<Label>.from(obj.labels)
          ..sort(
            (a, b) => b.confidence.compareTo(a.confidence),
          );
        for (final label in sorted) {
          if (seen.add(label.text)) labels.add(label.text);
        }
      }
      return ObjectResult(labels: labels);
    } catch (e) {
      debugPrint('[MlKitVisionDatasource] Object detection error: $e');
      throw SensorFailure('Deteksi objek gagal: ${e.toString()}');
    }
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Releases ML Kit model resources. Call once when permanently done.
  Future<void> close() async {
    await _textRecognizer.close();
    await _objectDetector.close();
    debugPrint('[MlKitVisionDatasource] ML Kit resources released.');
  }
}
