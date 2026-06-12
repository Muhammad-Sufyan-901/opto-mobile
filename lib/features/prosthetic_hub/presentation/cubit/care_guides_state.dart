// States for [CareGuidesCubit].
//
// Uses `freezed` for immutable, sealed state classes — mirrors the pattern
// in the consultation feature cubits.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';

part 'care_guides_state.freezed.dart';

@freezed
sealed class CareGuidesState with _$CareGuidesState {
  /// No data loaded yet; initial state.
  const factory CareGuidesState.initial() = CareGuidesInitial;

  /// Data fetch is in progress.
  const factory CareGuidesState.loading() = CareGuidesLoading;

  /// Care guides loaded successfully.
  const factory CareGuidesState.loaded(List<CareGuide> guides) =
      CareGuidesLoaded;

  /// Data fetch failed with [message].
  const factory CareGuidesState.error(String message) = CareGuidesError;
}
