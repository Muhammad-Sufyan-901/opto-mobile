import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';

/// Top bar of the Opto Home screen.
///
/// Left  — greeting ("Good morning" / user name).
/// Right — notification bell chip (with unread dot badge) + user avatar circle.
///
/// Design: `.topbar`, `.greet-hi`, `.greet-name`, `.icon-btn`,
/// `.badge`, `.avatar` in `Opto Onboarding.html` (Dashboard section).
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Greeting (heading for screen-readers) ────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // "Good morning" — secondary body text
              Text(
                'Good morning',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ink2,
                  height: 1.3,
                ),
              ),
              // Name — headline / H1 for this screen
              Semantics(
                header: true,
                child: Text(
                  'Rian',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                    height: 1.12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Notification bell ─────────────────────────────────────────
        Semantics(
          label: 'Notifications. 1 unread.',
          button: true,
          child: GestureDetector(
            onTap: () {
              // TODO: open notifications panel
            },
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Bell circle
                  Container(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    decoration: BoxDecoration(
                      color: blueTint,
                      shape: BoxShape.circle,
                    ),
                    child: ExcludeSemantics(
                      child: Icon(
                        Icons.notifications_outlined,
                        size: AppDimensions.iconLg,
                        color: blueStrong,
                      ),
                    ),
                  ),
                  // Unread dot badge — 9dp circle, danger colour, 2dp white ring.
                  Positioned(
                    top: 11,
                    right: 12,
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

        const SizedBox(width: 12),

        // ── Avatar — 52dp blue circle with initials ───────────────────
        Semantics(
          label: 'Profile — Rian',
          button: true,
          child: GestureDetector(
            onTap: () {
              // TODO: navigate to profile screen
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ExcludeSemantics(
                child: Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
