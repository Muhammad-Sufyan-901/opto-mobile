import 'package:flutter/material.dart';

/// The Opto brand mark: a rounded square with a semi-transparent white fill
/// containing an aperture icon (outer stroked circle + filled inner dot).
///
/// Matches the design spec: 104×104dp container, radius 32, background
/// `rgba(255,255,255,0.15)`, aperture drawn at 52dp in white.
///
/// Reuse on any blue surface (splash, future loading states, etc.).
class OptoBrandMark extends StatelessWidget {
  const OptoBrandMark({
    super.key,
    this.size = 104.0,
    this.iconSize = 52.0,
    this.color = Colors.white,
  });

  /// Overall container side length — 104dp per design spec.
  final double size;

  /// Diameter of the aperture icon — 52dp per design spec.
  final double iconSize;

  /// Foreground colour for both the mark container tint and icon strokes.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      // Treated as a decorative logo; the adjacent "Opto" wordmark carries
      // the meaningful label so screen readers don't double-announce.
      label: 'Opto logo',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(32),
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
