import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

class MemberStatsRow extends StatelessWidget {
  const MemberStatsRow({
    super.key,
    required this.postsCount,
    required this.helpfulCount,
    required this.circlesCount,
  });

  final int postsCount;
  final int helpfulCount;
  final int circlesCount;

  String _fmt(int v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return '$v';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final blueTint = ext?.blueTint ?? cs.primaryContainer;
    final line = ext?.line ?? cs.outline;
    final ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final stats = [
      (_fmt(postsCount), 'Posts'),
      (_fmt(helpfulCount), 'Helpful'),
      ('$circlesCount', 'Circles'),
    ];

    return Semantics(
      label: '$postsCount posts, $helpfulCount helpful, $circlesCount circles',
      child: Container(
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          children: List.generate(stats.length, (i) {
            final (value, label) = stats[i];
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: i > 0
                    ? BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: line,
                            width: 1.5,
                          ),
                        ),
                      )
                    : null,
                child: Column(
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      label.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: ink3,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
