// BLoC for the doctor search / directory screen.
//
// Handles free-text search, specialty filtering, availability loading, and
// paginated doctor lists. Pagination offset tracking follows the same pattern
// as [ConnectFeedBloc].
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/repositories/doctor_directory_repository.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_event.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_state.dart';

export 'doctor_search_event.dart';
export 'doctor_search_state.dart';

/// BLoC that drives the doctor search / directory screen.
///
/// Responsibilities:
/// - [LoadDoctors] — resets pagination and fetches the initial page.
/// - [SearchDoctors] — fires a free-text search, resets pagination.
/// - [FilterBySpecialty] — narrows results to a single specialty, resets
///   pagination.
/// - [LoadAvailability] — fetches availability slots for a selected doctor and
///   surfaces them in [DoctorSearchLoaded.availability].
/// - [LoadNextPage] — appends the next page of results when more are available.
///
/// Pagination note: [DoctorDirectoryRepository.searchDoctors] does not yet
/// accept offset / limit parameters.  Until the contract is extended, all
/// events that trigger a list fetch return the full result set and set
/// [DoctorSearchLoaded.hasMore] to `false`.
// TODO(pagination): extend DoctorDirectoryRepository.searchDoctors with
// offset/limit params and wire _offset here.
class DoctorSearchBloc extends Bloc<DoctorSearchEvent, DoctorSearchState> {
  DoctorSearchBloc(this._doctorRepo) : super(const DoctorSearchState.initial()) {
    on<LoadDoctors>(_onLoadDoctors);
    on<SearchDoctors>(_onSearch);
    on<FilterBySpecialty>(_onFilter);
    on<LoadAvailability>(_onLoadAvailability);
    on<LoadNextPage>(_onLoadNextPage);
  }

  final DoctorDirectoryRepository _doctorRepo;

  static const int _pageSize = 20;

  /// Current pagination offset — reset to 0 by [LoadDoctors], [SearchDoctors],
  /// and [FilterBySpecialty]; incremented by [LoadNextPage].
  // TODO(pagination): use _offset and _pageSize once repository supports it.
  // ignore: unused_field
  int _offset = 0;

  // ---------------------------------------------------------------------------
  // HANDLERS
  // ---------------------------------------------------------------------------

  Future<void> _onLoadDoctors(
    LoadDoctors event,
    Emitter<DoctorSearchState> emit,
  ) async {
    _offset = 0;
    emit(const DoctorSearchState.loading());
    try {
      final doctors = await _doctorRepo.searchDoctors();
      // TODO(pagination): pass limit: _pageSize, offset: _offset when available.
      _offset = doctors.length;
      emit(DoctorSearchState.loaded(
        doctors: doctors,
        hasMore: false, // TODO(pagination): set true when doctors.length == _pageSize
      ));
    } on Failure catch (f) {
      emit(DoctorSearchState.error(f.message));
    } catch (_) {
      emit(const DoctorSearchState.error('An unexpected error occurred.'));
    }
  }

  Future<void> _onSearch(
    SearchDoctors event,
    Emitter<DoctorSearchState> emit,
  ) async {
    _offset = 0;
    // Show a loading spinner for fresh searches.
    emit(const DoctorSearchState.loading());
    try {
      final doctors = await _doctorRepo.searchDoctors(query: event.query);
      _offset = doctors.length;
      emit(DoctorSearchState.loaded(
        doctors: doctors,
        hasMore: false, // TODO(pagination)
        activeQuery: event.query,
      ));
    } on Failure catch (f) {
      emit(DoctorSearchState.error(f.message));
    } catch (_) {
      emit(const DoctorSearchState.error('An unexpected error occurred.'));
    }
  }

  Future<void> _onFilter(
    FilterBySpecialty event,
    Emitter<DoctorSearchState> emit,
  ) async {
    _offset = 0;
    emit(const DoctorSearchState.loading());
    try {
      final doctors =
          await _doctorRepo.searchDoctors(specialty: event.specialty);
      _offset = doctors.length;
      emit(DoctorSearchState.loaded(
        doctors: doctors,
        hasMore: false, // TODO(pagination)
        activeSpecialty: event.specialty,
      ));
    } on Failure catch (f) {
      emit(DoctorSearchState.error(f.message));
    } catch (_) {
      emit(const DoctorSearchState.error('An unexpected error occurred.'));
    }
  }

  Future<void> _onLoadAvailability(
    LoadAvailability event,
    Emitter<DoctorSearchState> emit,
  ) async {
    // Preserve the current doctor list while loading availability.
    if (state is! DoctorSearchLoaded) return;
    final current = state as DoctorSearchLoaded;
    try {
      final slots = await _doctorRepo.getAvailability(event.doctorId);
      emit(current.copyWith(availability: slots));
    } on Failure catch (f) {
      emit(DoctorSearchState.error(f.message));
    } catch (_) {
      emit(const DoctorSearchState.error('An unexpected error occurred.'));
    }
  }

  Future<void> _onLoadNextPage(
    LoadNextPage event,
    Emitter<DoctorSearchState> emit,
  ) async {
    if (state is! DoctorSearchLoaded) return;
    final current = state as DoctorSearchLoaded;

    // Guard: no-op when there are no more pages.
    if (!current.hasMore) return;

    // TODO(pagination): implement real pagination once repository supports
    // offset/limit.  For now hasMore is always false so this branch is
    // unreachable, but the structure is here for when it lands.
    try {
      final doctors = await _doctorRepo.searchDoctors(
        query: current.activeQuery,
        specialty: current.activeSpecialty,
      );
      _offset += doctors.length;
      emit(current.copyWith(
        doctors: [...current.doctors, ...doctors],
        hasMore: doctors.length == _pageSize,
      ));
    } on Failure catch (f) {
      emit(DoctorSearchState.error(f.message));
    } catch (_) {
      emit(const DoctorSearchState.error('An unexpected error occurred.'));
    }
  }
}
