import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A 3-cell statistics strip used on Profile Home and My Activity screens
/// (CSS: `.co-stats` / `.co-statcell`).
///
/// Each cell shows a large number and a label. Cells are separated by
/// hairline vertical dividers.
///
/// Accessibility: each cell is a [Semantics] container with its combined
/// label (e.g. "142 Posts").
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.stats,
  });

  final List<ProfileStat> stats;

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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: line, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (int i = 0; i < stats.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 1.5,
                  thickness: 1.5,
                  color: line,
                  indent: 12,
                  endIndent: 12,
                ),
              Expanded(
                child: Semantics(
                  label: '${stats[i].value} ${stats[i].label}',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExcludeSemantics(
                          child: Text(
                            stats[i].value,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              letterSpacing: -0.4,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        ExcludeSemantics(
                          child: Text(
                            stats[i].label.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ext?.ink3 ?? cs.onSurfaceVariant,
                              fontSize: 11.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProfileStat {
  const ProfileStat({required this.value, required this.label});

  final String value;
  final String label;
}
