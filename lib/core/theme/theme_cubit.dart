import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:opto/core/constants/app_theme_mode.dart';

export 'package:opto/core/constants/app_theme_mode.dart' show AppThemeMode;

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
///
/// @deprecated Will be superseded by [AccessibilitySettingsCubit] once
/// app.dart (Step H) provides it to the root. Retained for backward compatibility
/// during the Phase 1 migration.
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
