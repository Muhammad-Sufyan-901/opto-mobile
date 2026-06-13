import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Persistent bottom navigation bar for the Opto Home screen — **M3 pill** style.
///
/// 5 tabs: Home · Vision AI · Community · Consult · Profile.
/// Active tab: 62×32 radius-16 pill with [blueTint] background, [cs.secondary]
/// icon, and [cs.onSurface] label. Inactive tabs use [ink3] for both.
/// Top border: `outlineVariant` (--ov).
///
/// Icon is always paired with a visible text label — never colour-only,
/// per `CLAUDE.md` accessibility rules and `design_system.md §9`.
///
/// Design: `.nav`, `.nav-item`, `.nav-pill`, `.nav-lbl`
/// in `Android Home Dashboard.html` (V1 Card Stack).
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, this.activeTab = 0});

  /// Zero-based index of the currently active tab.
  final int activeTab;

  static const List<_TabItem> _tabs = [
    _TabItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: AppRoutes.home,
    ),
    _TabItem(
      label: 'Vision AI',
      icon: Icons.visibility_outlined,
      activeIcon: Icons.visibility,
      route: AppRoutes.visionAi,
    ),
    _TabItem(
      label: 'Community',
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum,
      route: AppRoutes.community,
    ),
    _TabItem(
      label: 'Consult',
      icon: Icons.medical_services_outlined,
      activeIcon: Icons.medical_services,
      route: AppRoutes.consult,
    ),
    _TabItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color inactive = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color divider = ext?.divider ?? cs.outlineVariant;
    final int total = _tabs.length;

    return Container(
      decoration: BoxDecoration(
        // sc2 (nav / bottom bar) = surface in V1.
        color: cs.surface,
        border: Border(top: BorderSide(color: divider, width: 1.5)),
      ),
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 14),
      child: Row(
        children: List.generate(total, (i) {
          final bool active = i == activeTab;
          final Color iconColor = active ? cs.secondary : inactive;
          final Color labelColor = active ? cs.onSurface : inactive;

          return Expanded(
            child: Semantics(
              label: '${_tabs[i].label} tab ${i + 1} of $total',
              button: true,
              selected: active,
              child: GestureDetector(
                onTap: () {
                  announce(context, '${_tabs[i].label} tab ${i + 1} of $total');
                  HapticPatterns.tabNav();
                  context.go(_tabs[i].route.path);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // M3 pill: 62×32, radius 16, blueTint bg when active.
                    ExcludeSemantics(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 62,
                        height: 32,
                        decoration: BoxDecoration(
                          color: active ? blueTint : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          active
                              ? _tabs[i].activeIcon
                              : _tabs[i].icon,
                          size: 24,
                          color: iconColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    ExcludeSemantics(
                      child: Text(
                        _tabs[i].label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: labelColor,
                          height: 1.2,
                        ),
                      ),
                    ),
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
  final AppRoute route;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}
