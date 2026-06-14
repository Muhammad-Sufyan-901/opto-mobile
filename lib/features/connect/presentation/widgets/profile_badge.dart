import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

enum ProfileBadgeVariant { blue, green, amber }

class ProfileBadge extends StatelessWidget {
  const ProfileBadge({
    super.key,
    required this.label,
    required this.icon,
    this.variant = ProfileBadgeVariant.blue,
  });

  final String label;
  final IconData icon;
  final ProfileBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    // AppExtendedCustomColors has no `tint2` or `onTint` fields;
    // fall back to Material ColorScheme equivalents.
    final (bg, fg) = switch (variant) {
      ProfileBadgeVariant.blue => (
          cs.primaryContainer,
          cs.primary,
        ),
      ProfileBadgeVariant.green => (
          ext?.greenTint ?? const Color(0xFFDCFCE7),
          ext?.green ?? const Color(0xFF16A34A),
        ),
      ProfileBadgeVariant.amber => (
          const Color(0xFFFEF3C7),
          const Color(0xFF92400E),
        ),
    };

    return Semantics(
      label: label,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
