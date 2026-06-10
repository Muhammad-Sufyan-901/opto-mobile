// Tutorials states for [TutorialsCubit].
//
// Uses `freezed` for immutable, sealed state classes — consistent with the
// catalog_state pattern used elsewhere in this feature.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/prosthetic_hub/domain/entities/care_tutorial_entity.dart';

part 'tutorials_state.freezed.dart';

@freezed
sealed class TutorialsState with _$TutorialsState {
  /// Initial state — tutorials not yet loaded.
  const factory TutorialsState.initial() = TutorialsInitial;

  /// Tutorial list fetch in progress.
  const factory TutorialsState.loading() = TutorialsLoading;

  /// Tutorial list loaded successfully.
  const factory TutorialsState.loaded(
    List<CareTutorialEntity> tutorials,
  ) = TutorialsLoaded;

  /// Tutorial operation failed with [message].
  const factory TutorialsState.error(String message) = TutorialsError;
}
