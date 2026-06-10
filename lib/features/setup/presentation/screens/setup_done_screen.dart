import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/widgets/buttons/app_button.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';

/// Screen 14 — All set / setup complete.
///
/// Reads live values from [ProfileBloc] (vision profile) and
/// [AccessibilitySettingsCubit] (text scale, spoken guidance) to populate
/// the summary card.
class SetupDoneScreen extends StatefulWidget {
  const SetupDoneScreen({super.key});

  @override
  State<SetupDoneScreen> createState() => _SetupDoneScreenState();
}

class _SetupDoneScreenState extends State<SetupDoneScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, "All set. You're ready to use Opto.");
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    final settings = context.watch<AccessibilitySettingsCubit>().state;
    final profileState = context.watch<ProfileBloc>().state;

    final visionLabel = _visionLabel(profileState);
    final textSizeLabel = _textSizeLabel(settings.textScale);
    final voiceLabel = settings.spokenGuidanceEnabled ? 'On' : 'Off';
    final summarySemantics =
        'Setup summary. Vision: $visionLabel. Text size: $textSizeLabel. Voice: $voiceLabel.';

    return Scaffold(
      backgroundColor: cs.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Scrollable content ────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.space32),

                    // ── Check circle badge ──────────────────
                    ExcludeSemantics(
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space24),

                    // ── Title ─────────────────────────────────
                    Semantics(
                      header: true,
                      child: Text(
                        "You're all set",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space12),

                    // ── Subtitle ──────────────────────────────
                    Text(
                      'Opto is tuned to how you see and hear. '
                      "Everything's ready to go.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space24),

                    // ── Summary card ──────────────────────────
                    Semantics(
                      container: true,
                      label: summarySemantics,
                      child: ExcludeSemantics(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusRow,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.space20,
                          ),
                          child: Column(
                            children: [
                              _SummaryRow(label: 'Vision', value: visionLabel),
                              _SummaryRow(label: 'Text size', value: textSizeLabel),
                              _SummaryRow(
                                label: 'Voice',
                                value: voiceLabel,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space32),
                  ],
                ),
              ),
            ),

            // ── "Enter Opto" CTA ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPadding,
                AppDimensions.space16,
                AppDimensions.screenPadding,
                AppDimensions.space24,
              ),
              child: AppButton.primary(
                text: 'Enter Opto',
                isFullWidth: true,
                suffixIcon: Icons.arrow_forward,
                height: AppDimensions.buttonHeight,
                radius: AppDimensions.radiusButton,
                customStyle: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: cs.primary,
                ),
                onPressed: () => context.go(AppRoutes.home.path),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _visionLabel(ProfileState state) {
    if (state is! ProfileLoaded) return '—';
    return switch (state.profile.visionProfile) {
      VisionProfile.blindTotal => 'Blind',
      VisionProfile.lowVision => 'Low vision',
      VisionProfile.ocularProsthesis => 'Ocular prosthetic',
      VisionProfile.caregiver => 'Caregiver',
      VisionProfile.unspecified || null => 'Not specified',
    };
  }

  static String _textSizeLabel(double textScale) {
    if (textScale >= 2.5) return 'Extra large';
    if (textScale >= 1.5) return 'Large';
    return 'Normal';
  }
}

// ── Internal: single summary row ────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space16),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
