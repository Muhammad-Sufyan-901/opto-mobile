// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/consultation/data/models/eye_care_exercise_model.dart';
import 'package:opto/features/consultation/domain/entities/eye_care_exercise_entity.dart';

/// Maps [EyeCareExerciseModel] to the pure-Dart [EyeCareExerciseEntity]
/// used in the domain and presentation layers.
extension EyeCareExerciseModelX on EyeCareExerciseModel {
  EyeCareExerciseEntity toEntity() => EyeCareExerciseEntity(
        id: id,
        title: title,
        audioGuidePath: audioGuidePath,
        durationSeconds: durationSeconds,
        medicalDisclaimer: medicalDisclaimer,
      );
}
