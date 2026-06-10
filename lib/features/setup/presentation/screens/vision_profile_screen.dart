import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/setup/presentation/widgets/setup_option_tile.dart';
import 'package:opto/features/setup/presentation/widgets/setup_step_scaffold.dart';

/// Screen 10 — Vision profile selection.
///
/// Spec: `ScreenVision` / `.ob-head` / `.ob-options` in `Opto Onboarding.html`.
///
/// Allows the user to select how they experience their vision so Opto can
/// tune itself accordingly. Selection is local [StatefulWidget] state; the
/// chosen value is passed forward when a backend/BLoC is wired up.
///
/// Layout via [SetupStepScaffold] (step 1/4, progress bar, scrollable body,
/// pinned "Continue" CTA).
class VisionProfileScreen extends StatefulWidget {
  const VisionProfileScreen({super.key});

  @override
  State<VisionProfileScreen> createState() => _VisionProfileScreenState();
}

class _VisionProfileScreenState extends State<VisionProfileScreen> {
  // Default to "Low vision" as shown in the design.
  String _selected = 'low_vision';

  static const List<_VisionOption> _options = [
    _VisionOption(
      key: 'blind',
      icon: Icons.visibility_off_outlined,
      title: 'Blind',
      desc: 'Little or no usable vision',
    ),
    _VisionOption(
      key: 'low_vision',
      icon: Icons.remove_red_eye_outlined,
      title: 'Low vision',
      desc: 'Some usable sight, needs support',
    ),
    _VisionOption(
      key: 'prosthetic',
      icon: Icons.adjust,
      title: 'Ocular prosthetic',
      desc: 'One or both eyes',
    ),
    _VisionOption(
      key: 'prefer_not',
      icon: Icons.person_outline,
      title: 'Prefer not to say',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();

    return SetupStepScaffold(
      step: 1,
      totalSteps: 4,
      ctaLabel: 'Continue',
      ctaSuffixIcon: Icons.arrow_forward,
      onCta: () => context.push(AppRoutes.setupDisplay.path),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.space24),

          // ── Eyebrow ────────────────────────────────────
          Text(
            'PROFILE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppDimensions.space8),

          // ── Title ──────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              'How do you experience your vision?',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
                height: 1.18,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space8),

          // ── Subtitle ───────────────────────────────────
          Text(
            'This tunes Opto for you. You can change it any time.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ext?.ink2 ?? theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Option tiles ───────────────────────────────
          ..._options.map(
            (opt) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.space12),
              child: SetupOptionTile(
                icon: opt.icon,
                title: opt.title,
                desc: opt.desc,
                selected: _selected == opt.key,
                onTap: () => setState(() => _selected = opt.key),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space8),
        ],
      ),
    );
  }
}

// ── Internal data class ──────────────────────────────────────────────────────

class _VisionOption {
  const _VisionOption({
    required this.key,
    required this.icon,
    required this.title,
    this.desc,
  });

  final String key;
  final IconData icon;
  final String title;
  final String? desc;
}
