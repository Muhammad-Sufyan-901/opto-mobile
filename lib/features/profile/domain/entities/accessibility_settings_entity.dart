// Domain entity for user accessibility settings.
//
// Pure-Dart representation used in use-cases and BLoC states.
// Mirrors [AccessibilitySettingsModel] without serialisation dependencies.
import 'package:opto/core/constants/app_theme_mode.dart';
import 'package:opto/core/constants/identity_enums.dart';

/// Immutable domain representation of the `accessibility_settings` table row.
class AccessibilitySettingsEntity {
  const AccessibilitySettingsEntity({
    required this.userId,
    this.theme = AppThemeMode.light,
    this.textScale = 1.0,
    this.fontFamily = 'AtkinsonHyperlegible',
    this.hapticIntensity = HapticLevel.full,
    this.voiceEnabled = true,
    this.hotwordEnabled = false,
    this.spokenGuidanceEnabled = true,
    this.speakingRate = 0.45,
    this.updatedAt,
  });

  /// Foreign key to `profiles.id` (UUID).
  final String userId;

  /// Active theme; defaults to [AppThemeMode.light].
  final AppThemeMode theme;

  /// Text scale multiplier — 1.0 to 3.0.
  final double textScale;

  /// Primary typeface.
  final String fontFamily;

  /// Haptic feedback intensity.
  final HapticLevel hapticIntensity;

  /// Whether Aura Voice is globally enabled.
  final bool voiceEnabled;

  /// Whether the always-on hotword listener is active.
  final bool hotwordEnabled;

  /// Whether spoken guidance (TTS feedback) is enabled; defaults to true.
  final bool spokenGuidanceEnabled;

  /// TTS speaking rate multiplier — 0.0 (slowest) to 1.0 (fastest); default 0.45.
  final double speakingRate;

  /// Timestamp of the last settings update (null if never explicitly saved).
  final DateTime? updatedAt;

  /// Creates a copy with the given fields replaced.
  ///
  /// Note: passing `null` for a nullable field leaves it unchanged (does not
  /// clear it). To explicitly clear a nullable field, create a new instance
  /// with `AccessibilitySettingsEntity(...)`.
  AccessibilitySettingsEntity copyWith({
    String? userId,
    AppThemeMode? theme,
    double? textScale,
    String? fontFamily,
    HapticLevel? hapticIntensity,
    bool? voiceEnabled,
    bool? hotwordEnabled,
    bool? spokenGuidanceEnabled,
    double? speakingRate,
    DateTime? updatedAt,
  }) {
    return AccessibilitySettingsEntity(
      userId: userId ?? this.userId,
      theme: theme ?? this.theme,
      textScale: textScale ?? this.textScale,
      fontFamily: fontFamily ?? this.fontFamily,
      hapticIntensity: hapticIntensity ?? this.hapticIntensity,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      hotwordEnabled: hotwordEnabled ?? this.hotwordEnabled,
      spokenGuidanceEnabled:
          spokenGuidanceEnabled ?? this.spokenGuidanceEnabled,
      speakingRate: speakingRate ?? this.speakingRate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessibilitySettingsEntity &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          theme == other.theme &&
          textScale == other.textScale &&
          fontFamily == other.fontFamily &&
          hapticIntensity == other.hapticIntensity &&
          voiceEnabled == other.voiceEnabled &&
          hotwordEnabled == other.hotwordEnabled &&
          spokenGuidanceEnabled == other.spokenGuidanceEnabled &&
          speakingRate == other.speakingRate &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        userId,
        theme,
        textScale,
        fontFamily,
        hapticIntensity,
        voiceEnabled,
        hotwordEnabled,
        spokenGuidanceEnabled,
        speakingRate,
        updatedAt,
      );
}
