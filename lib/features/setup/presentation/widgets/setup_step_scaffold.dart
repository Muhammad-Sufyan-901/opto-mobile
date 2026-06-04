import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/widgets/buttons/app_button.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/widgets/setup_progress_bar.dart';

/// Shared scaffold for the Onboarding & Setup form screens (10–13).
///
/// Mirrors [AuthFormScaffold] in structure, but replaces the back-nav row with
/// a [SetupProgressBar] — matching the design's `.scr-pad` layout which shows
/// only the progress bar at the top (no explicit back button).
///
/// Layout (top to bottom, within [SafeArea]):
///   1. [SetupProgressBar] — pinned, horizontally padded.
///   2. [SingleChildScrollView] body — allows 300% text scaling to reflow.
///   3. Pinned [AppButton.primary] CTA with optional suffix icon.
class SetupStepScaffold extends StatelessWidget {
  const SetupStepScaffold({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.body,
    required this.ctaLabel,
    required this.onCta,
    this.ctaSuffixIcon,
    this.isCtaLoading = false,
  });

  /// Current 1-based step index.
  final int step;

  /// Total number of setup steps (4 in the current flow).
  final int totalSteps;

  /// Scrollable body content.
  final Widget body;

  /// CTA button label text.
  final String ctaLabel;

  /// Called when the CTA is pressed.
  final VoidCallback? onCta;

  /// Optional suffix icon for the CTA (e.g. [Icons.arrow_forward]).
  final IconData? ctaSuffixIcon;

  /// Shows a loading spinner inside the CTA while true.
  final bool isCtaLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Progress bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPadding,
                AppDimensions.space8,
                AppDimensions.screenPadding,
                0,
              ),
              child: SetupProgressBar(step: step, totalSteps: totalSteps),
            ),

            // ── Scrollable body ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: body,
              ),
            ),

            // ── Pinned CTA ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPadding,
                AppDimensions.space16,
                AppDimensions.screenPadding,
                AppDimensions.space24,
              ),
              child: AppButton.primary(
                text: ctaLabel,
                onPressed: onCta,
                isFullWidth: true,
                isLoading: isCtaLoading,
                suffixIcon: ctaSuffixIcon,
                height: AppDimensions.buttonHeight,
                radius: AppDimensions.radiusButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
