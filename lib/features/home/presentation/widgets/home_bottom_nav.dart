import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Persistent bottom navigation bar for the Opto Home screen — **M3 pill** style.
///
/// 5 tabs: Home · Community · Vision AI (center) · Consult · Profile.
/// Vision AI occupies the bold center slot — filled blue pill, white icon,
/// drop shadow — styled like a Threads-style add button.
/// Active standard tab: 62×32 radius-16 pill with [blueTint] background.
/// Inactive tabs use [ink3] for icon and label.
///
/// Icon is always paired with a visible text label — never colour-only,
/// per `CLAUDE.md` accessibility rules and `design_system.md §9`.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, this.activeTab = 0});

  /// Zero-based index of the currently active tab.
  final int activeTab;

  // Vision AI is index 2 (center).
  static const List<_TabItem> _tabs = [
    _TabItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: AppRoutes.home,
    ),
    _TabItem(
      label: 'Community',
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum,
      route: AppRoutes.community,
    ),
    _TabItem(
      label: 'Vision AI',
      icon: Icons.visibility_outlined,
      activeIcon: Icons.visibility,
      route: AppRoutes.visionAi,
      isCenter: true,
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
        color: cs.surface,
        border: Border(top: BorderSide(color: divider, width: 1.5)),
      ),
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(total, (i) {
          final tab = _tabs[i];
          final bool active = i == activeTab;

          if (tab.isCenter) {
            return _CenterVisionAiButton(
              tab: tab,
              active: active,
              index: i,
              total: total,
              cs: cs,
            );
          }

          final Color iconColor = active ? cs.secondary : inactive;
          final Color labelColor = active ? cs.onSurface : inactive;

          return Expanded(
            child: Semantics(
              label: '${tab.label} tab ${i + 1} of $total',
              button: true,
              selected: active,
              child: GestureDetector(
                onTap: () {
                  announce(context, '${tab.label} tab ${i + 1} of $total');
                  HapticPatterns.tabNav();
                  context.go(tab.route.path);
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
                          active ? tab.activeIcon : tab.icon,
                          size: 24,
                          color: iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ExcludeSemantics(
                      child: Text(
                        tab.label,
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

// ── Center Vision AI bold button ─────────────────────────────────────────────

class _CenterVisionAiButton extends StatelessWidget {
  const _CenterVisionAiButton({
    required this.tab,
    required this.active,
    required this.index,
    required this.total,
    required this.cs,
  });

  final _TabItem tab;
  final bool active;
  final int index;
  final int total;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: '${tab.label} tab ${index + 1} of $total',
        button: true,
        selected: active,
        child: GestureDetector(
          onTap: () {
            announce(context, '${tab.label} tab ${index + 1} of $total');
            HapticPatterns.tabNav();
            context.go(tab.route.path);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bold filled pill — Threads-style center button.
              ExcludeSemantics(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 72,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.38),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    active ? tab.activeIcon : tab.icon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ExcludeSemantics(
                child: Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: active ? cs.primary : cs.primary.withValues(alpha: 0.75),
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
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
  final bool isCenter;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.isCenter = false,
  });
}
