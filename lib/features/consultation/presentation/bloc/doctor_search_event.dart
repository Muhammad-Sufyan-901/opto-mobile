// Events for [DoctorSearchBloc].
//
// Uses `freezed` for immutable, sealed event classes — mirrors
// the pattern in `connect_feed_event.dart`.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_search_event.freezed.dart';

@freezed
sealed class DoctorSearchEvent with _$DoctorSearchEvent {
  /// Load (or reload) the full doctor list with no filters applied.
  ///
  /// Resets pagination to offset 0 and fetches verified doctors only.
  const factory DoctorSearchEvent.loadDoctors() = LoadDoctors;

  /// Search doctors matching [query] (name or specialty substring).
  const factory DoctorSearchEvent.searchDoctors(String query) = SearchDoctors;

  /// Narrow results to a single [specialty] string.
  const factory DoctorSearchEvent.filterBySpecialty(String specialty) =
      FilterBySpecialty;

  /// Fetch all future availability slots for [doctorId].
  const factory DoctorSearchEvent.loadAvailability(String doctorId) =
      LoadAvailability;

  /// Load the next page of doctors (pagination).
  ///
  /// No-op when [DoctorSearchState.loaded.hasMore] is false.
  const factory DoctorSearchEvent.loadNextPage() = LoadNextPage;
}
