import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';
import 'package:opto/features/setup/presentation/widgets/setup_slider_block.dart';
import 'package:opto/features/setup/presentation/widgets/setup_step_scaffold.dart';
import 'package:opto/features/setup/presentation/widgets/setup_toggle_tile.dart';

/// Screen 12 — Voice & sound setup.
///
/// Wired to [AccessibilitySettingsCubit]: spoken guidance → [spokenGuidanceEnabled],
/// voice commands → [voiceEnabled], speaking speed → [speakingRate] (0.0–1.0).
///
/// Layout via [SetupStepScaffold] (step 3/4).
class VoiceSetupScreen extends StatefulWidget {
  const VoiceSetupScreen({super.key});

  @override
  State<VoiceSetupScreen> createState() => _VoiceSetupScreenState();
}

class _VoiceSetupScreenState extends State<VoiceSetupScreen> {
  bool _spokenGuidance = true;
  bool _voiceCommands = true;
  double _speakingSpeed = 45.0; // slider 0–100; maps to speakingRate 0.0–1.0

  @override
  void initState() {
    super.initState();
    final settings = context.read<AccessibilitySettingsCubit>().state;
    _spokenGuidance = settings.spokenGuidanceEnabled;
    _voiceCommands = settings.voiceEnabled;
    // Map speakingRate 0.0–1.0 → slider 0–100
    _speakingSpeed = (settings.speakingRate * 100).clamp(0.0, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final AppExtendedCustomColors? ext =
        theme.extension<AppExtendedCustomColors>();

    return SetupStepScaffold(
      step: 3,
      totalSteps: 4,
      ctaLabel: 'Continue',
      ctaSuffixIcon: Icons.arrow_forward,
      onCta: () => context.push(AppRoutes.setupPermissions.path),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.space24),

          // ── Eyebrow ────────────────────────────────────
          Text(
            'VOICE & SOUND',
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
              'How should Opto speak?',
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
            'Spoken guidance works alongside TalkBack.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ext?.ink2 ?? cs.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Spoken guidance toggle ─────────────────────
          SetupToggleTile(
            icon: Icons.volume_up_outlined,
            title: 'Spoken guidance',
            desc: 'Read screens and actions aloud',
            value: _spokenGuidance,
            onChanged: (v) {
              setState(() => _spokenGuidance = v);
              context
                  .read<AccessibilitySettingsCubit>()
                  .updateSpokenGuidance(enabled: v);
            },
          ),

          const SizedBox(height: AppDimensions.space12),

          // ── Voice commands toggle ──────────────────────
          SetupToggleTile(
            icon: Icons.mic_none,
            title: 'Voice commands',
            desc: 'Say "Hey Opto" to navigate hands-free',
            value: _voiceCommands,
            onChanged: (v) {
              setState(() => _voiceCommands = v);
              context.read<AccessibilitySettingsCubit>().updateVoice(enabled: v);
            },
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Speaking speed slider ──────────────────────
          SetupSliderBlock(
            label: 'Speaking speed',
            value: _speakingSpeed,
            onChanged: (v) {
              setState(() => _speakingSpeed = v);
              // Map slider 0–100 → speakingRate 0.0–1.0
              context
                  .read<AccessibilitySettingsCubit>()
                  .updateSpeakingRate(v / 100.0);
            },
            leading: Text(
              'Slow',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: ext?.ink2 ?? cs.onSurfaceVariant,
              ),
            ),
            trailing: Text(
              'Fast',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: ext?.ink2 ?? cs.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space8),
        ],
      ),
    );
  }
}
