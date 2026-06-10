// Freezed + json_serializable DTO for the `care_tutorials` table.
//
// Mirrors the row shape defined in `database_schema.md`
// §Prosthetic.care_tutorials.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';

part 'care_tutorial_model.freezed.dart';
part 'care_tutorial_model.g.dart';

// =============================================================================
// ENUM JSON HELPERS
// =============================================================================

TutorialCategory _categoryFromJson(String? v) => TutorialCategory.fromString(v);
String _categoryToJson(TutorialCategory t) => t.dbValue;

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `care_tutorials` table.
///
/// Use [CareTutorialModel.fromJson] to deserialise a Supabase map.
/// Use `CareTutorialModelX.toEntity()` (in
/// `care_tutorial_model_ext.dart`) to convert to the domain entity.
@freezed
abstract class CareTutorialModel with _$CareTutorialModel {
  const factory CareTutorialModel({
    /// Primary key (UUID).
    required String id,

    /// Human-readable tutorial title.
    required String title,

    /// Care-task category — mirrors the `tutorial_category` Postgres enum.
    @JsonKey(
      fromJson: _categoryFromJson,
      toJson: _categoryToJson,
    )
    required TutorialCategory category,

    /// Supabase Storage path for the tutorial video (nullable).
    @JsonKey(name: 'video_path') String? videoPath,

    /// Supabase Storage path for the audio narration (nullable).
    @JsonKey(name: 'audio_narration_path') String? audioNarrationPath,

    /// Full text transcript — always present (WCAG equivalent alternative).
    required String transcript,

    /// Display order within a category (ascending).
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _CareTutorialModel;

  /// Deserialises a Supabase / JSON map to a [CareTutorialModel].
  factory CareTutorialModel.fromJson(Map<String, dynamic> json) =>
      _$CareTutorialModelFromJson(json);
}
