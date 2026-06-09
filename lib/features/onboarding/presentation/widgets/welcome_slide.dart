import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/onboarding/data/models/welcome_slide_data.dart';
import 'package:opto/features/onboarding/presentation/widgets/welcome_illustration.dart';

/// Stateless content area for one Welcome intro slide.
///
/// Renders the illustration placeholder, eyebrow, title, and body paragraph.
/// Designed to be placed inside a [PageView] managed by [WelcomeScreen].
///
/// The illustration placeholder occupies a fixed 264dp height as per design.
/// Body text is in a [SingleChildScrollView] so it reflows under 300% text
/// scaling without overflowing (design_system §3 / §15.4).
class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({
    super.key,
    required this.data,
  });

  final WelcomeSlideData data;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color ink2 =
        theme.extension<AppExtendedCustomColors>()?.ink2 ??
            cs.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Illustration placeholder ───────────────────────
          WelcomeIllustration(label: data.illustrationLabel),

          // ── Body copy ──────────────────────────────────────
          const SizedBox(height: 28),

          // Wrap body copy in a scroll view so it reflows under large
          // text scales without layout overflow.
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Eyebrow — uppercase, letter-spaced (labelSmall)
                  Text(
                    data.eyebrow,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.primary,
                      letterSpacing: 1.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Title — displayMedium (30px bold)
                  Semantics(
                    header: true,
                    child: Text(
                      data.title,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Body — bodyLarge (18px regular)
                  Text(
                    data.body,
                    style: theme.textTheme.bodyLarge?.copyWith(color: ink2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
