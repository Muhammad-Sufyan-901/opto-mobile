// States for [SpecialistDirectoryCubit].
//
// Uses `freezed` for immutable, sealed state classes — mirrors the pattern
// used by [CareGuidesState] and other prosthetic_hub cubits.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/specialist.dart';

part 'specialist_directory_state.freezed.dart';

@freezed
sealed class SpecialistDirectoryState with _$SpecialistDirectoryState {
  /// No data loaded yet; initial state.
  const factory SpecialistDirectoryState.initial() =
      SpecialistDirectoryInitial;

  /// Data fetch is in progress.
  const factory SpecialistDirectoryState.loading() =
      SpecialistDirectoryLoading;

  /// Specialist directory loaded successfully.
  ///
  /// [recommended] — verified specialists recommended to the user.
  /// [all] — full directory (verified first, then unverified).
  const factory SpecialistDirectoryState.loaded({
    required List<Specialist> recommended,
    required List<Specialist> all,
  }) = SpecialistDirectoryLoaded;

  /// Data fetch failed with [message].
  const factory SpecialistDirectoryState.error(String message) =
      SpecialistDirectoryError;
}
