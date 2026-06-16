import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';

/// Pure-Dart on-device dominant-color detector.
///
/// Reads the raw RGBA pixels of an image file via [dart:ui] and samples
/// a 20 × 20 grid of pixels to identify the 3 most prominent color groups.
/// No external packages required — works entirely offline.
///
/// Must be called on the main (UI) isolate because [ui.decodeImageFromList]
/// requires the Flutter engine's image decoder.
class ColorDetector {
  const ColorDetector();

  // ── Bilingual color definitions (EN / ID) ─────────────────────────────────
  //
  // Each entry maps a display name to its reference [r, g, b] centroid.
  // The nearest-centroid algorithm assigns each sampled pixel to one bucket.
  static const List<(String name, int r, int g, int b)> _palette = [
    ('Black / Hitam', 0, 0, 0),
    ('White / Putih', 255, 255, 255),
    ('Red / Merah', 220, 30, 30),
    ('Orange / Oranye', 230, 120, 30),
    ('Yellow / Kuning', 240, 210, 30),
    ('Green / Hijau', 30, 140, 30),
    ('Teal / Hijau Kebiruan', 30, 150, 140),
    ('Blue / Biru', 30, 80, 200),
    ('Purple / Ungu', 130, 30, 180),
    ('Pink / Merah Muda', 240, 100, 170),
    ('Brown / Coklat', 140, 80, 30),
    ('Gray / Abu-abu', 140, 140, 140),
  ];

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Detects the dominant colors in the image at [filePath].
  ///
  /// Returns a [ColorResult] with up to 3 color names, most-dominant first.
  /// Throws [SensorFailure] on I/O or decoding error.
  Future<ColorResult> detectColors(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final dominantColors = await _analyze(bytes);
      return ColorResult(dominantColors: dominantColors);
    } catch (e) {
      debugPrint('[ColorDetector] error: $e');
      if (e is SensorFailure) rethrow;
      throw SensorFailure(
        'Deteksi warna gagal: ${e.toString()}',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<List<String>> _analyze(Uint8List jpegBytes) async {
    final image = await _decodeImage(jpegBytes);
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    image.dispose();

    if (byteData == null) return [];

    return _sampleAndBucket(
      byteData,
      image.width,
      image.height,
    );
  }

  /// Decodes JPEG bytes to a [ui.Image] using the Flutter engine codec.
  Future<ui.Image> _decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  /// Samples a 20 × 20 grid, buckets each pixel to the nearest
  /// palette centroid, and returns the top-3 color names.
  List<String> _sampleAndBucket(
    ByteData data,
    int width,
    int height,
  ) {
    const gridSize = 20;
    final counts = <String, int>{};

    final stepX = (width / gridSize).ceil();
    final stepY = (height / gridSize).ceil();

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final px = (col * stepX).clamp(0, width - 1);
        final py = (row * stepY).clamp(0, height - 1);
        final offset = (py * width + px) * 4; // RGBA
        if (offset + 3 >= data.lengthInBytes) continue;

        final r = data.getUint8(offset);
        final g = data.getUint8(offset + 1);
        final b = data.getUint8(offset + 2);
        // Skip near-transparent pixels.
        final a = data.getUint8(offset + 3);
        if (a < 128) continue;

        final name = _nearestColor(r, g, b);
        counts[name] = (counts[name] ?? 0) + 1;
      }
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(3).map((e) => e.key).toList();
  }

  /// Returns the palette entry name whose [r, g, b] centroid is
  /// closest (Euclidean distance in RGB space) to the given pixel.
  String _nearestColor(int r, int g, int b) {
    String best = _palette.first.$1;
    int bestDist = _squaredDist(r, g, b, _palette.first);

    for (final entry in _palette.skip(1)) {
      final d = _squaredDist(r, g, b, entry);
      if (d < bestDist) {
        bestDist = d;
        best = entry.$1;
      }
    }
    return best;
  }

  int _squaredDist(
    int r,
    int g,
    int b,
    (String, int, int, int) entry,
  ) {
    final dr = r - entry.$2;
    final dg = g - entry.$3;
    final db = b - entry.$4;
    return dr * dr + dg * dg + db * db;
  }
}
