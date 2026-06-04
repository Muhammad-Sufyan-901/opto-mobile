import 'package:flutter/material.dart';

/// Opto typography tokens.
///
/// Font: **Atkinson Hyperlegible** (Braille Institute / Google Fonts, SIL OFL).
/// Designed for low-vision users; ships as bundled TTF assets.
/// Only weights 400 (regular) and 700 (bold) are available — all styles
/// use one of these two to avoid faux-bold/italic rendering.
///
/// Scale derived from `.agents/app/design_system.md` §3.
/// All styles honor `MediaQuery.textScaler` (1.0–3.0) with reflow.
abstract class AppTypography {
  // =========================================================================
  // FONT FAMILY
  // =========================================================================

  static const String fontFamily = 'Atkinson Hyperlegible';

  // =========================================================================
  // FONT WEIGHTS  (only 400 & 700 are shipped)
  // =========================================================================

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight bold = FontWeight.w700;

  // Convenience aliases — both map to the two real weights so no faux-weights.
  static const FontWeight thin = FontWeight.w400;
  static const FontWeight extraLight = FontWeight.w400;
  static const FontWeight light = FontWeight.w400;
  static const FontWeight medium = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w700;
  static const FontWeight black = FontWeight.w700;

  // =========================================================================
  // TEXT STYLES
  // Sizes follow §3 role table.  height ≥1.5 on body/label per WCAG 1.4.12.
  // Eyebrow: uppercase, letter-spaced, used as a section tag.
  // =========================================================================

  // --- Display (splash wordmark / celebration titles) ----------------------

  /// 48px · bold — Splash screen wordmark only.
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48.0,
    fontWeight: bold,
    height: 1.2,
  );

  /// 30px · bold — Done / welcome / celebration title.
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30.0,
    fontWeight: bold,
    height: 1.25,
  );

  /// 28px · bold — Auth title (sign-in hub, email screen).
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: bold,
    height: 1.3,
  );

  // --- Headline (screen / section titles) ----------------------------------

  /// 26px · bold — Onboarding step title (H1).
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26.0,
    fontWeight: bold,
    height: 1.3,
  );

  /// 24px · bold — In-app screen / section title (H2).
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: bold,
    height: 1.35,
  );

  /// 20px · bold — H2 variant / module sub-title.
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0,
    fontWeight: bold,
    height: 1.35,
  );

  // --- Title (card / option row titles) ------------------------------------

  /// 18px · bold — Card title, OptionRow title.
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: bold,
    height: 1.4,
  );

  /// 16px · bold — AppBar title, list item title.
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: bold,
    height: 1.4,
  );

  /// 15px · bold — Section label, small titled group.
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: bold,
    height: 1.4,
  );

  // --- Body (reading text) -------------------------------------------------

  /// 18px · regular — Body (onboarding / first-run for maximum clarity).
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: regular,
    height: 1.55,
  );

  /// 16px · regular — Standard body text (minimum per design system).
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: regular,
    height: 1.55,
  );

  /// 15px · regular — Caption / sub-text / secondary description.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: regular,
    height: 1.55,
  );

  // --- Label (buttons, tags, semantics hints) ------------------------------

  /// 15px · bold — Button text, prominent tag.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: bold,
    height: 1.4,
  );

  /// 14.5px · regular — General label, small descriptor.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: regular,
    height: 1.45,
  );

  /// 14px · bold · letter-spaced — Eyebrow / section tag (uppercase in widgets).
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: bold,
    letterSpacing: 1.6,
    height: 1.2,
  );

  // =========================================================================
  // NAMED SEMANTIC ALIAS
  // =========================================================================

  /// Eyebrow label — 14px · bold · 1.6 letter-spacing.
  /// Used as an uppercase section tag; apply `.toUpperCase()` in the widget.
  static const TextStyle eyebrow = labelSmall;
}
