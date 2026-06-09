import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Faithful recreation of the design-spec illustration placeholder.
///
/// Matches the `.opt-ph` rule in `Opto Onboarding.html`:
///   - background: `--blue-tint` fill
///   - diagonal 135° repeating stripes at blue @ 9% opacity
///   - 1.5px dashed border at blue @ 32%
///   - centred monospace caption at blue @ 80%, 12.5px
///
/// Wrapped in [ExcludeSemantics] — decorative placeholder only.
///
/// TODO: replace the [CustomPaint] body with an [Image.asset] once real
/// illustration assets are supplied.
class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({
    super.key,
    required this.label,
  });

  /// Caption text shown inside the placeholder (from the design canvas).
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primary = theme.colorScheme.primary;
    final Color blueTint =
        theme.extension<AppExtendedCustomColors>()?.blueTint ??
            theme.colorScheme.primaryContainer;

    return ExcludeSemantics(
      child: Container(
        height: 264,
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(
            color: primary.withValues(alpha: 0.32),
            width: 1.5,
            // Dashed effect via [CustomPaint] overlay below; Container border
            // provides the base stroke colour.
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Diagonal stripe pattern — 135° repeating lines at blue @ 9%.
            CustomPaint(
              painter: _StripePainter(color: primary),
            ),
            // Dashed border overlay drawn on top of the solid Container border.
            CustomPaint(
              painter: _DashedBorderPainter(
                color: primary.withValues(alpha: 0.32),
                radius: AppDimensions.radiusCard,
              ),
            ),
            // Centred mono caption.
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                    height: 1.5,
                    color: primary.withValues(alpha: 0.80),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Painters
// ---------------------------------------------------------------------------

/// Paints 135° diagonal lines (every 22px, 11px gap) at [color] @9% opacity.
class _StripePainter extends CustomPainter {
  const _StripePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.09)
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke;

    // Draw 135° diagonal lines (top-right to bottom-left).
    // Stride 22 covers the full size + guard tiles on edges.
    const double stride = 22.0;
    final double diagonal = size.width + size.height;

    for (double d = -diagonal; d < diagonal * 2; d += stride) {
      canvas.drawLine(
        Offset(d, 0),
        Offset(d - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Paints a dashed rounded-rect border to overlay the solid Container border.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
      Radius.circular(radius),
    );

    const double dashLen = 6.0;
    const double gapLen = 4.0;

    // Approximate the perimeter with a path and dash it.
    final Path path = Path()..addRRect(rrect);
    final ui.PathMetrics metrics = path.computeMetrics();

    for (final ui.PathMetric metric in metrics) {
      double dist = 0;
      bool draw = true;
      while (dist < metric.length) {
        final double len = draw ? dashLen : gapLen;
        if (draw) {
          canvas.drawPath(
            metric.extractPath(dist, dist + len),
            paint,
          );
        }
        dist += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
