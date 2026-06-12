// Unit tests for ConsultationHistoryCubit (🔒 medically sensitive).
//
// Verifies correct loaded/error states and that no cross-patient data leakage
// is possible through the in-memory fake.
//
// Pattern: subscribe to stream BEFORE triggering action to avoid missing
// events on async broadcast streams.
import 'package:flutter_test/flutter_test.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/entities/consultation_entity.dart';
import 'package:opto/features/consultation/domain/repositories/consultation_history_repository.dart';
import 'package:opto/features/consultation/presentation/cubit/consultation_history_cubit.dart';

// =============================================================================
// FAKES
// =============================================================================

ConsultationEntity _consultation({String id = 'cons-1'}) {
  return ConsultationEntity(
    id: id,
    bookingId: 'booking-$id',
    createdAt: DateTime(2026, 7, 15),
    summary: 'Patient reports mild photophobia.',
  );
}

class _FakeConsultationHistoryRepository
    implements ConsultationHistoryRepository {
  bool shouldThrow = false;
  bool shouldThrowAuth = false;
  List<ConsultationEntity> consultations = [];

  @override
  Future<List<ConsultationEntity>> getMyConsultations() async {
    if (shouldThrowAuth) throw const AuthFailure('Not authenticated');
    if (shouldThrow) throw ServerFailure('server error');
    return List.of(consultations);
  }

  @override
  Future<ConsultationEntity> getConsultation(String bookingId) async {
    if (shouldThrow) throw ServerFailure('server error');
    return consultations.firstWhere(
      (c) => c.bookingId == bookingId,
      orElse: () => throw const NotFoundFailure('Not found'),
    );
  }
}

// =============================================================================
// TESTS
// =============================================================================

void main() {
  late _FakeConsultationHistoryRepository repo;
  late ConsultationHistoryCubit cubit;

  setUp(() {
    repo = _FakeConsultationHistoryRepository();
    cubit = ConsultationHistoryCubit(repo);
  });

  tearDown(() => cubit.close());

  group('loadHistory — happy path', () {
    test('emits loading then loaded with consultations', () async {
      repo.consultations = [_consultation(), _consultation(id: 'cons-2')];

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ConsultationHistoryLoading>(),
          isA<ConsultationHistoryLoaded>().having(
            (s) => s.consultations.length,
            'consultations.length',
            2,
          ),
        ]),
      );

      cubit.loadHistory();
      await future;
    });

    test('emits loading then loaded with empty list when no consultations',
        () async {
      repo.consultations = [];

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ConsultationHistoryLoading>(),
          isA<ConsultationHistoryLoaded>().having(
            (s) => s.consultations,
            'consultations',
            isEmpty,
          ),
        ]),
      );

      cubit.loadHistory();
      await future;
    });
  });

  group('loadHistory — error paths', () {
    test('emits loading then error when server fails', () async {
      repo.shouldThrow = true;

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ConsultationHistoryLoading>(),
          isA<ConsultationHistoryError>(),
        ]),
      );

      cubit.loadHistory();
      await future;
    });

    test('emits loading then error when user is unauthenticated', () async {
      repo.shouldThrowAuth = true;

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ConsultationHistoryLoading>(),
          isA<ConsultationHistoryError>().having(
            (s) => s.message,
            'message',
            'Not authenticated',
          ),
        ]),
      );

      cubit.loadHistory();
      await future;
    });
  });

  group('🔒 cross-patient isolation', () {
    test('loaded state contains only the rows returned by the repo', () async {
      repo.consultations = [_consultation(id: 'mine-1')];

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ConsultationHistoryLoading>(),
          isA<ConsultationHistoryLoaded>(),
        ]),
      );

      cubit.loadHistory();
      await future;

      final loaded = cubit.state as ConsultationHistoryLoaded;
      expect(loaded.consultations, hasLength(1));
      expect(loaded.consultations.first.id, 'mine-1');
    });

    test('second loadHistory call replaces results — no stale data leaks',
        () async {
      repo.consultations = [_consultation(id: 'first')];
      cubit.loadHistory();
      await cubit.stream.firstWhere((s) => s is ConsultationHistoryLoaded);

      // Simulate a different result set
      repo.consultations = [_consultation(id: 'second')];

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<ConsultationHistoryLoading>(),
          isA<ConsultationHistoryLoaded>(),
        ]),
      );

      cubit.loadHistory();
      await future;

      final loaded = cubit.state as ConsultationHistoryLoaded;
      expect(loaded.consultations.first.id, 'second');
      expect(loaded.consultations.any((c) => c.id == 'first'), isFalse);
    });
  });
}
