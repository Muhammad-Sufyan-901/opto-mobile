import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Persistent bottom navigation bar for the Opto Home screen.
///
/// 5 tabs: Home · Vision AI · Community · Consult · Profile.
/// Active tab: [ColorScheme.primary] colour + a 24×3.5 dp top-dot indicator.
/// Inactive tabs: [AppExtendedCustomColors.ink3].
///
/// Icon is always paired with a visible text label — never colour-only,
/// per `CLAUDE.md` accessibility rules and `design_system.md §9`.
///
/// Design: `.botnav`, `.tab`, `.tab-dot`, `.tab-label` in
/// `Opto Onboarding.html` (Dashboard section).
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, this.activeTab = 0});

  /// Zero-based index of the currently active tab.
  final int activeTab;

  static const List<String> _routes = [
    '/home',
    '/vision-ai',
    '/community',
    '/consult',
    '/profile',
  ];

  static const List<_TabItem> _tabs = [
    _TabItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _TabItem(
      label: 'Vision AI',
      icon: Icons.visibility_outlined,
      activeIcon: Icons.visibility,
    ),
    _TabItem(
      label: 'Community',
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum,
    ),
    _TabItem(
      label: 'Consult',
      icon: Icons.medical_services_outlined,
      activeIcon: Icons.medical_services,
    ),
    _TabItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color inactive = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color line = ext?.line ?? cs.outline;
    final int total = _tabs.length;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: line, width: 1.5)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: List.generate(total, (i) {
          final bool active = i == activeTab;
          final Color color = active ? cs.primary : inactive;

          return Expanded(
            child: Semantics(
              // Announce "Home tab 1 of 5" per design_system.md §12.
              label: '${_tabs[i].label} tab ${i + 1} of $total',
              button: true,
              selected: active,
              child: GestureDetector(
                onTap: () {
                  announce(
                    context,
                    '${_tabs[i].label} tab ${i + 1} of $total',
                  );
                  HapticPatterns.tabNav();
                  context.go(_routes[i]);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top-dot indicator (active only) — 24×3.5 dp, radius 3.
                    if (active)
                      Container(
                        width: 24,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      )
                    else
                      const SizedBox(height: 3.5),

                    const SizedBox(height: 6),

                    ExcludeSemantics(
                      child: Icon(
                        active ? _tabs[i].activeIcon : _tabs[i].icon,
                        size: 24,
                        color: color,
                      ),
                    ),

                    const SizedBox(height: 5),

                    ExcludeSemantics(
                      child: Text(
                        _tabs[i].label,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: color,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Private data class ───────────────────────────────────────────────────────

class _TabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
