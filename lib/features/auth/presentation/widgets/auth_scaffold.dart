import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/widgets/buttons/app_button.dart';

/// Shared scaffold for auth form screens (Email, Phone, OTP, Caregiver).
///
/// Provides:
///   - White [Scaffold] + [SafeArea]
///   - Back-only top nav (48dp × 48dp icon button, `context.pop()`)
///   - [SingleChildScrollView] body so content reflows under 300% text scaling
///   - Pinned bottom CTA — [AppButton.primary] with optional suffix icon
///
/// The [body] is padded horizontally with [AppDimensions.screenPadding].
/// The CTA occupies the bottom inset (pin position) and is not part of [body].
class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({
    super.key,
    required this.body,
    required this.ctaLabel,
    required this.onCta,
    this.ctaSuffixIcon,
    this.isCtaLoading = false,
  });

  /// Scrollable body content — rendered inside a padded [SingleChildScrollView].
  final Widget body;

  /// CTA button label text.
  final String ctaLabel;

  /// Called when the CTA is pressed.
  final VoidCallback? onCta;

  /// Optional suffix icon for the CTA (e.g. [Icons.arrow_forward],
  /// [Icons.check]).
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
            // ── Back nav ─────────────────────────────────
            SizedBox(
              height: AppDimensions.minTapTarget + 6, // ~54dp — matches design
              child: Padding(
                padding: const EdgeInsets.only(left: AppDimensions.space8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Semantics(
                    button: true,
                    label: 'Go back',
                    child: SizedBox(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).maybePop(),
                        padding: EdgeInsets.zero,
                        tooltip: 'Back',
                      ),
                    ),
                  ),
                ),
              ),
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
