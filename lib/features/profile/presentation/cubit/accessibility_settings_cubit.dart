// Cubit for accessibility settings — single source of truth for theme,
// text scale, haptics, and voice configuration at runtime.
//
// Initialises synchronously from the Hive cache (instant boot display),
// then loads from Supabase once the user signs in.
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/constants/app_theme_mode.dart';
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/profile/domain/entities/accessibility_settings_entity.dart';
import 'package:opto/features/profile/domain/repositories/accessibility_settings_repository.dart';

export 'package:opto/features/profile/domain/entities/accessibility_settings_entity.dart';

/// Manages [AccessibilitySettingsEntity] state for the current user.
///
/// Optimistic updates are applied immediately and written through to Supabase
/// asynchronously. On write failure the previous state is restored.
///
/// Lifecycle:
/// 1. Construction — boots from [AccessibilitySettingsRepository.getCachedSettings]
///    (or in-code defaults) for zero-latency startup.
/// 2. [loadForUser] — called after sign-in; fetches from Supabase and caches.
/// 3. [resetToDefaults] — called on sign-out (via the app's auth listener).
class AccessibilitySettingsCubit extends Cubit<AccessibilitySettingsEntity> {
  final AccessibilitySettingsRepository _repo;

  /// Initialises with cached settings (if available) for instant boot display.
  AccessibilitySettingsCubit(this._repo)
      : super(_repo.getCachedSettings() ?? _defaultSettings());

  // ---------------------------------------------------------------------------
  // DEFAULTS
  // ---------------------------------------------------------------------------

  static AccessibilitySettingsEntity _defaultSettings() =>
      const AccessibilitySettingsEntity(
        userId: '', // placeholder — replaced by loadForUser after sign-in
        theme: AppThemeMode.light,
        textScale: 1.0,
        fontFamily: 'AtkinsonHyperlegible',
        hapticIntensity: HapticLevel.full,
        voiceEnabled: true,
        hotwordEnabled: false,
        spokenGuidanceEnabled: true,
        speakingRate: 0.45,
      );

  // ---------------------------------------------------------------------------
  // LOAD
  // ---------------------------------------------------------------------------

  /// Loads settings from Supabase for [userId] and caches them locally.
  ///
  /// Call this immediately after the user signs in.  On failure the cubit
  /// stays on its current (cached / default) state — degraded mode.
  Future<void> loadForUser(String userId) async {
    try {
      final settings = await _repo.getSettings(userId);
      _repo.cacheSettings(settings); // local Hive cache only, not a Supabase write
      emit(settings);
    } on Failure catch (f) {
      // Don't clear cached/default state — degraded mode keeps the app usable.
      debugPrint('AccessibilitySettingsCubit: failed to load — ${f.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE HELPERS
  // ---------------------------------------------------------------------------

  /// Switch to [theme] immediately (optimistic) and persist to Supabase.
  Future<void> updateTheme(AppThemeMode theme) async =>
      _updateField((s) => s.copyWith(theme: theme));

  /// Change text scale to [scale] (1.0–3.0) immediately and persist.
  Future<void> updateTextScale(double scale) async =>
      _updateField((s) => s.copyWith(textScale: scale));

  /// Change haptic feedback intensity immediately and persist.
  Future<void> updateHaptic(HapticLevel level) async =>
      _updateField((s) => s.copyWith(hapticIntensity: level));

  /// Enable or disable Aura Voice globally and persist.
  Future<void> updateVoice({required bool enabled}) async =>
      _updateField((s) => s.copyWith(voiceEnabled: enabled));

  /// Enable or disable the always-on hotword listener and persist.
  Future<void> updateHotword({required bool enabled}) async =>
      _updateField((s) => s.copyWith(hotwordEnabled: enabled));

  /// Enable or disable spoken guidance (TTS feedback) and persist.
  Future<void> updateSpokenGuidance({required bool enabled}) async =>
      _updateField((s) => s.copyWith(spokenGuidanceEnabled: enabled));

  /// Change the TTS speaking rate (0.0–1.0) immediately and persist.
  Future<void> updateSpeakingRate(double rate) async =>
      _updateField((s) => s.copyWith(speakingRate: rate));

  /// Reset all settings to the Opto defaults.
  ///
  /// Does NOT write back to Supabase — call [loadForUser] to re-sync from the
  /// server, or call [upsertSettings] explicitly if reset should be persisted.
  void resetToDefaults() => emit(_defaultSettings());

  // ---------------------------------------------------------------------------
  // INTERNAL
  // ---------------------------------------------------------------------------

  Future<void> _updateField(
    AccessibilitySettingsEntity Function(AccessibilitySettingsEntity) updater,
  ) async {
    // Don't write to DB if we don't yet have a real user ID (pre-login state).
    if (state.userId.isEmpty) {
      emit(updater(state)); // optimistic local only
      return;
    }
    final previous = state;
    final updated = updater(state);
    emit(updated); // optimistic update
    try {
      await _repo.upsertSettings(updated);
    } on Failure catch (f) {
      emit(previous); // revert on failure
      debugPrint(
        'AccessibilitySettingsCubit: update failed — ${f.message}',
      );
    } catch (e) {
      emit(previous);
      debugPrint('AccessibilitySettingsCubit: unexpected error updating — $e');
    }
  }
}
