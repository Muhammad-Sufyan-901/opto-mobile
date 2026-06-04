import 'package:flutter/material.dart';

/// The Opto brand mark: a rounded square containing an aperture icon.
///
/// **Splash / blue-surface variant** (defaults): 104×104dp, radius 32,
/// white foreground at 15% alpha fill, 52dp white aperture.
///
/// **Auth-hub variant**: 60×60dp, radius 18, [backgroundColor] supplied
/// as `blueTint`, icon [color] as `primary`.
///
/// ```dart
/// // Splash (default):
/// const OptoBrandMark()
///
/// // Auth hub (pass explicit colours from Theme):
/// OptoBrandMark(
///   size: 60, iconSize: 30, radius: 18,
///   backgroundColor: ext.blueTint,
///   color: cs.primary,
/// )
/// ```
class OptoBrandMark extends StatelessWidget {
  const OptoBrandMark({
    super.key,
    this.size = 104.0,
    this.iconSize = 52.0,
    this.color = Colors.white,
    this.backgroundColor,
    this.radius = 32.0,
  });

  /// Overall container side length — 104dp per design spec.
  final double size;

  /// Diameter of the aperture icon — 52dp per design spec.
  final double iconSize;

  /// Foreground colour for the icon strokes.
  /// Defaults to white (splash on blue surface).
  final Color color;

  /// Explicit container background colour.
  /// When null, falls back to `color.withValues(alpha: 0.15)` (splash default).
  final Color? backgroundColor;

  /// Container corner radius — 32 for splash, 18 for auth hub.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Color fill = backgroundColor ?? color.withValues(alpha: 0.15);

    return Semantics(
      // Treated as a decorative logo; the adjacent "Opto" wordmark carries
      // the meaningful label so screen readers don't double-announce.
      label: 'Opto logo',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: CustomPaint(
            size: Size.square(iconSize),
            painter: _ApertureIconPainter(color: color),
          ),
        ),
      ),
    );
  }
}

/// Draws the Opto aperture icon: a stroked circle (r ≈ 9/12 of size) with a
/// solid filled dot in the centre (r ≈ 3.4/12 of size).
///
/// Based on the `I.aperture` SVG in `opto-system.jsx`:
///   viewBox="0 0 24 24"
///   outer circle: cx12 cy12 r9, stroke
///   inner dot:    cx12 cy12 r3.4, fill
class _ApertureIconPainter extends CustomPainter {
  const _ApertureIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 24.0;
    final Offset center = Offset(12 * scale, 12 * scale);

    // Outer stroked circle — r9 in the 24×24 viewBox.
    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale
      ..isAntiAlias = true;

    canvas.drawCircle(center, 9 * scale, strokePaint);

    // Inner filled dot — r3.4 in the 24×24 viewBox.
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(center, 3.4 * scale, fillPaint);
  }

  @override
  bool shouldRepaint(_ApertureIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
