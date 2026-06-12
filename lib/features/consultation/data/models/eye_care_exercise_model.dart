// Freezed + json_serializable DTO for the `eye_care_exercises` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` —
// CONSULTATION.eye_care_exercises.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'eye_care_exercise_model.freezed.dart';
part 'eye_care_exercise_model.g.dart';

/// Data-layer representation of a row in the `eye_care_exercises` table.
///
/// Use [EyeCareExerciseModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/consultation/domain/entities/eye_care_exercise_entity.dart`.
@freezed
abstract class EyeCareExerciseModel with _$EyeCareExerciseModel {
  const factory EyeCareExerciseModel({
    /// Primary key (UUID).
    required String id,

    /// Human-readable exercise title (e.g. "Palming Relaxation").
    required String title,

    /// Storage path to the audio guidance file.
    @JsonKey(name: 'audio_guide_path') required String audioGuidePath,

    /// Total duration of the exercise in seconds.
    @JsonKey(name: 'duration_seconds') required int durationSeconds,

    /// Medical disclaimer text — MUST be displayed and read aloud before
    /// exercise playback.
    @JsonKey(name: 'medical_disclaimer') required String medicalDisclaimer,
  }) = _EyeCareExerciseModel;

  /// Deserialises a Supabase / JSON map to a [EyeCareExerciseModel].
  factory EyeCareExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$EyeCareExerciseModelFromJson(json);
}
