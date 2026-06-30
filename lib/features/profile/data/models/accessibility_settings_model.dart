// Freezed + json_serializable DTO for the `accessibility_settings` table.
//
// Mirrors the row shape defined in `database_schema.md`
// §Identity.accessibility_settings.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/app_theme_mode.dart';
import 'package:opto/core/constants/identity_enums.dart';

part 'accessibility_settings_model.freezed.dart';
part 'accessibility_settings_model.g.dart';

// =============================================================================
// JSON CONVERTERS
// =============================================================================

/// Converts between [AppThemeMode] and the lowercase string stored in Postgres.
class _AppThemeModeConverter implements JsonConverter<AppThemeMode, String?> {
  const _AppThemeModeConverter();

  @override
  AppThemeMode fromJson(String? json) => AppThemeMode.fromDbValue(json);

  @override
  String toJson(AppThemeMode mode) {
    // AppThemeMode.system is a Flutter/UI-only concept (follow OS setting) and
    // has no Postgres enum literal — persist as 'light' (the Opto default).
    if (mode == AppThemeMode.system) return AppThemeMode.light.dbValue;
    return mode.dbValue;
  }
}

/// Converts between [HapticLevel] and the lowercase string stored in Postgres.
class _HapticLevelConverter implements JsonConverter<HapticLevel, String?> {
  const _HapticLevelConverter();

  @override
  HapticLevel fromJson(String? json) => HapticLevel.fromString(json);

  @override
  String toJson(HapticLevel level) => level.dbValue;
}

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `accessibility_settings` table.
///
/// This table has a 1-to-1 relationship with `profiles` via [userId].
/// Use [AccessibilitySettingsModel.fromJson] to deserialise a Supabase map.
///
/// All defaults mirror the Opto design system defaults (§2 + §6).
@freezed
abstract class AccessibilitySettingsModel with _$AccessibilitySettingsModel {
  const factory AccessibilitySettingsModel({
    /// Foreign key to `profiles.id` (UUID).
    @JsonKey(name: 'user_id') required String userId,

    /// Active theme; defaults to [AppThemeMode.light] (canonical blue-on-white).
    @_AppThemeModeConverter() @Default(AppThemeMode.light) AppThemeMode theme,

    /// Text scale multiplier — 1.0 to 3.0; default 1.0.
    @JsonKey(name: 'text_scale') @Default(1.0) double textScale,

    /// Primary typeface; defaults to the Opto design system font.
    @JsonKey(name: 'font_family')
    @Default('AtkinsonHyperlegible')
    String fontFamily,

    /// Haptic feedback intensity; defaults to [HapticLevel.full].
    @JsonKey(name: 'haptic_intensity')
    @_HapticLevelConverter()
    @Default(HapticLevel.full)
    HapticLevel hapticIntensity,

    /// Whether Aura Voice is enabled; defaults to true.
    @JsonKey(name: 'voice_enabled') @Default(true) bool voiceEnabled,

    /// Whether the always-on hotword listener is active; defaults to false.
    @JsonKey(name: 'hotword_enabled') @Default(false) bool hotwordEnabled,

    /// Whether spoken guidance (TTS feedback) is enabled; defaults to true.
    @JsonKey(name: 'spoken_guidance_enabled')
    @Default(true)
    bool spokenGuidanceEnabled,

    /// TTS speaking rate multiplier — 0.0 (slowest) to 1.0 (fastest); default 0.45.
    @JsonKey(name: 'speaking_rate') @Default(0.45) double speakingRate,

    /// DB column `sound_effects_enabled` (not null, default true).
    @JsonKey(name: 'sound_effects_enabled') @Default(true) bool soundEffectsEnabled,

    /// Timestamp of the last settings update (nullable if never explicitly saved).
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AccessibilitySettingsModel;

  /// Deserialises a Supabase / JSON map to an [AccessibilitySettingsModel].
  factory AccessibilitySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AccessibilitySettingsModelFromJson(json);
}
