import 'package:flutter/material.dart';
import 'package:ids_elder_rehab_app/core/constants/app_colors.dart';

class AppExtendedCustomColors extends ThemeExtension<AppExtendedCustomColors> {
  final Color? success;
  final Color? warning;
  final Color? error;
  final Color? info;

  const AppExtendedCustomColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  @override
  AppExtendedCustomColors copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) {
    return AppExtendedCustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
    );
  }

  @override
  AppExtendedCustomColors lerp(
    ThemeExtension<AppExtendedCustomColors>? other,
    double t,
  ) {
    if (other is! AppExtendedCustomColors) return this;
    return AppExtendedCustomColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      error: Color.lerp(error, other.error, t),
      info: Color.lerp(info, other.info, t),
    );
  }
}

class AppCustomColors {
  // Light Mode Color Scheme
  static ColorScheme get lightColorScheme {
    return ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      tertiary: AppColors.lightTertiary,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightText,
    );
  }

  // Dark Mode Color Scheme
  static ColorScheme get darkColorScheme {
    return ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      tertiary: AppColors.darkTertiary,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkText,
    );
  }

  // Light Mode Extended Custom Colors
  static AppExtendedCustomColors get lightExtendedCustomColors {
    return AppExtendedCustomColors(
      success: AppColors.lightSuccess,
      warning: AppColors.lightWarning,
      error: AppColors.lightError,
      info: AppColors.lightInfo,
    );
  }

  // Dark Mode Extended Custom Colors
  static AppExtendedCustomColors get darkExtendedCustomColors {
    return AppExtendedCustomColors(
      success: AppColors.darkSuccess,
      warning: AppColors.darkWarning,
      error: AppColors.darkError,
      info: AppColors.darkInfo,
    );
  }
}
