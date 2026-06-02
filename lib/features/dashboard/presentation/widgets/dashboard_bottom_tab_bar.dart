import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardBottomTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DashboardBottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bottomInset = MediaQuery.of(context).padding.bottom;
    const double tabHeight = 65;
    const double shadowSpace = 20;

    return SizedBox(
      height: tabHeight + bottomInset + shadowSpace,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Vector
          Positioned.fill(
            child: CustomPaint(
              painter: _TabBarPainter(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              ),
            ),
          ),

          // Icons
          Positioned(
            left: 0,
            right: 0,
            top: shadowSpace,
            height: tabHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  icon: PhosphorIconsRegular.house,
                  activeIcon: PhosphorIconsFill.house,
                  label: "Beranda",
                  index: 0,
                ),

                // Center Floating Button
                GestureDetector(
                  onTap: () => onTap(1),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 28),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: PhosphorIcon(
                        PhosphorIconsBold.play,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                _buildNavItem(
                  context,
                  icon: PhosphorIconsRegular.user,
                  activeIcon: PhosphorIconsFill.user,
                  label: "Profil",
                  index: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final color = isSelected ? primaryColor : Colors.grey.shade400;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Container(
        width: 80,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarPainter extends CustomPainter {
  final Color color;

  _TabBarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    const double holeWidth = 120.0;
    const double holeHeight = 60.0;
    final double center = width / 2;
    const double startY = 20.0;

    Path path = Path()
      ..moveTo(0, startY)
      ..lineTo(center - holeWidth / 2, startY)
      ..quadraticBezierTo(
        center - holeWidth / 3,
        startY,
        center - holeWidth / 4,
        holeHeight / 2 + startY,
      )
      ..quadraticBezierTo(
        center,
        holeHeight + startY + 5,
        center + holeWidth / 4,
        holeHeight / 2 + startY,
      )
      ..quadraticBezierTo(
        center + holeWidth / 3,
        startY,
        center + holeWidth / 2,
        startY,
      )
      ..lineTo(width, startY)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Draw shadow
    canvas.drawPath(path.shift(const Offset(0, -2)), shadowPaint);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
