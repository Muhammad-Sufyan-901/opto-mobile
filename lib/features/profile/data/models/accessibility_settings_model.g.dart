// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccessibilitySettingsModel _$AccessibilitySettingsModelFromJson(
  Map<String, dynamic> json,
) => _AccessibilitySettingsModel(
  userId: json['user_id'] as String,
  theme: json['theme'] == null
      ? AppThemeMode.light
      : const _AppThemeModeConverter().fromJson(json['theme'] as String?),
  textScale: (json['text_scale'] as num?)?.toDouble() ?? 1.0,
  fontFamily: json['font_family'] as String? ?? 'AtkinsonHyperlegible',
  hapticIntensity: json['haptic_intensity'] == null
      ? HapticLevel.full
      : const _HapticLevelConverter().fromJson(
          json['haptic_intensity'] as String?,
        ),
  voiceEnabled: json['voice_enabled'] as bool? ?? true,
  hotwordEnabled: json['hotword_enabled'] as bool? ?? false,
  spokenGuidanceEnabled: json['spoken_guidance_enabled'] as bool? ?? true,
  speakingRate: (json['speaking_rate'] as num?)?.toDouble() ?? 0.45,
  soundEffectsEnabled: json['sound_effects_enabled'] as bool? ?? true,
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AccessibilitySettingsModelToJson(
  _AccessibilitySettingsModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'theme': const _AppThemeModeConverter().toJson(instance.theme),
  'text_scale': instance.textScale,
  'font_family': instance.fontFamily,
  'haptic_intensity': const _HapticLevelConverter().toJson(
    instance.hapticIntensity,
  ),
  'voice_enabled': instance.voiceEnabled,
  'hotword_enabled': instance.hotwordEnabled,
  'spoken_guidance_enabled': instance.spokenGuidanceEnabled,
  'speaking_rate': instance.speakingRate,
  'sound_effects_enabled': instance.soundEffectsEnabled,
  'updated_at': instance.updatedAt?.toIso8601String(),
};
