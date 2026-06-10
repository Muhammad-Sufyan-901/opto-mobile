/// App-wide theme mode. Mirrors the Postgres `theme_mode` enum.
///
/// Default: [light] (canonical Opto blue-on-white, per design system §2).
enum AppThemeMode {
  /// Follow the OS light/dark preference.
  system,

  /// Canonical Opto blue-on-white light theme (default).
  light,

  /// Near-black surface dark theme.
  dark,

  /// ≥7:1 contrast everywhere — WCAG AAA (high-contrast).
  highContrast;

  /// Canonical DB string used in `accessibility_settings.theme` (Postgres enum).
  String get dbValue {
    return switch (this) {
      AppThemeMode.highContrast => 'high_contrast',
      _ => name, // 'system', 'light', 'dark' already match
    };
  }

  /// Parses the DB string back to [AppThemeMode].
  static AppThemeMode fromDbValue(String? value) {
    return AppThemeMode.values.firstWhere(
      (m) => m.dbValue == value,
      orElse: () => AppThemeMode.light,
    );
  }
}
