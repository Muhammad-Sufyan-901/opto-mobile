import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

/// Quick-actions 2×2 grid for the Opto Home screen.
///
/// Four tappable tiles leading to the main Opto modules.
/// Each tile has a blue-primary background with a centred semi-transparent
/// white icon chip, a white title, and a white sub-label.
///
/// This is the user's final design iteration — the tiles use a **blue
/// primary background, white text, and a centred icon** per `chats/chat2.md`:
/// "change the quick action theme on home screen to be have blue primary
/// background and white text and then move the icon to center".
///
/// Design: `.qgrid`, `.qtile`, `.qtile-ic`, `.qtile-label`, `.qtile-sub`
/// in `Opto Onboarding.html` (Dashboard section).
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const List<_QuickAction> _actions = [
    _QuickAction(
      icon: Icons.visibility_outlined,
      label: 'Vision AI',
      sub: 'See & read for me',
      semanticLabel: 'Vision AI. See and read for me.',
    ),
    _QuickAction(
      icon: Icons.accessibility_new,
      label: 'Prosthetic Hub',
      sub: 'Care & fitting',
      semanticLabel: 'Prosthetic Hub. Care and fitting.',
    ),
    _QuickAction(
      icon: Icons.medical_services_outlined,
      label: 'Consult Doctor',
      sub: 'Book or call',
      semanticLabel: 'Consult Doctor. Book or call.',
    ),
    _QuickAction(
      icon: Icons.forum_outlined,
      label: 'Community',
      sub: 'Talk & share',
      semanticLabel: 'Community. Talk and share.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppExtendedCustomColors>();
    final Color ink3 =
        ext?.ink3 ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "QUICK ACTIONS" section eyebrow label
        ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              'QUICK ACTIONS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                color: ink3,
                height: 1.2,
              ),
            ),
          ),
        ),

        // Row 1
        Row(
          children: [
            Expanded(child: _QuickActionTile(action: _actions[0])),
            const SizedBox(width: 14),
            Expanded(child: _QuickActionTile(action: _actions[1])),
          ],
        ),

        const SizedBox(height: 14),

        // Row 2
        Row(
          children: [
            Expanded(child: _QuickActionTile(action: _actions[2])),
            const SizedBox(width: 14),
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
          // TODO: navigate to respective feature module (⛔ Planned).
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: cs.primary, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.55),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Semi-transparent white icon chip
              ExcludeSemantics(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(action.icon, size: 26, color: Colors.white),
                ),
              ),

              const SizedBox(height: 14),

              // White title
              ExcludeSemantics(
                child: Text(
                  action.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 2),

              // White sub-label
              ExcludeSemantics(
                child: Text(
                  action.sub,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.5,
                    height: 1.35,
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

// ── Data class ───────────────────────────────────────────────────────────────

class _QuickAction {
  final IconData icon;
  final String label;
  final String sub;
  final String semanticLabel;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.sub,
    required this.semanticLabel,
  });
}
