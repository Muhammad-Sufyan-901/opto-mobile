import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/widgets/buttons/app_button.dart';

/// Screen 14 — All set / setup complete.
///
/// Spec: `ScreenDone` / `.scr-done` / `.done-check` / `.done-summary`
/// in `Opto Onboarding.html`.
///
/// Full-bleed primary-blue background. Content:
///   - Large check-circle badge.
///   - Congratulatory title + subtitle.
///   - Translucent summary card listing the chosen Vision, Text size, and
///     Voice settings (hardcoded to the design's defaults for now — wire to
///     the setup state once a SetupCubit is added).
///   - "Enter Opto" white-on-blue CTA → navigates to the home dashboard.
///
/// Accessibility: the page announces itself on mount; the summary card is
/// read out as a single semantic group.
class SetupDoneScreen extends StatefulWidget {
  const SetupDoneScreen({super.key});

  @override
  State<SetupDoneScreen> createState() => _SetupDoneScreenState();
}

class _SetupDoneScreenState extends State<SetupDoneScreen> {
  @override
  void initState() {
    super.initState();
    // Announce screen to screen readers on arrival.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SemanticsService.sendAnnouncement(
        View.of(context),
        'All set. You\'re ready to use Opto.',
        TextDirection.ltr,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

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
                        child: Center(
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
                        "You're all set, Sari",
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
                      label: 'Setup summary. Vision: Low vision. Text size: Large. Voice: On.',
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
                              _SummaryRow(label: 'Vision', value: 'Low vision'),
                              _SummaryRow(label: 'Text size', value: 'Large'),
                              _SummaryRow(
                                label: 'Voice',
                                value: 'On',
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
            // White background / primary foreground = `.opt-btn-onblue`.
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
                // Override: white bg / primary fg to match .opt-btn-onblue.
                customStyle: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: cs.primary,
                ),
                onPressed: () {
                  // Navigate to the current home (lansia dashboard is the
                  // only built landing; replace with the Opto home once
                  // the home/dashboard module is complete — see A-3 in
                  // system_architecture.md).
                  context.go(AppRoutes.lansiaDashboard.path);
                },
              ),
            ),
          ],
        ),
      ),
    );
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
