import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/setup/presentation/widgets/permission_tile.dart';
import 'package:opto/features/setup/presentation/widgets/setup_step_scaffold.dart';

/// Screen 13 — App permissions.
///
/// Checks current permission status on mount and requests each permission
/// when the user taps Allow. Uses [permission_handler] for real platform
/// permission APIs (camera, microphone, location).
class PermissionsSetupScreen extends StatefulWidget {
  const PermissionsSetupScreen({super.key});

  @override
  State<PermissionsSetupScreen> createState() => _PermissionsSetupScreenState();
}

class _PermissionsSetupScreenState extends State<PermissionsSetupScreen> {
  bool _cameraGranted = false;
  bool _micGranted = false;
  bool _locationGranted = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentStatuses();
  }

  Future<void> _checkCurrentStatuses() async {
    final results = await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
    ].request();
    if (!mounted) return;
    setState(() {
      _cameraGranted = results[Permission.camera]?.isGranted ?? false;
      _micGranted = results[Permission.microphone]?.isGranted ?? false;
      _locationGranted = results[Permission.location]?.isGranted ?? false;
    });
  }

  Future<void> _requestPermission(
    Permission permission,
    String label,
    void Function(bool granted) onResult,
  ) async {
    final status = await permission.request();
    if (!mounted) return;
    final granted = status.isGranted;
    onResult(granted);
    final message = granted ? '$label permission granted.' : '$label permission denied.';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, message);
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
            onAllow: () => _requestPermission(
              Permission.camera,
              'Camera',
              (granted) => setState(() => _cameraGranted = granted),
            ),
          ),

          const SizedBox(height: AppDimensions.space12),

          PermissionTile(
            icon: Icons.mic_none,
            title: 'Microphone',
            desc: 'Voice commands and calling for help',
            granted: _micGranted,
            onAllow: () => _requestPermission(
              Permission.microphone,
              'Microphone',
              (granted) => setState(() => _micGranted = granted),
            ),
          ),

          const SizedBox(height: AppDimensions.space12),

          PermissionTile(
            icon: Icons.location_on_outlined,
            title: 'Location',
            desc: 'Turn-by-turn walking directions',
            granted: _locationGranted,
            onAllow: () => _requestPermission(
              Permission.location,
              'Location',
              (granted) => setState(() => _locationGranted = granted),
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
