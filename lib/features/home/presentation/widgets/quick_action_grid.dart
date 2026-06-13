import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';

/// Quick-actions 2×2 grid for the Opto Home screen — **V1 Card Stack** style.
///
/// Four tappable tiles leading to the main Opto modules.
/// Each tile has a Material-3 **surface-container background** (light grey),
/// a **blue-tint rounded icon chip** at the top, and left-aligned dark text.
///
/// Design: `.tiles`, `.tile`, `.tile-ic`, `.tile-lbl`, `.tile-sub`
/// in `Android Home Dashboard.html` (V1 Card Stack).
///
/// The section "Quick actions" label is rendered by the parent [HomeScreen]
/// via [HomeSectionHeader]; this widget renders tiles only.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const List<_QuickAction> _actions = [
    _QuickAction(
      icon: Icons.visibility_outlined,
      label: 'Vision AI',
      sub: 'See & read for me',
      semanticLabel: 'Vision AI. See and read for me.',
      route: AppRoutes.visionAi,
    ),
    _QuickAction(
      icon: Icons.accessibility_new,
      label: 'Prosthetic Hub',
      sub: 'Care & fitting',
      semanticLabel: 'Prosthetic Hub. Care and fitting.',
      route: AppRoutes.prostheticHub,
    ),
    _QuickAction(
      icon: Icons.medical_services_outlined,
      label: 'Consult',
      sub: 'Book or call',
      semanticLabel: 'Consult. Book or call.',
      route: AppRoutes.consult,
    ),
    _QuickAction(
      icon: Icons.forum_outlined,
      label: 'Community',
      sub: 'Talk & share',
      semanticLabel: 'Community. Talk and share.',
      route: AppRoutes.community,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Row 1
        Row(
          children: [
            Expanded(child: _QuickActionTile(action: _actions[0])),
            const SizedBox(width: 12),
            Expanded(child: _QuickActionTile(action: _actions[1])),
          ],
        ),

        const SizedBox(height: 12),

        // Row 2
        Row(
          children: [
            Expanded(child: _QuickActionTile(action: _actions[2])),
            const SizedBox(width: 12),
            Expanded(child: _QuickActionTile(action: _actions[3])),
          ],
        ),
      ],
    );
  }
}

// ── Single tile ──────────────────────────────────────────────────────────────

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: action.semanticLabel,
      child: GestureDetector(
        onTap: () {
          HapticPatterns.tabNav();
          context.go(action.route.path);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 118),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                spreadRadius: -8,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Semi-transparent white icon chip (48×48, radius 14)
              ExcludeSemantics(
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(action.icon, size: AppDimensions.iconLg, color: Colors.white),
                ),
              ),

              const SizedBox(height: 14),

              // White title + subtitle — left-aligned
              ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      action.label,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      action.sub,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Data class ───────────────────────────────────────────────────────────────

class _QuickAction {
  final IconData icon;
  final String label;
  final String sub;
  final String semanticLabel;
  final AppRoute route;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.sub,
    required this.semanticLabel,
    required this.route,
  });
}
