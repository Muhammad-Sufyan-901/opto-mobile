import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/setup/presentation/widgets/permission_tile.dart';
import 'package:opto/features/setup/presentation/widgets/setup_step_scaffold.dart';

/// Screen 13 — App permissions.
///
/// Spec: `ScreenPermissions` / `.perm-list` / `.perm-note` in
/// `Opto Onboarding.html`.
///
/// Shows Camera, Microphone, and Location permission rows. Camera and
/// Microphone are pre-granted in the design; Location starts not-granted
/// and can be toggled via the "Allow" button (stubbed — real permission
/// requests wired up when the backend BLoC is added).
///
/// A shield note below the list reassures the user they stay in control.
///
/// Layout via [SetupStepScaffold] (step 4/4, CTA = "Finish setup").
class PermissionsSetupScreen extends StatefulWidget {
  const PermissionsSetupScreen({super.key});

  @override
  State<PermissionsSetupScreen> createState() => _PermissionsSetupScreenState();
}

class _PermissionsSetupScreenState extends State<PermissionsSetupScreen> {
  // Camera and mic pre-granted (matching design); location starts not-granted.
  bool _cameraGranted = true;
  bool _micGranted = true;
  bool _locationGranted = false;

  void _grantPermission(String name, VoidCallback grant) {
    // Stub: in production, call platform permission API then setState on
    // success. For now, immediately mark granted and announce via live region.
    grant();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, '$name permission granted.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();

    return SetupStepScaffold(
      step: 4,
      totalSteps: 4,
      ctaLabel: 'Finish setup',
      ctaSuffixIcon: Icons.arrow_forward,
      onCta: () => context.go(AppRoutes.setupDone.path),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.space24),

          // ── Eyebrow ────────────────────────────────────
          Text(
            'PERMISSIONS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.primary,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppDimensions.space8),

          // ── Title ──────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              'A few things to allow',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
                height: 1.18,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space8),

          // ── Subtitle ───────────────────────────────────
          Text(
            'Opto only uses these when you ask it to.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ext?.ink2 ?? cs.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Permission rows ────────────────────────────
          PermissionTile(
            icon: Icons.camera_alt_outlined,
            title: 'Camera',
            desc: 'Read text and identify objects around you',
            granted: _cameraGranted,
            onAllow: () => _grantPermission(
              'Camera',
              () => setState(() => _cameraGranted = true),
            ),
          ),

          const SizedBox(height: AppDimensions.space12),

          PermissionTile(
            icon: Icons.mic_none,
            title: 'Microphone',
            desc: 'Voice commands and calling for help',
            granted: _micGranted,
            onAllow: () => _grantPermission(
              'Microphone',
              () => setState(() => _micGranted = true),
            ),
          ),

          const SizedBox(height: AppDimensions.space12),

          PermissionTile(
            icon: Icons.location_on_outlined,
            title: 'Location',
            desc: 'Turn-by-turn walking directions',
            granted: _locationGranted,
            onAllow: () => _grantPermission(
              'Location',
              () => setState(() => _locationGranted = true),
            ),
          ),

          const SizedBox(height: AppDimensions.space20),

          // ── Shield note ────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.shield_outlined,
                  size: AppDimensions.iconMd,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Text(
                  "You're always in control. "
                  'Change these in Settings any time.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ext?.ink2 ?? cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.space8),
        ],
      ),
    );
  }
}
