import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';

/// Repository contract for Vision AI ("Aura") analysis operations.
///
/// All methods accept an image [filePath] (from [CameraController.takePicture]
/// or [ImagePicker.pickImage]) and return a typed domain result.
///
/// Implementations throw a [Failure] subclass
/// (from `lib/core/error/failures.dart`) on error — callers are
/// expected to wrap calls in try/catch and emit a typed error state.
///
/// On-device methods ([analyzeText], [detectObjects], [detectColors]) work
/// fully offline. [describeScene] prefers the cloud `scene-describe` Edge
/// Function but falls back gracefully when offline.
abstract class VisionRepository {
  /// Recognises text in the image at [filePath] using on-device ML Kit OCR.
  ///
  /// Supports Latin-script text (bilingual BI + EN) and Rupiah amounts.
  Future<OcrResult> analyzeText(String filePath);

  /// Detects and labels objects in the image at [filePath] using ML Kit.
  ///
  /// Returns labels sorted by confidence (highest first).
  Future<ObjectResult> detectObjects(String filePath);

  /// Detects dominant colors in the image at [filePath].
  ///
  /// Samples a pixel grid and returns up to 3 bilingual color names.
  Future<ColorResult> detectColors(String filePath);

  /// Produces a natural-language scene description.
  ///
  /// Online → calls the `scene-describe` Edge Function (Claude LLM).
  /// Offline → falls back to on-device object labels and announces
  /// the degraded state via [SceneResultSource.offlineFallback].
  Future<SceneResult> describeScene(String filePath);

  /// Releases underlying ML Kit model resources.
  ///
  /// Call when the Vision AI screen is permanently disposed (not just
  /// backgrounded) to avoid model memory leaks.
  Future<void> disposeResources();
}
