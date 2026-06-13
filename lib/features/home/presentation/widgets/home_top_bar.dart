import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Top app bar of the Opto Home screen — **V1 Card Stack** layout.
///
/// Row: menu icon · "Opto" title · bell icon (with unread dot) · avatar "R".
/// Below the row: greeting block ("Good morning," / **"Rian"** as a heading).
///
/// Design: `.tb`, `.tb-icon`, `.tb-title`, `.tb-badge`, `.tb-avatar`,
/// `.greet`, `.greet-lead`, `.greet-name` in `Android Home Dashboard.html`.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── App-bar row ────────────────────────────────────────────────
        SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Menu icon button (48×48 tap target)
              Semantics(
                label: 'Menu',
                button: true,
                child: GestureDetector(
                  onTap: () {
                    // TODO: open navigation drawer / side menu.
                  },
                  child: SizedBox(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    child: Center(
                      child: ExcludeSemantics(
                        child: Icon(
                          Icons.menu,
                          size: AppDimensions.iconLg,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // "Opto" title — 22/w600
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ExcludeSemantics(
                  child: Text(
                    'Opto',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Notification bell (48×48) with unread dot badge
              Semantics(
                label: 'Notifications. 1 unread.',
                button: true,
                child: GestureDetector(
                  onTap: () {
                    // TODO: open notifications panel.
                  },
                  child: SizedBox(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        ExcludeSemantics(
                          child: Icon(
                            Icons.notifications_outlined,
                            size: AppDimensions.iconLg,
                            color: cs.onSurface,
                          ),
                        ),
                        // Red dot badge (9dp) — error colour
                        Positioned(
                          top: 9,
                          right: 9,
                          child: ExcludeSemantics(
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: cs.error,
                                shape: BoxShape.circle,
                                border: Border.all(color: cs.surface, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Avatar — 44dp blue circle with initials
              Semantics(
                label: 'Profile — Rian',
                button: true,
                child: GestureDetector(
                  onTap: () {
                    // TODO: navigate to profile screen.
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: ExcludeSemantics(
                      child: Text(
                        'R',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Greeting block ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 2, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // "Good morning," — secondary body text (on-surface-variant)
              Text(
                'Good morning,',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ink2,
                  height: 1.3,
                ),
              ),
              // Name — H1 heading for this screen (28/w600)
              Semantics(
                header: true,
                child: Text(
                  'Rian',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
