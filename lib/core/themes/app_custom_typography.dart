import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_typography.dart';

/// Maps [AppTypography] styles to a Material [TextTheme].
///
/// Used by [AppThemes] when constructing [ThemeData]. All roles are mapped so
/// downstream widgets can use `Theme.of(context).textTheme.*` directly.
class AppCustomTypography {
  static TextTheme get textTheme => TextTheme(
    // Display — splash / celebration / auth titles
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.displayMedium,
    displaySmall: AppTypography.displaySmall,

    // Headline — screen / section titles (H1–H2)
    headlineLarge: AppTypography.headlineLarge,
    headlineMedium: AppTypography.headlineMedium,
    headlineSmall: AppTypography.headlineSmall,

    // Title — card titles, AppBar, list item headers
    titleLarge: AppTypography.titleLarge,
    titleMedium: AppTypography.titleMedium,
    titleSmall: AppTypography.titleSmall,

    // Body — reading text
    bodyLarge: AppTypography.bodyLarge,
    bodyMedium: AppTypography.bodyMedium,
    bodySmall: AppTypography.bodySmall,

    // Label — buttons, tags, eyebrow (labelSmall)
    labelLarge: AppTypography.labelLarge,
    labelMedium: AppTypography.labelMedium,
    labelSmall: AppTypography.labelSmall, // eyebrow style (letter-spaced)
  );
}
