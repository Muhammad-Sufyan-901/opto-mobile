import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/widgets/setup_slider_block.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/widgets/setup_step_scaffold.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/widgets/setup_toggle_tile.dart';

/// Screen 11 — Text size & contrast setup.
///
/// Spec: `ScreenDisplay` / `.preview-card` / `.set-block` / `.set-toggle-row`
/// in `Opto Onboarding.html`.
///
/// Lets the user drag a text-size slider and toggle high-contrast mode.
/// The preview card updates its sample text size in real-time to show the
/// effect. High-contrast toggle is local UI state for now.
///
/// TODO: wire the high-contrast toggle to [ThemeCubit.setMode] so it
/// persists across sessions and applies to the whole app immediately.
///
/// Layout via [SetupStepScaffold] (step 2/4).
class DisplaySetupScreen extends StatefulWidget {
  const DisplaySetupScreen({super.key});

  @override
  State<DisplaySetupScreen> createState() => _DisplaySetupScreenState();
}

class _DisplaySetupScreenState extends State<DisplaySetupScreen> {
  // 68 = design default (slider at 68%), maps to a font size in [16, 32].
  double _textSizeSlider = 68.0;
  bool _highContrast = true; // design default: on

  /// Map slider 0-100 to a font size 16–32 dp for the live preview.
  double get _previewFontSize => 16 + (_textSizeSlider / 100) * 16;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    return SetupStepScaffold(
      step: 2,
      totalSteps: 4,
      ctaLabel: 'Continue',
      ctaSuffixIcon: Icons.arrow_forward,
      onCta: () => context.push(AppRoutes.setupVoice.path),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.space24),

          // ── Eyebrow ────────────────────────────────────
          Text(
            'DISPLAY',
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
              'Make text easy to read',
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
            'Drag until this sample feels comfortable.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ext?.ink2 ?? cs.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Preview card ───────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.space20),
            decoration: BoxDecoration(
              color: blueTint,
              borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PREVIEW',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Semantics(
                  liveRegion: true,
                  label: 'Preview text at current size',
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 120),
                    style: theme.textTheme.headlineMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: _previewFontSize,
                          height: 1.3,
                        ) ??
                        TextStyle(
                          fontSize: _previewFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                    child: const Text(
                      'Bus 12 arrives in 4 minutes at Jalan Merdeka.',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Text size slider ───────────────────────────
          SetupSliderBlock(
            label: 'Text size',
            value: _textSizeSlider,
            onChanged: (v) => setState(() => _textSizeSlider = v),
            leading: Text(
              'A',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            trailing: Text(
              'A',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 26,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── High contrast toggle ───────────────────────
          // TODO: wire `_highContrast` to ThemeCubit.setMode(
          //   _highContrast ? AppThemeMode.highContrast : AppThemeMode.light
          // ) once the setup flow persists preferences.
          SetupToggleTile(
            icon: Icons.contrast,
            title: 'High contrast',
            desc: 'Bolder text and stronger edges',
            value: _highContrast,
            onChanged: (v) => setState(() => _highContrast = v),
          ),

          const SizedBox(height: AppDimensions.space8),
        ],
      ),
    );
  }
}
