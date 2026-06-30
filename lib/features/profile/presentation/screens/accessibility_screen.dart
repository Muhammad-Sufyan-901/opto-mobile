import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_theme_mode.dart';
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';
import 'package:opto/features/profile/presentation/widgets/profile_listen_button.dart';
import 'package:opto/features/profile/presentation/widgets/profile_segmented.dart';
import 'package:opto/features/profile/presentation/widgets/profile_setting_row.dart';
import 'package:opto/features/profile/presentation/widgets/profile_switch.dart';

/// Screen P4 — Accessibility Preferences.
///
/// Wired to [AccessibilitySettingsCubit] — all toggles dispatch real
/// optimistic updates that persist to Supabase. The high-contrast and
/// text-size controls re-theme the whole app in real time.
class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Accessibility settings.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Center(
              child: ExcludeSemantics(
                child:
                    Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
              ),
            ),
          ),
        ),
        title: Text(
          'Accessibility',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Listen to these settings',
            child: GestureDetector(
              onTap: () => HapticPatterns.focusTick(),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                decoration: BoxDecoration(
                  color: ext?.blueTint ?? cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.volume_up_outlined,
                        size: 24, color: cs.secondary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AccessibilitySettingsCubit, AccessibilitySettingsEntity>(
          builder: (ctx, settings) {
            final cubit = ctx.read<AccessibilitySettingsCubit>();
            final bool isHighContrast =
                settings.theme == AppThemeMode.highContrast;

            // OS-level settings — read from MediaQuery; app cannot change these.
            final mq = MediaQuery.of(ctx);
            final bool talkBackOn = mq.accessibleNavigation;
            final bool boldText = mq.boldText;
            final bool reduceMotion = mq.disableAnimations;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                  18, 0, 18, AppDimensions.space32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ProfileListenButton(
                      summary: 'Accessibility settings. '
                          'Screen reader: ${talkBackOn ? "on" : "off"}. '
                          'Voice guidance: ${settings.spokenGuidanceEnabled ? "on" : "off"}. '
                          'Speech rate: ${_rateLabel(settings.speakingRate)}. '
                          'High contrast: ${isHighContrast ? "on" : "off"}. '
                          'Bold text: ${boldText ? "on" : "off"}. '
                          'Reduce motion: ${reduceMotion ? "on" : "off"}. '
                          'Sound effects: ${settings.soundEffectsEnabled ? "on" : "off"}. '
                          'Haptics: ${settings.hapticIntensity == HapticLevel.full ? "on" : "off"}.',
                      label: 'Listen to these settings read aloud',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Screen reader & speech ────────────────────────────
                  _SectionLabel(label: 'SCREEN READER & SPEECH', ink3: ink3),
                  const SizedBox(height: 12),

                  ProfileSettingCard(children: [
                    ProfileSettingRow(
                      icon: Icons.volume_up_outlined,
                      title: 'TalkBack / screen reader',
                      subtitle: talkBackOn
                          ? 'Screen reader is active'
                          : 'Change in phone Settings → Accessibility',
                      control: ProfileSwitch(
                        value: talkBackOn,
                        onChanged: (_) {}, // OS-owned — app cannot toggle
                        label: 'TalkBack',
                      ),
                    ),
                    ProfileSettingRow(
                      icon: Icons.speed_outlined,
                      title: 'Voice guidance',
                      subtitle: 'Spoken hints across the app',
                      isLast: true,
                      control: ProfileSwitch(
                        value: settings.spokenGuidanceEnabled,
                        onChanged: (v) {
                          cubit.updateSpokenGuidance(enabled: v);
                          announce(ctx,
                              'Voice guidance ${v ? "on" : "off"}.');
                        },
                        label: 'Voice guidance',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  _SectionFieldBlock(
                    icon: Icons.speed_outlined,
                    label: 'Speech rate',
                    child: ProfileSegmented(
                      options: const ['slow', 'normal', 'fast', 'fastest'],
                      displayLabels: const ['0.8×', '1×', '1.5×', '2×'],
                      selected: _rateOption(settings.speakingRate),
                      semanticSuffix: ' speed',
                      onSelected: (v) {
                        final double rate = _rateValue(v);
                        cubit.updateSpeakingRate(rate);
                        announce(ctx, 'Speech rate: ${_rateLabel(rate)}.');
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Display ────────────────────────────────────────────
                  _SectionLabel(label: 'DISPLAY', ink3: ink3),
                  const SizedBox(height: 12),

                  _SectionFieldBlock(
                    icon: Icons.format_size_outlined,
                    label: 'Text size',
                    note: 'Large is recommended for your low-vision profile',
                    child: ProfileSegmented(
                      options: const ['compact', 'default', 'large', 'larger'],
                      displayLabels: const ['A', 'A', 'A', 'A'],
                      displayFontSizes: const [14, 18, 23, 29],
                      selected: _scaleOption(settings.textScale),
                      semanticSuffix: ' text size',
                      onSelected: (v) {
                        final double scale = _scaleValue(v);
                        cubit.updateTextScale(scale);
                        announce(ctx, 'Text size: ${_scaleLabel(scale)}.');
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  ProfileSettingCard(children: [
                    ProfileSettingRow(
                      icon: Icons.contrast,
                      title: 'High contrast',
                      subtitle: 'Darker text, heavier borders',
                      control: ProfileSwitch(
                        value: isHighContrast,
                        onChanged: (v) {
                          cubit.updateTheme(
                            v ? AppThemeMode.highContrast : AppThemeMode.light,
                          );
                          announce(ctx,
                              'High contrast ${v ? "on" : "off"}.');
                        },
                        label: 'High contrast',
                      ),
                    ),
                    ProfileSettingRow(
                      icon: Icons.format_bold,
                      title: 'Bold text',
                      subtitle: 'Change in phone Settings → Accessibility',
                      control: ProfileSwitch(
                        value: boldText,
                        onChanged: (_) {}, // OS-owned — app cannot toggle
                        label: 'Bold text',
                      ),
                    ),
                    ProfileSettingRow(
                      icon: Icons.motion_photos_off_outlined,
                      title: 'Reduce motion',
                      subtitle: 'Change in phone Settings → Accessibility',
                      isLast: true,
                      control: ProfileSwitch(
                        value: reduceMotion,
                        onChanged: (_) {}, // OS-owned — app cannot toggle
                        label: 'Reduce motion',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── Feedback ────────────────────────────────────────────
                  _SectionLabel(label: 'FEEDBACK', ink3: ink3),
                  const SizedBox(height: 12),

                  ProfileSettingCard(children: [
                    ProfileSettingRow(
                      icon: Icons.vibration_outlined,
                      title: 'Haptics',
                      subtitle: 'Vibrate on key actions',
                      control: ProfileSwitch(
                        value: settings.hapticIntensity == HapticLevel.full,
                        onChanged: (v) {
                          cubit.updateHaptic(
                              v ? HapticLevel.full : HapticLevel.off);
                          announce(ctx,
                              'Haptics ${v ? "on" : "off"}.');
                        },
                        label: 'Haptics',
                      ),
                    ),
                    ProfileSettingRow(
                      icon: Icons.speaker_outlined,
                      title: 'Sound effects',
                      subtitle: 'In-app audio cues and confirmations',
                      isLast: true,
                      control: ProfileSwitch(
                        value: settings.soundEffectsEnabled,
                        onChanged: (v) {
                          cubit.updateSoundEffects(enabled: v);
                          announce(ctx,
                              'Sound effects ${v ? "on" : "off"}.');
                        },
                        label: 'Sound effects',
                      ),
                    ),
                  ]),

                  const SizedBox(height: 14),

                  // ── Live-preview tip banner ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: ext?.blueTint ?? cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExcludeSemantics(
                          child: Icon(Icons.palette_outlined,
                              size: 18, color: cs.secondary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Changes apply live',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.secondary,
                                  fontSize: 14.5,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Toggle settings above to re-theme the '
                                'whole app in real time.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: ext?.ink2 ?? cs.onSurfaceVariant,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Rate helpers ─────────────────────────────────────────────────────────

  String _rateOption(double rate) {
    if (rate <= 0.3) return 'slow';
    if (rate <= 0.5) return 'normal';
    if (rate <= 0.75) return 'fast';
    return 'fastest';
  }

  double _rateValue(String option) {
    return switch (option) {
      'slow' => 0.2,
      'normal' => 0.45,
      'fast' => 0.7,
      _ => 1.0,
    };
  }

  String _rateLabel(double rate) {
    if (rate <= 0.3) return '0.8× slow';
    if (rate <= 0.5) return '1× normal';
    if (rate <= 0.75) return '1.5× fast';
    return '2× fastest';
  }

  // ── Scale helpers ─────────────────────────────────────────────────────────

  String _scaleOption(double scale) {
    if (scale <= 0.95) return 'compact';
    if (scale <= 1.1) return 'default';
    if (scale <= 1.6) return 'large';
    return 'larger';
  }

  double _scaleValue(String option) {
    return switch (option) {
      'compact' => 0.9,
      'default' => 1.0,
      'large' => 1.5,
      _ => 2.0,
    };
  }

  String _scaleLabel(double scale) {
    if (scale <= 0.95) return 'Compact';
    if (scale <= 1.1) return 'Default';
    if (scale <= 1.6) return 'Large';
    return 'Larger';
  }
}

// ── Private helper widgets ────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.ink3});

  final String label;
  final Color ink3;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: ink3,
              fontSize: 13,
            ),
      ),
    );
  }
}

class _SectionFieldBlock extends StatelessWidget {
  const _SectionFieldBlock({
    required this.icon,
    required this.label,
    required this.child,
    this.note,
  });

  final IconData icon;
  final String label;
  final Widget child;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Row(
            children: [
              Icon(icon, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        child,
        if (note != null) ...[
          const SizedBox(height: 6),
          Text(
            note!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: ink3,
              fontSize: 12.5,
            ),
          ),
        ],
      ],
    );
  }
}
