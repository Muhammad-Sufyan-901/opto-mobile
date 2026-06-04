import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// =============================================================================
// APP THEME MODE ENUM
// =============================================================================

/// User-selectable theme modes.
///
/// The value is persisted to Hive as [name] (string) under [ThemeCubit.themeKey].
/// Synced to `accessibility_settings.theme` on Supabase when that migration is done.
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
  highContrast,
}

// =============================================================================
// THEME CUBIT
// =============================================================================

/// Holds and persists the active [AppThemeMode].
///
/// Usage:
/// ```dart
/// // Read in BlocBuilder
/// context.watch<ThemeCubit>().state // → AppThemeMode
///
/// // Switch theme
/// context.read<ThemeCubit>().setMode(AppThemeMode.dark);
/// ```
///
/// Registered as a lazy singleton in [GetIt] — provided via [BlocProvider.value]
/// at the root of the widget tree (see `app.dart`).
class ThemeCubit extends Cubit<AppThemeMode> {
  final Box _settingsBox;

  /// Hive key used to store the selected theme name.
  static const String themeKey = 'app_theme_mode';

  ThemeCubit(this._settingsBox) : super(_loadMode(_settingsBox));

  // ---------------------------------------------------------------------------
  // INIT HELPERS
  // ---------------------------------------------------------------------------

  static AppThemeMode _loadMode(Box box) {
    final stored = box.get(themeKey, defaultValue: AppThemeMode.light.name) as String;
    return AppThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => AppThemeMode.light,
    );
  }

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Switch to [mode] immediately and persist the choice.
  void setMode(AppThemeMode mode) {
    _settingsBox.put(themeKey, mode.name);
    emit(mode);
  }
}
