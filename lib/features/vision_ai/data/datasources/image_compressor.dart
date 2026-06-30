import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Compresses a raw JPEG image for upload to the `scene-describe` Edge Function.
///
/// Contract (locked in `vision_ai_model_research.md` §2):
///   - Resize so the longest edge is at most [_maxLongestEdge] (1024 px).
///   - Re-encode as JPEG at [_jpegQuality] (85).
///   - Total base64 payload after compression is well under the 1 MB limit
///     imposed by the Edge Function.
///
/// The resize is only applied when the image actually exceeds 1024 px on its
/// longest dimension, so sub-1024 images (e.g. gallery thumbnails) are
/// re-encoded at quality 85 without scaling.
///
/// All CPU-bound work runs in a background isolate via [compute] to avoid
/// jank on the UI thread during or immediately after camera capture.
class ImageCompressor {
  const ImageCompressor._();

  /// Maximum pixels on the longest edge before downscaling.
  static const int _maxLongestEdge = 1024;

  /// JPEG encoding quality (0–100). 85 balances latency vs. model accuracy.
  static const int _jpegQuality = 85;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Decodes [rawBytes] (any format supported by `package:image`), resizes if
  /// the longest edge exceeds 1024 px, and returns JPEG bytes at quality 85.
  ///
  /// Runs entirely in a background isolate — safe to call from a cubit or
  /// repository without blocking the UI thread.
  static Future<Uint8List> compressToJpeg(Uint8List rawBytes) =>
      compute(_compressInBackground, rawBytes);

  // ---------------------------------------------------------------------------
  // Background isolate work (top-level so compute() can serialize it)
  // ---------------------------------------------------------------------------

  /// Top-level function executed by [compute] in an isolate.
  ///
  /// Kept private (prefixed with `_`) so it doesn't pollute the library API;
  /// [compute] requires a top-level (or static) function — hence the use of
  /// a named top-level function rather than a lambda.
  static Uint8List _compressInBackground(Uint8List rawBytes) {
    // Decode — handles JPEG, PNG, HEIF-JPEG, and other camera output formats.
    final decoded = img.decodeImage(rawBytes);
    if (decoded == null) {
      // If decoding fails, return the raw bytes unchanged so the caller can
      // still attempt the upload (the Edge Function will reject oversized ones).
      return rawBytes;
    }

    img.Image output = decoded;

    // Resize only when the longest dimension exceeds the cap.
    final longestEdge =
        decoded.width > decoded.height ? decoded.width : decoded.height;
    if (longestEdge > _maxLongestEdge) {
      if (decoded.width >= decoded.height) {
        // Landscape or square — width is the longest edge.
        output = img.copyResize(
          decoded,
          width: _maxLongestEdge,
          // height=0 → preserve aspect ratio.
          interpolation: img.Interpolation.average,
        );
      } else {
        // Portrait — height is the longest edge.
        output = img.copyResize(
          decoded,
          height: _maxLongestEdge,
          interpolation: img.Interpolation.average,
        );
      }
    }

    // Encode as JPEG at the target quality.
    final jpeg = img.encodeJpg(output, quality: _jpegQuality);
    return Uint8List.fromList(jpeg);
  }
}
