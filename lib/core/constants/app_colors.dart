import 'package:flutter/material.dart';

/// Canonical Opto color tokens.
///
/// Sourced from `.agents/app/design_system.md` §2 (OKLCH → hex, WCAG AA+).
/// Light theme is the default; Dark and High-Contrast are user-selectable.
abstract class AppColors {
  // =========================================================================
  // SHARED UTILITIES
  // =========================================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // =========================================================================
  // ☀️  LIGHT THEME (canonical — blue-on-white)
  // =========================================================================

  // Primary blue — oklch(0.53 0.16 256) → #1E6AC5  (5.35:1 on white ✓ AA)
  static const Color lightPrimary = Color(0xFF1E6AC5);

  // Pressed / hover variant — oklch(0.46 0.15 256) → #0B56A9
  static const Color lightBlueStrong = Color(0xFF0B56A9);
  static const Color lightSecondary = Color(0xFF0B56A9); // ColorScheme.secondary alias

  // Selected card / icon-chip background — oklch(0.962 0.028 256) → #EBF3FF
  static const Color lightBlueTint = Color(0xFFEBF3FF);

  // Tertiary role (for M3 ColorScheme)
  static const Color lightTertiary = Color(0xFF0B56A9);

  // Surfaces
  static const Color lightBackground = Color(0xFFFFFFFF); // --bg: pure white
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFF5F7FA);

  // Text — oklch(0.28 0.03 262) → #212938  (14.6:1 on white ✓ AAA)
  static const Color lightText = Color(0xFF212938);

  // Secondary text — oklch(0.47 0.022 262) → #545B68  (6.8:1 on white ✓ AA)
  static const Color lightInk2 = Color(0xFF545B68);

  // Hint / placeholder — oklch(0.565 0.016 262) → #717680  (4.56:1 ✓ AA-corrected)
  static const Color lightInk3 = Color(0xFF717680);

  // Interactive component borders — oklch(0.665 0.02 262) → #8D94A0  (3.05:1 ✓ AA-corrected)
  static const Color lightLine = Color(0xFF8D94A0);

  // Decorative hairlines only (non-functional) — #D9DEE7
  static const Color lightDivider = Color(0xFFD9DEE7);

  // Semantic: success / healthy — oklch(0.60 0.13 152) → #1F8A5B
  static const Color lightSuccess = Color(0xFF1F8A5B);
  static const Color lightGreenTint = Color(0xFFE6F6EE);

  // Semantic: danger / SOS / error — oklch(0.55 0.17 27) → #C13C36  (5.28:1 ✓ AA-corrected)
  static const Color lightError = Color(0xFFC13C36);
  static const Color lightDangerTint = Color(0xFFFDECEC);

  // Semantic: warning
  static const Color lightWarning = Color(0xFFD97706);
  static const Color lightWarningTint = Color(0xFFFEF3CD);

  // Semantic: info
  static const Color lightInfo = Color(0xFF2563EB);
  static const Color lightInfoTint = Color(0xFFEFF6FF);

  // On-semantic (text/icon on coloured surfaces)
  static const Color lightOnPrimary = white;
  static const Color lightOnSuccess = white;
  static const Color lightOnError = white;
  static const Color lightOnWarning = white;
  static const Color lightOnInfo = white;

  // =========================================================================
  // 🌙  DARK THEME
  // =========================================================================

  // Primary — lightness-raised to ≥4.5:1 on #121212 (~6.9:1)
  static const Color darkPrimary = Color(0xFF5B9FE0);
  static const Color darkBlueStrong = Color(0xFF4A8ED0);
  static const Color darkSecondary = Color(0xFF4A8ED0);
  static const Color darkTertiary = Color(0xFF3A7DC0);
  static const Color darkBlueTint = Color(0xFF1C2B3A); // selected chip bg on dark

  // Surfaces
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkSurfaceContainer = Color(0xFF1E2130);

  // Text
  static const Color darkText = Color(0xFFE8ECF4);
  static const Color darkInk2 = Color(0xFFB8BDC8);
  static const Color darkInk3 = Color(0xFF8D94A0);

  // Borders
  static const Color darkLine = Color(0xFF545B68);
  static const Color darkDivider = Color(0xFF2E3441);

  // Semantic
  static const Color darkSuccess = Color(0xFF4CCA8C);
  static const Color darkGreenTint = Color(0xFF12261E);
  static const Color darkError = Color(0xFFE87070);
  static const Color darkDangerTint = Color(0xFF2A1515);
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkWarningTint = Color(0xFF2A2010);
  static const Color darkInfo = Color(0xFF5BA7E8);
  static const Color darkInfoTint = Color(0xFF0F1E30);

  // On-semantic
  static const Color darkOnPrimary = darkBackground;
  static const Color darkOnSuccess = darkBackground;
  static const Color darkOnError = darkBackground;
  static const Color darkOnWarning = darkBackground;
  static const Color darkOnInfo = darkBackground;

  // =========================================================================
  // ⬛  HIGH-CONTRAST THEME  (≥7:1 everywhere — WCAG AAA)
  // =========================================================================

  // Primary — #0044AA (12.9:1 on white, white on it also 12.9:1 ✓ AAA)
  static const Color hcPrimary = Color(0xFF0044AA);
  static const Color hcBlueTint = Color(0xFFD0E4FF);

  // Surfaces
  static const Color hcBackground = white;
  static const Color hcSurface = white;
  static const Color hcSurfaceContainer = Color(0xFFF5F5F5);

  // Text — pure black (21:1 on white ✓ AAA)
  static const Color hcText = black;
  static const Color hcInk2 = Color(0xFF1A1A1A);
  static const Color hcInk3 = Color(0xFF333333);

  // Borders — black for maximum visibility
  static const Color hcLine = black;
  static const Color hcDivider = Color(0xFF404040);

  // Semantic
  static const Color hcSuccess = Color(0xFF005C35); // >7:1 on white
  static const Color hcGreenTint = Color(0xFFC8EDD9);
  static const Color hcError = Color(0xFFA00000); // >7:1 on white
  static const Color hcDangerTint = Color(0xFFFFD0D0);
  static const Color hcWarning = Color(0xFF7A4000);
  static const Color hcWarningTint = Color(0xFFFFEBCC);
  static const Color hcInfo = Color(0xFF0044AA);
  static const Color hcInfoTint = Color(0xFFD0E4FF);

  // On-semantic
  static const Color hcOnPrimary = white;
  static const Color hcOnSuccess = white;
  static const Color hcOnError = white;
  static const Color hcOnWarning = white;
  static const Color hcOnInfo = white;
}
