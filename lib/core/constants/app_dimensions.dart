/// Opto design-token dimensions.
///
/// Based on `.agents/app/design_system.md` §4 (8dp base grid).
/// Use these constants instead of magic numbers in widgets so the
/// design system can be updated in one place.
abstract class AppDimensions {
  // =========================================================================
  // SPACING  (8dp base grid)
  // =========================================================================

  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;

  // =========================================================================
  // SCREEN / LAYOUT
  // =========================================================================

  /// Outer horizontal padding — 24dp per design system (16dp minimum).
  static const double screenPadding = 24.0;
  static const double screenPaddingMin = 16.0;

  /// Vertical gap between major sections — 24–32dp.
  static const double sectionGap = 24.0;
  static const double sectionGapLarge = 32.0;

  /// Card internal padding — 16–20dp.
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 20.0;

  // =========================================================================
  // BORDER RADII
  // =========================================================================

  static const double radiusXs = 8.0; // calendar cells etc.
  static const double radiusButton = 16.0; // OptoButton
  static const double radiusInput = 14.0; // OptoField
  static const double radiusChip = 14.0; // icon chips, tags
  static const double radiusRow = 18.0; // OptionRow, SettingRow
  static const double radiusCard = 20.0; // cards, panels
  static const double radiusPhoneShell = 42.0; // phone frame illustration

  // =========================================================================
  // COMPONENT SIZES
  // =========================================================================

  /// Primary button height — ≥60dp per design system.
  static const double buttonHeight = 60.0;

  /// Text input height — 58dp.
  static const double inputHeight = 58.0;

  /// Minimum accessible tap target — 48×48dp (WCAG 2.5.5 / Material guidance).
  static const double minTapTarget = 48.0;

  /// Back / navigation icon button.
  static const double navIconSize = 48.0;

  /// Toggle pill dimensions — 56×32dp, knob 26dp.
  static const double toggleWidth = 56.0;
  static const double toggleHeight = 32.0;
  static const double toggleKnob = 26.0;

  /// Aura Voice persistent button.
  static const double auraVoiceButton = 56.0;

  /// Icon chip / relationship chip minimum size.
  static const double iconChipSize = 44.0;

  // =========================================================================
  // ICON SIZES
  // =========================================================================

  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // =========================================================================
  // FOCUS RING
  // =========================================================================

  /// Visible focus outline thickness — ≥3px per design system.
  static const double focusRingWidth = 3.0;

  /// Blue@16% halo spread radius.
  static const double focusHaloSpread = 4.0;

  // =========================================================================
  // ELEVATION / SHADOW
  // =========================================================================

  /// Soft cool-tinted shadow opacity — rgba(20, 40, 80, 0.20).
  static const double shadowOpacity = 0.20;

  /// Standard shadow blur radius.
  static const double shadowBlur = 8.0;

  /// Standard shadow y-offset.
  static const double shadowOffsetY = 2.0;
}
