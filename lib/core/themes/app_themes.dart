import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_typography.dart';

/// Opto [ThemeData] factory.
///
/// Three themes follow `.agents/app/design_system.md` §2–§5:
/// - [lightTheme]        — default blue-on-white (canonical palette)
/// - [darkTheme]         — near-black surfaces, contrast-raised blue
/// - [highContrastTheme] — ≥7:1 everywhere (WCAG AAA), thicker borders
///
/// All themes share the same [AppCustomTypography.textTheme] and
/// [AppDimensions]-driven component sizes. Component themes are set globally
/// so individual widgets only need to deviate from the theme when necessary.
class AppThemes {
  // =========================================================================
  // PUBLIC THEME GETTERS
  // =========================================================================

  /// Default light theme — blue on white.
  static ThemeData get lightTheme => _buildTheme(
    colorScheme: AppCustomColors.lightColorScheme,
    extensions: [AppCustomColors.lightExtendedCustomColors],
  );

  /// Dark theme — near-black surfaces.
  static ThemeData get darkTheme => _buildTheme(
    colorScheme: AppCustomColors.darkColorScheme,
    extensions: [AppCustomColors.darkExtendedCustomColors],
    isDark: true,
  );

  /// High-Contrast theme — ≥7:1, thicker borders, WCAG AAA.
  static ThemeData get highContrastTheme => _buildTheme(
    colorScheme: AppCustomColors.highContrastColorScheme,
    extensions: [AppCustomColors.highContrastExtendedCustomColors],
    isHighContrast: true,
  );

  // =========================================================================
  // PRIVATE BUILDER
  // =========================================================================

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required List<ThemeExtension<dynamic>> extensions,
    bool isDark = false,
    bool isHighContrast = false,
  }) {
    // Component border widths — thicker for high-contrast.
    const enabledWidth = 1.5;
    final focusedWidth = isHighContrast ? 3.0 : 2.0;
    final borderWidth = isHighContrast ? 2.5 : enabledWidth;

    // Cool-tinted shadow — rgba(20, 40, 80, .20); omitted for high-contrast.
    final shadowColor = isHighContrast
        ? Colors.transparent
        : const Color(0x33142850); // 0x33 ≈ 0.20 opacity

    final textTheme = AppCustomTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      extensions: extensions,

      // ------------------------------------------------------------------
      // BUTTON THEMES
      // ------------------------------------------------------------------

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          side: isHighContrast
              ? BorderSide(color: colorScheme.primary, width: borderWidth)
              : null,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          elevation: isHighContrast ? 0 : 2,
          shadowColor: shadowColor,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          side: BorderSide(color: colorScheme.outline, width: borderWidth),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize:
              const Size(AppDimensions.minTapTarget, AppDimensions.minTapTarget),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ------------------------------------------------------------------
      // INPUT DECORATION (OptoField)
      // ------------------------------------------------------------------

      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: focusedWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: borderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: focusedWidth,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space16,
        ),
        constraints: const BoxConstraints(minHeight: AppDimensions.inputHeight),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),

      // ------------------------------------------------------------------
      // CARD
      // ------------------------------------------------------------------

      cardTheme: CardThemeData(
        elevation: isHighContrast ? 0 : 1,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          side: isHighContrast
              ? BorderSide(color: colorScheme.outline, width: 1.5)
              : BorderSide.none,
        ),
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      ),

      // ------------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------------

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: isHighContrast ? 0 : 1,
        shadowColor: shadowColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppDimensions.iconLg,
        ),
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        toolbarHeight: kToolbarHeight,
      ),

      // ------------------------------------------------------------------
      // NAVIGATION BAR  (Material 3 bottom nav)
      // ------------------------------------------------------------------

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: isHighContrast ? 0 : 3,
        shadowColor: shadowColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.primary,
              size: AppDimensions.iconLg,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: AppDimensions.iconLg,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),

      // ------------------------------------------------------------------
      // BOTTOM NAVIGATION BAR  (legacy widget fallback)
      // ------------------------------------------------------------------

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: textTheme.labelMedium,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: isHighContrast ? 0 : 3,
      ),

      // ------------------------------------------------------------------
      // SWITCH  (Toggle: off = line track, on = blue track)
      // ------------------------------------------------------------------

      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.surface;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colorScheme.outline;
        }),
      ),

      // ------------------------------------------------------------------
      // DIVIDER
      // ------------------------------------------------------------------

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: isHighContrast ? 1.5 : 1.0,
        space: 1.0,
      ),

      // ------------------------------------------------------------------
      // CHIP  (relationship / topic filters — ≥44dp)
      // ------------------------------------------------------------------

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
          side: BorderSide(color: colorScheme.outline, width: borderWidth),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space8,
        ),
        labelStyle: textTheme.labelMedium,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surface,
        side: BorderSide(color: colorScheme.outline, width: isHighContrast ? 2.0 : 1.0),
      ),

      // ------------------------------------------------------------------
      // SNACK BAR
      // ------------------------------------------------------------------

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
        backgroundColor: isDark ? colorScheme.surface : colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? colorScheme.onSurface : colorScheme.onInverseSurface,
        ),
      ),

      // ------------------------------------------------------------------
      // FOCUS COLOR
      // ------------------------------------------------------------------

      focusColor: colorScheme.primary.withValues(alpha: 0.16),
    );
  }
}
