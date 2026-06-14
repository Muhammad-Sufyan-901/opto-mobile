import 'package:flutter/material.dart';
import 'package:opto/features/connect/domain/entities/circle_entity.dart';

/// Gradient cover card for the Circle Detail screen.
class CircleCover extends StatelessWidget {
  const CircleCover({super.key, required this.circle});

  final CircleEntity circle;

  IconData _icon(String? key) {
    return switch (key) {
      'aperture' => Icons.camera_outlined,
      'eye' => Icons.remove_red_eye_outlined,
      'sparkle' => Icons.auto_awesome_outlined,
      'stethoscope' => Icons.medical_services_outlined,
      'smartphone' => Icons.phone_android_outlined,
      'trophy' => Icons.emoji_events_outlined,
      _ => Icons.group_outlined,
    };
  }

  List<Color> _gradientColors(String? colorKey, Color primary) {
    return switch (colorKey) {
      'violet' => [const Color(0xFF7C3AED), const Color(0xFF5B21B6)],
      'green' => [const Color(0xFF16A34A), const Color(0xFF166534)],
      'amber' => [const Color(0xFFD97706), const Color(0xFF92400E)],
      _ => [primary, primary.withValues(alpha: 0.75)],
    };
  }

  String _memberLabel(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k members';
    return '$count members';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final colors = _gradientColors(circle.colorKey, cs.primary);

    return Semantics(
      label: '${circle.name}. ${_memberLabel(circle.memberCount)}.',
      excludeSemantics: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(_icon(circle.iconKey), color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              circle.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.group_outlined, color: Colors.white, size: 17),
                const SizedBox(width: 6),
                Text(
                  _memberLabel(circle.memberCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
