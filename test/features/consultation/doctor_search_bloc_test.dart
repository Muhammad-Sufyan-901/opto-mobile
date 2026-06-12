// Unit tests for DoctorSearchBloc.
//
// Uses manual fake repositories — no mockito/mocktail dependency.
// Covers: loadDoctors, searchDoctors, filterBySpecialty, loadAvailability,
// and error paths.
import 'package:flutter_test/flutter_test.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/entities/clinic_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/domain/entities/eye_care_exercise_entity.dart';
import 'package:opto/features/consultation/domain/repositories/doctor_directory_repository.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_bloc.dart';

// =============================================================================
// FAKES
// =============================================================================

final _doctorA = DoctorEntity(
  id: 'doc-1',
  profileId: 'prof-1',
  specialty: 'Ophthalmology',
  isVerified: true,
  fullName: 'Dr. Alice',
);

final _doctorB = DoctorEntity(
  id: 'doc-2',
  profileId: 'prof-2',
  specialty: 'Optometry',
  isVerified: true,
  fullName: 'Dr. Bob',
);

final _slot = DoctorAvailabilityEntity(
  id: 'slot-1',
  doctorId: 'doc-1',
  slotStart: DateTime(2026, 8, 1, 9),
  slotEnd: DateTime(2026, 8, 1, 10),
  isBooked: false,
);

class _FakeDoctorDirectoryRepository implements DoctorDirectoryRepository {
  // Control flags set per test
  bool shouldThrow = false;
  List<DoctorEntity> doctors = [_doctorA, _doctorB];
  List<DoctorAvailabilityEntity> availability = [_slot];

  @override
  Future<List<DoctorEntity>> searchDoctors({
    String? query,
    String? specialty,
  }) async {
    if (shouldThrow) throw ServerFailure('server error');
    if (specialty != null) {
      return doctors.where((d) => d.specialty == specialty).toList();
    }
    return doctors;
  }

  @override
  Future<DoctorEntity> getDoctor(String doctorId) async {
    if (shouldThrow) throw ServerFailure('server error');
    return doctors.firstWhere((d) => d.id == doctorId);
  }

  @override
  Future<List<DoctorAvailabilityEntity>> getAvailability(
      String doctorId) async {
    if (shouldThrow) throw ServerFailure('server error');
    return availability.where((s) => s.doctorId == doctorId).toList();
  }

  @override
  Future<List<ClinicEntity>> getClinics() async => [];

  @override
  Future<List<EyeCareExerciseEntity>> getEyeCareExercises() async => [];
}

// =============================================================================
// TESTS
// =============================================================================

void main() {
  late _FakeDoctorDirectoryRepository repo;
  late DoctorSearchBloc bloc;

  setUp(() {
    repo = _FakeDoctorDirectoryRepository();
    bloc = DoctorSearchBloc(repo);
  });

  tearDown(() => bloc.close());

  // ── loadDoctors ─────────────────────────────────────────────────────────────

  group('loadDoctors', () {
    test('emits loading then loaded with doctor list', () async {
      bloc.add(const DoctorSearchEvent.loadDoctors());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DoctorSearchLoading>(),
          isA<DoctorSearchLoaded>().having(
            (s) => s.doctors,
            'doctors',
            [_doctorA, _doctorB],
          ),
        ]),
      );
    });

    test('emits loading then error when repo throws', () async {
      repo.shouldThrow = true;
      bloc.add(const DoctorSearchEvent.loadDoctors());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DoctorSearchLoading>(),
          isA<DoctorSearchError>().having(
            (s) => s.message,
            'message',
            'server error',
          ),
        ]),
      );
    });

    test('loaded state has hasMore=false (no pagination yet)', () async {
      bloc.add(const DoctorSearchEvent.loadDoctors());

      final states = <DoctorSearchState>[];
      bloc.stream.listen(states.add);
      await bloc.stream.firstWhere((s) => s is DoctorSearchLoaded);

      final loaded = states.whereType<DoctorSearchLoaded>().first;
      expect(loaded.hasMore, isFalse);
    });
  });

  // ── searchDoctors ───────────────────────────────────────────────────────────

  group('searchDoctors', () {
    test('emits loading then loaded with activeQuery set', () async {
      bloc.add(const DoctorSearchEvent.searchDoctors('Optom'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DoctorSearchLoading>(),
          isA<DoctorSearchLoaded>()
              .having((s) => s.activeQuery, 'activeQuery', 'Optom'),
        ]),
      );
    });

    test('emits error when repo throws', () async {
      repo.shouldThrow = true;
      bloc.add(const DoctorSearchEvent.searchDoctors('x'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DoctorSearchLoading>(),
          isA<DoctorSearchError>(),
        ]),
      );
    });
  });

  // ── filterBySpecialty ───────────────────────────────────────────────────────

  group('filterBySpecialty', () {
    test('filters doctors to matching specialty and sets activeSpecialty',
        () async {
      bloc.add(
        const DoctorSearchEvent.filterBySpecialty('Optometry'),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DoctorSearchLoading>(),
          isA<DoctorSearchLoaded>()
              .having((s) => s.activeSpecialty, 'activeSpecialty', 'Optometry')
              .having((s) => s.doctors, 'doctors', [_doctorB]),
        ]),
      );
    });
  });

  // ── loadAvailability ────────────────────────────────────────────────────────

  group('loadAvailability', () {
    test('populates availability in loaded state', () async {
      // Prime the bloc with a loaded state first
      bloc.add(const DoctorSearchEvent.loadDoctors());
      await bloc.stream.firstWhere((s) => s is DoctorSearchLoaded);

      bloc.add(const DoctorSearchEvent.loadAvailability('doc-1'));

      await expectLater(
        bloc.stream,
        emits(
          isA<DoctorSearchLoaded>().having(
            (s) => s.availability,
            'availability',
            [_slot],
          ),
        ),
      );
    });

    test('no-op when state is not loaded', () async {
      // Bloc starts in initial state — loadAvailability should be ignored
      bloc.add(const DoctorSearchEvent.loadAvailability('doc-1'));

      // Give it time to process; no state change expected
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(bloc.state, isA<DoctorSearchInitial>());
    });
  });
}
