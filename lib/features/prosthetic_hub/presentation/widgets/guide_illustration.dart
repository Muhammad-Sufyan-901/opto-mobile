// Widget: GuideIllustration
//
// Diagonal-stripe placeholder used as a visual stand-in for real care guide
// illustrations. Two variants:
//   • Default (banner): full-width banner with a centered icon + label chip.
//   • Mini (mini: true): small square thumbnail showing only the icon.
//
// Fully decorative — wrapped in ExcludeSemantics.
import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

class GuideIllustration extends StatelessWidget {
  const GuideIllustration({
    super.key,
    this.icon = Icons.remove_red_eye_outlined,
    this.label = 'Illustration',
    this.height = 150.0,
    this.mini = false,
  });

  /// Icon displayed in the center.
  final IconData icon;

  /// Short label shown below the icon (banner variant only).
  final String label;

  /// Height of the banner variant. Ignored when [mini] is true.
  final double height;

  /// When true, renders as a compact square thumbnail (no label).
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color onTint = cs.onPrimaryContainer;
    final Color line = ext?.line ?? cs.outline;

    if (mini) {
      return ExcludeSemantics(
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: blueTint,
            border: Border.all(color: line, width: 1.5),
          ),
          child: Icon(icon, size: 28, color: onTint),
        ),
      );
    }

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Diagonal-stripe background
              CustomPaint(painter: _StripePainter(color: blueTint)),
              // Centered floating card with icon + label
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: line, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 26, color: onTint),
                      const SizedBox(height: 6),
                      Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints evenly spaced diagonal stripes used as the illustration background.
class _StripePainter extends CustomPainter {
  const _StripePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    final stripe = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11;

    const spacing = 22.0;
    final total = size.width + size.height;
    for (double d = -size.height; d < total; d += spacing) {
      canvas.drawLine(Offset(d, 0), Offset(d + size.height, size.height), stripe);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.color != color;
}
