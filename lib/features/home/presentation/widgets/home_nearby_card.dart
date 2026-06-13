import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// "Navigate nearby" borderless card on the Opto Home screen.
///
/// Tapping navigates to the Accessibility Map screen. The leading chip shows a
/// faint grid pattern (to suggest a map) overlaid with a compass icon.
///
/// Design: `.nearby`, `.nearby-map` in `Android Home Dashboard.html` (V1).
class HomeNearbyCard extends StatelessWidget {
  const HomeNearbyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Semantics(
      button: true,
      label: 'Navigate nearby. 3 saved places, audio guidance.',
      child: GestureDetector(
        onTap: () {
          HapticPatterns.tabNav();
          context.go(AppRoutes.accessibilityMap.path);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Map-grid chip with compass icon ─────────────────────
              ExcludeSemantics(
                child: CustomPaint(
                  painter: _MapGridPainter(
                    gridColor: blueStrong.withValues(alpha: 0.14),
                  ),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: blueTint,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.explore_outlined,
                      size: AppDimensions.iconLg,
                      color: blueStrong,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── Text ─────────────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Navigate nearby',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '3 saved places · audio guidance',
                        style: TextStyle(
                          fontSize: 14,
                          color: ink2,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ──────────────────────────────────────
              ExcludeSemantics(
                child: Icon(Icons.chevron_right, size: 22, color: ink3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Faint map-grid painter ────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter({required this.gridColor});

  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    const step = 10.0;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MapGridPainter old) => old.gridColor != gridColor;
}
