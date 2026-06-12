// States for [EyeCareExercisesCubit].
//
// Uses `freezed` for immutable, sealed state classes — mirrors
// the pattern in `post_thread_cubit.dart`.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/consultation/domain/entities/eye_care_exercise_entity.dart';

part 'eye_care_exercises_state.freezed.dart';

@freezed
sealed class EyeCareExercisesState with _$EyeCareExercisesState {
  /// Exercise catalog not yet loaded.
  const factory EyeCareExercisesState.initial() = EyeCareExercisesInitial;

  /// Exercise catalog fetch in progress.
  const factory EyeCareExercisesState.loading() = EyeCareExercisesLoading;

  /// Exercise catalog loaded successfully.
  ///
  /// PATIENT SAFETY: the UI MUST display and read aloud
  /// [EyeCareExerciseEntity.medicalDisclaimer] for each exercise before
  /// starting playback — this is a non-negotiable patient-safety requirement.
  const factory EyeCareExercisesState.loaded({
    required List<EyeCareExerciseEntity> exercises,
  }) = EyeCareExercisesLoaded;

  /// Exercise catalog load failed with [message].
  const factory EyeCareExercisesState.error(String message) =
      EyeCareExercisesError;
}
