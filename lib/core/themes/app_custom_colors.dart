import 'package:flutter/material.dart';
import 'package:ids_elder_rehab_app/core/constants/app_colors.dart';

// =============================================================================
// EXTENDED COLOR TOKENS
// =============================================================================

/// Opto-specific semantic tokens that are not part of Material's [ColorScheme].
///
/// Access via [Theme.of(context).extension<AppExtendedCustomColors>()].
/// All fields nullable so lerp() works during theme animations.
class AppExtendedCustomColors extends ThemeExtension<AppExtendedCustomColors> {
  // Standard semantic (keep backward-compatible names)
  final Color? success;
  final Color? warning;
  final Color? error;
  final Color? info;
  final Color? onSuccess;
  final Color? onWarning;
  final Color? onError;
  final Color? onInfo;

  // Opto-specific tokens not in ColorScheme
  final Color? blueTint; // selected card / icon-chip bg
  final Color? ink2; // secondary text
  final Color? ink3; // hint / placeholder text
  final Color? line; // interactive component borders
  final Color? divider; // decorative hairlines only
  final Color? green; // healthy / success status (alias for success)
  final Color? greenTint; // success chip background
  final Color? dangerTint; // SOS / error surface background
  final Color? focusRing; // visible focus outline color
  final Color? warningTint; // warning chip background
  final Color? infoTint; // info chip background

  const AppExtendedCustomColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.onSuccess,
    required this.onWarning,
    required this.onError,
    required this.onInfo,
    required this.blueTint,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.divider,
    required this.green,
    required this.greenTint,
    required this.dangerTint,
    required this.focusRing,
    required this.warningTint,
    required this.infoTint,
  });

  @override
  AppExtendedCustomColors copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? onSuccess,
    Color? onWarning,
    Color? onError,
    Color? onInfo,
    Color? blueTint,
    Color? ink2,
    Color? ink3,
    Color? line,
    Color? divider,
    Color? green,
    Color? greenTint,
    Color? dangerTint,
    Color? focusRing,
    Color? warningTint,
    Color? infoTint,
  }) {
    return AppExtendedCustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      onSuccess: onSuccess ?? this.onSuccess,
      onWarning: onWarning ?? this.onWarning,
      onError: onError ?? this.onError,
      onInfo: onInfo ?? this.onInfo,
      blueTint: blueTint ?? this.blueTint,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      line: line ?? this.line,
      divider: divider ?? this.divider,
      green: green ?? this.green,
      greenTint: greenTint ?? this.greenTint,
      dangerTint: dangerTint ?? this.dangerTint,
      focusRing: focusRing ?? this.focusRing,
      warningTint: warningTint ?? this.warningTint,
      infoTint: infoTint ?? this.infoTint,
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
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      onError: Color.lerp(onError, other.onError, t),
      onInfo: Color.lerp(onInfo, other.onInfo, t),
      blueTint: Color.lerp(blueTint, other.blueTint, t),
      ink2: Color.lerp(ink2, other.ink2, t),
      ink3: Color.lerp(ink3, other.ink3, t),
      line: Color.lerp(line, other.line, t),
      divider: Color.lerp(divider, other.divider, t),
      green: Color.lerp(green, other.green, t),
      greenTint: Color.lerp(greenTint, other.greenTint, t),
      dangerTint: Color.lerp(dangerTint, other.dangerTint, t),
      focusRing: Color.lerp(focusRing, other.focusRing, t),
      warningTint: Color.lerp(warningTint, other.warningTint, t),
      infoTint: Color.lerp(infoTint, other.infoTint, t),
    );
  }
}

// =============================================================================
// COLOR SCHEME FACTORY
// =============================================================================

class AppCustomColors {
  // ---------------------------------------------------------------------------
  // ☀️  LIGHT
  // ---------------------------------------------------------------------------

  static ColorScheme get lightColorScheme {
    return ColorScheme.light(
      // Primary brand blue
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightBlueTint,
      onPrimaryContainer: AppColors.lightBlueStrong,

      // Secondary (pressed/hover blue)
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnPrimary,
      secondaryContainer: AppColors.lightBlueTint,
      onSecondaryContainer: AppColors.lightPrimary,

      // Tertiary (for M3 component accents)
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnPrimary,
      tertiaryContainer: AppColors.lightBlueTint,
      onTertiaryContainer: AppColors.lightBlueStrong,

      // Surfaces
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightText,
      onSurfaceVariant: AppColors.lightInk2,
      surfaceContainerHighest: AppColors.lightBlueTint,
      surfaceContainer: AppColors.lightSurfaceContainer,

      // Error
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      errorContainer: AppColors.lightDangerTint,
      onErrorContainer: AppColors.lightError,

      // Borders
      outline: AppColors.lightLine,
      outlineVariant: AppColors.lightDivider,

      // Inverse / shadow / scrim
      inverseSurface: AppColors.lightText,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.lightBlueTint,
      shadow: AppColors.black,
      scrim: AppColors.black,
      surfaceTint: AppColors.lightPrimary,
    );
  }

  // ---------------------------------------------------------------------------
  // 🌙  DARK
  // ---------------------------------------------------------------------------

  static ColorScheme get darkColorScheme {
    return ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkBackground,
      primaryContainer: AppColors.darkBlueTint,
      onPrimaryContainer: AppColors.darkPrimary,

      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkBackground,
      secondaryContainer: AppColors.darkBlueTint,
      onSecondaryContainer: AppColors.darkPrimary,

      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkBackground,
      tertiaryContainer: AppColors.darkBlueTint,
      onTertiaryContainer: AppColors.darkPrimary,

      surface: AppColors.darkSurface,
      onSurface: AppColors.darkText,
      onSurfaceVariant: AppColors.darkInk2,
      surfaceContainerHighest: AppColors.darkBlueTint,
      surfaceContainer: AppColors.darkSurfaceContainer,

      error: AppColors.darkError,
      onError: AppColors.darkBackground,
      errorContainer: AppColors.darkDangerTint,
      onErrorContainer: AppColors.darkError,

      outline: AppColors.darkLine,
      outlineVariant: AppColors.darkDivider,

      inverseSurface: AppColors.darkText,
      onInverseSurface: AppColors.darkBackground,
      inversePrimary: AppColors.darkBlueTint,
      shadow: AppColors.black,
      scrim: AppColors.black,
      surfaceTint: AppColors.darkPrimary,
    );
  }

  // ---------------------------------------------------------------------------
  // ⬛  HIGH-CONTRAST  (light surface, ≥7:1 everywhere)
  // ---------------------------------------------------------------------------

  static ColorScheme get highContrastColorScheme {
    return ColorScheme.light(
      primary: AppColors.hcPrimary,
      onPrimary: AppColors.hcOnPrimary,
      primaryContainer: AppColors.hcBlueTint,
      onPrimaryContainer: AppColors.hcText,

      secondary: AppColors.hcPrimary,
      onSecondary: AppColors.hcOnPrimary,
      secondaryContainer: AppColors.hcBlueTint,
      onSecondaryContainer: AppColors.hcText,

      tertiary: AppColors.hcPrimary,
      onTertiary: AppColors.hcOnPrimary,
      tertiaryContainer: AppColors.hcBlueTint,
      onTertiaryContainer: AppColors.hcText,

      surface: AppColors.hcSurface,
      onSurface: AppColors.hcText,
      onSurfaceVariant: AppColors.hcInk2,
      surfaceContainerHighest: AppColors.hcBlueTint,
      surfaceContainer: AppColors.hcSurfaceContainer,

      error: AppColors.hcError,
      onError: AppColors.hcOnError,
      errorContainer: AppColors.hcDangerTint,
      onErrorContainer: AppColors.hcError,

      // Black borders for maximum contrast
      outline: AppColors.hcLine,
      outlineVariant: AppColors.hcDivider,

      inverseSurface: AppColors.hcText,
      onInverseSurface: AppColors.hcSurface,
      inversePrimary: AppColors.hcBlueTint,
      shadow: AppColors.black,
      scrim: AppColors.black,
      surfaceTint: AppColors.hcPrimary,
    );
  }

  // ---------------------------------------------------------------------------
  // EXTENDED COLOR EXTENSIONS
  // ---------------------------------------------------------------------------

  static AppExtendedCustomColors get lightExtendedCustomColors {
    return const AppExtendedCustomColors(
      success: AppColors.lightSuccess,
      warning: AppColors.lightWarning,
      error: AppColors.lightError,
      info: AppColors.lightInfo,
      onSuccess: AppColors.lightOnSuccess,
      onWarning: AppColors.lightOnWarning,
      onError: AppColors.lightOnError,
      onInfo: AppColors.lightOnInfo,
      blueTint: AppColors.lightBlueTint,
      ink2: AppColors.lightInk2,
      ink3: AppColors.lightInk3,
      line: AppColors.lightLine,
      divider: AppColors.lightDivider,
      green: AppColors.lightSuccess,
      greenTint: AppColors.lightGreenTint,
      dangerTint: AppColors.lightDangerTint,
      focusRing: AppColors.lightPrimary,
      warningTint: AppColors.lightWarningTint,
      infoTint: AppColors.lightInfoTint,
    );
  }

  static AppExtendedCustomColors get darkExtendedCustomColors {
    return const AppExtendedCustomColors(
      success: AppColors.darkSuccess,
      warning: AppColors.darkWarning,
      error: AppColors.darkError,
      info: AppColors.darkInfo,
      onSuccess: AppColors.darkOnSuccess,
      onWarning: AppColors.darkOnWarning,
      onError: AppColors.darkOnError,
      onInfo: AppColors.darkOnInfo,
      blueTint: AppColors.darkBlueTint,
      ink2: AppColors.darkInk2,
      ink3: AppColors.darkInk3,
      line: AppColors.darkLine,
      divider: AppColors.darkDivider,
      green: AppColors.darkSuccess,
      greenTint: AppColors.darkGreenTint,
      dangerTint: AppColors.darkDangerTint,
      focusRing: AppColors.darkPrimary,
      warningTint: AppColors.darkWarningTint,
      infoTint: AppColors.darkInfoTint,
    );
  }

  static AppExtendedCustomColors get highContrastExtendedCustomColors {
    return const AppExtendedCustomColors(
      success: AppColors.hcSuccess,
      warning: AppColors.hcWarning,
      error: AppColors.hcError,
      info: AppColors.hcInfo,
      onSuccess: AppColors.hcOnSuccess,
      onWarning: AppColors.hcOnWarning,
      onError: AppColors.hcOnError,
      onInfo: AppColors.hcOnInfo,
      blueTint: AppColors.hcBlueTint,
      ink2: AppColors.hcInk2,
      ink3: AppColors.hcInk3,
      line: AppColors.hcLine,
      divider: AppColors.hcDivider,
      green: AppColors.hcSuccess,
      greenTint: AppColors.hcGreenTint,
      dangerTint: AppColors.hcDangerTint,
      focusRing: AppColors.hcPrimary,
      warningTint: AppColors.hcWarningTint,
      infoTint: AppColors.hcInfoTint,
    );
  }
}
