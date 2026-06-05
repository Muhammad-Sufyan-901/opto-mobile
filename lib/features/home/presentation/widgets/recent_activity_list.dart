import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

/// Recent-activity section on the Opto Home screen.
///
/// Shows the "RECENT ACTIVITY" section label (with a "See all" action link)
/// and a fixed list of the three most recent activity rows.
///
/// Content is hardcoded to match the design; will be replaced by
/// `HomeSummaryRepository` once the domain/data layer is built (⛔ Planned).
///
/// Design: `.act-list`, `.act-row`, `.sec-row`, `.sec-action` in
/// `Opto Onboarding.html` (Dashboard section).
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  static const List<_ActivityItem> _items = [
    _ActivityItem(
      icon: Icons.visibility_outlined,
      title: 'Read a letter from BPJS',
      time: 'Today · 08:14',
    ),
    _ActivityItem(
      icon: Icons.forum_outlined,
      title: 'Replied in "Low-vision tips"',
      time: 'Yesterday · 19:02',
    ),
    _ActivityItem(
      icon: Icons.medical_services_outlined,
      title: 'Booked Dr. Anwar — eye check',
      time: 'Mon · 14:30',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Section header row ──────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            ExcludeSemantics(
              child: Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                  color: ink3,
                  height: 1.2,
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'See all recent activity',
              child: GestureDetector(
                onTap: () {
                  // TODO: navigate to full activity history
                },
                child: ExcludeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Activity rows ───────────────────────────────────────────────
        ..._items.map((item) => _ActivityRow(item: item)),
      ],
    );
  }
}

// ── Single activity row ──────────────────────────────────────────────────────

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Semantics(
      label: '${item.title}. ${item.time}.',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Icon chip (44×44, radius 12)
            ExcludeSemantics(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: blueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 22, color: blueStrong),
              ),
            ),

            const SizedBox(width: 14),

            // Title + time
            Expanded(
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.time,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: ink3,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ───────────────────────────────────────────────────────────────

class _ActivityItem {
  final IconData icon;
  final String title;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
  });
}
