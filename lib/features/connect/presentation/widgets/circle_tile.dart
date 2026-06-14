import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/circle_entity.dart';

class CircleTile extends StatelessWidget {
  const CircleTile({
    super.key,
    required this.circle,
    required this.onTap,
  });

  final CircleEntity circle;
  final VoidCallback onTap;

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

  String _memberLabel(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k members';
    }
    return '$count members';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    // AppExtendedCustomColors has no `tint2` or `onTint` fields;
    // fall back to Material ColorScheme equivalents.
    final blueTint = ext?.blueTint ?? cs.primaryContainer;
    final tint2 = cs.surfaceContainerHigh;
    final onTint = cs.primary;
    final ink = cs.onSurface;
    final ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final line = ext?.line ?? cs.outline;

    return Semantics(
      label:
          '${circle.name}, ${_memberLabel(circle.memberCount)}${circle.unread ? ", has new posts" : ""}',
      button: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: tint2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_icon(circle.iconKey), color: onTint, size: 24),
              ),
              const SizedBox(height: 11),
              Text(
                circle.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: ink,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  if (circle.unread) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      _memberLabel(circle.memberCount),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: ink3,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
