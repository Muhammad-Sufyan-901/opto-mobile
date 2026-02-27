import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_typography.dart';

class AppCustomTypography {
  static TextTheme get textTheme => TextTheme(
    // Display (For large point numbers, levels, or hours)
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.displayMedium,
    displaySmall: AppTypography.displaySmall,

    // Headline (For Screens Titles)
    headlineLarge: AppTypography.headlineLarge,
    headlineMedium: AppTypography.headlineMedium,
    headlineSmall: AppTypography.headlineSmall,

    // Title (For Card Titles / AppBar)
    titleLarge: AppTypography.titleLarge,
    titleMedium: AppTypography.titleMedium,
    titleSmall: AppTypography.titleSmall,

    // Body (For long reading text / instructions)
    bodyLarge: AppTypography.bodyLarge,
    bodyMedium: AppTypography.bodyMedium,
    bodySmall: AppTypography.bodySmall,

    // Label (For Buttons and Tags)
    labelLarge: AppTypography.labelLarge,
    labelMedium: AppTypography.labelMedium,
    labelSmall: AppTypography.labelSmall,
  );
}
