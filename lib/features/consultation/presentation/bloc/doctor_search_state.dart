// States for [DoctorSearchBloc].
//
// Uses `freezed` for immutable, sealed state classes — mirrors
// the pattern in `connect_feed_state.dart`.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

part 'doctor_search_state.freezed.dart';

@freezed
sealed class DoctorSearchState with _$DoctorSearchState {
  /// Doctor list not yet loaded.
  const factory DoctorSearchState.initial() = DoctorSearchInitial;

  /// Initial doctor list load in progress.
  const factory DoctorSearchState.loading() = DoctorSearchLoading;

  /// Doctors loaded successfully.
  ///
  /// [hasMore] is `false` once all pages have been fetched.
  /// [availability] is populated when [LoadAvailability] succeeds for a doctor.
  /// [activeQuery] is the current free-text search filter.
  /// [activeSpecialty] is the current specialty chip filter.
  const factory DoctorSearchState.loaded({
    required List<DoctorEntity> doctors,

    /// Whether more pages are available for pagination.
    required bool hasMore,

    /// Availability slots for the most-recently requested doctor.
    @Default([]) List<DoctorAvailabilityEntity> availability,

    /// Active free-text search query; null when no query is applied.
    String? activeQuery,

    /// Active specialty filter; null when no filter is applied.
    String? activeSpecialty,
  }) = DoctorSearchLoaded;

  /// Doctor load or operation failed with [message].
  const factory DoctorSearchState.error(String message) = DoctorSearchError;
}
