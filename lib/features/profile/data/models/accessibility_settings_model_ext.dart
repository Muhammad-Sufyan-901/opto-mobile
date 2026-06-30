// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/profile/data/models/accessibility_settings_model.dart';
import 'package:opto/features/profile/domain/entities/accessibility_settings_entity.dart';

/// Maps [AccessibilitySettingsModel] to the pure-Dart
/// [AccessibilitySettingsEntity] used in the domain and presentation layers.
extension AccessibilitySettingsModelX on AccessibilitySettingsModel {
  AccessibilitySettingsEntity toEntity() => AccessibilitySettingsEntity(
        userId: userId,
        theme: theme,
        textScale: textScale,
        fontFamily: fontFamily,
        hapticIntensity: hapticIntensity,
        voiceEnabled: voiceEnabled,
        hotwordEnabled: hotwordEnabled,
        spokenGuidanceEnabled: spokenGuidanceEnabled,
        speakingRate: speakingRate,
        soundEffectsEnabled: soundEffectsEnabled,
        updatedAt: updatedAt,
      );
}
