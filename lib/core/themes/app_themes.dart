import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_colors.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_typography.dart';

class AppThemes {
  // ☀️ LIGHT THEME
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppCustomTypography.textTheme,
      colorScheme: AppCustomColors.lightColorScheme,
      extensions: [AppCustomColors.lightExtendedCustomColors],
    );
  }

  // 🌙 DARK THEME
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppCustomTypography.textTheme,
      colorScheme: AppCustomColors.darkColorScheme,
      extensions: [AppCustomColors.darkExtendedCustomColors],
    );
  }
}
