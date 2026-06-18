import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A settings row with an icon chip, title, optional subtitle, and a control
/// widget on the right (CSS: `.pr-setrow`).
///
/// Used inside a [ProfileSettingCard] bordered group. The last row in a group
/// should set [isLast] = true to suppress the bottom divider.
///
/// Accessibility: the row is not itself a button — the [control] widget
/// (e.g. [ProfileSwitch]) carries its own Semantics. The row [title] and
/// [subtitle] act as implicit context for adjacent screen-reader focus.
class ProfileSettingRow extends StatelessWidget {
  const ProfileSettingRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.control,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget control;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          // Icon chip
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: blueTint,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: ExcludeSemantics(
                child: Icon(icon, size: 22, color: blueStrong),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    letterSpacing: -0.2,
                    fontSize: 15.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ink3,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Control (switch, chevron, etc.)
          control,
        ],
      ),
    );
  }
}

/// A bordered card that groups [ProfileSettingRow]s with hairline dividers.
class ProfileSettingCard extends StatelessWidget {
  const ProfileSettingCard({super.key, required this.children});

  final List<ProfileSettingRow> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color bg = ext?.blueTint?.withValues(alpha: 0.35) ??
        cs.surfaceContainerLowest;
    final Color line = ext?.line ?? cs.outline;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: line, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(height: 1.5, thickness: 1.5, color: line),
          ],
        ],
      ),
    );
  }
}
