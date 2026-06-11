// Cubit for the eye-care exercises catalog screen.
//
// Loads published exercises from [DoctorDirectoryRepository.getEyeCareExercises].
// The UI layer is responsible for displaying and reading aloud the
// [EyeCareExerciseEntity.medicalDisclaimer] before starting any exercise —
// this is a patient-safety requirement enforced at the presentation layer.
//
// State is defined in `eye_care_exercises_state.dart` using `freezed` to match
// the project convention (see `post_thread_cubit.dart`).
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/repositories/doctor_directory_repository.dart';
import 'package:opto/features/consultation/presentation/cubit/eye_care_exercises_state.dart';

export 'eye_care_exercises_state.dart';

/// Cubit that drives the eye-care exercises catalog screen.
///
/// Responsibilities:
/// - Fetch all published eye-care exercises from
///   [DoctorDirectoryRepository.getEyeCareExercises].
/// - Surface load errors to the UI for accessible announcement.
///
/// PATIENT SAFETY: callers MUST display and read aloud
/// [EyeCareExerciseEntity.medicalDisclaimer] before starting playback.
class EyeCareExercisesCubit extends Cubit<EyeCareExercisesState> {
  EyeCareExercisesCubit(this._doctorRepo)
      : super(const EyeCareExercisesState.initial());

  final DoctorDirectoryRepository _doctorRepo;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Loads (or reloads) the published eye-care exercise catalog.
  ///
  /// Emits [EyeCareExercisesLoading] while the request is in flight, then
  /// either [EyeCareExercisesLoaded] or [EyeCareExercisesError].
  Future<void> loadExercises() async {
    emit(const EyeCareExercisesState.loading());
    try {
      final exercises = await _doctorRepo.getEyeCareExercises();
      emit(EyeCareExercisesState.loaded(exercises: exercises));
    } on Failure catch (e) {
      emit(EyeCareExercisesState.error(e.message));
    } catch (e) {
      emit(EyeCareExercisesState.error(e.toString()));
    }
  }
}
