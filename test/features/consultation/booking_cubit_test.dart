// Unit tests for BookingCubit.
//
// Uses a manual fake BookingRepository. No mockito/mocktail dependency.
// Pattern: subscribe to stream BEFORE triggering action (BLoC streams are
// async broadcast — events must not be missed by subscribing after the emit).
//
// Covers: selectSlot, confirmBooking (happy path + conflict + generic error),
// loadMyBookings, cancelBooking, reset.
import 'package:flutter_test/flutter_test.dart';

import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/entities/consultation_booking_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/repositories/booking_repository.dart';
import 'package:opto/features/consultation/presentation/cubit/booking_cubit.dart';

// =============================================================================
// FAKES
// =============================================================================

final _slot = DoctorAvailabilityEntity(
  id: 'slot-1',
  doctorId: 'doc-1',
  slotStart: DateTime(2026, 8, 1, 9),
  slotEnd: DateTime(2026, 8, 1, 10),
  isBooked: false,
);

ConsultationBookingEntity _booking({
  BookingStatus status = BookingStatus.booked,
}) {
  return ConsultationBookingEntity(
    id: 'booking-1',
    userId: 'user-1',
    doctorId: 'doc-1',
    slotId: 'slot-1',
    mode: ConsultMode.nonVerbal,
    status: status,
    createdAt: DateTime(2026, 8, 1),
  );
}

class _FakeBookingRepository implements BookingRepository {
  bool shouldThrow = false;
  bool shouldThrowConflict = false;
  List<ConsultationBookingEntity> bookingsToReturn = [];

  @override
  Future<ConsultationBookingEntity> createBooking({
    required String doctorId,
    required String slotId,
    required ConsultMode mode,
    bool bookedViaVoice = false,
  }) async {
    if (shouldThrowConflict) {
      throw const ConflictFailure('Slot sudah dipesan oleh pasien lain.');
    }
    if (shouldThrow) throw ServerFailure('server error');
    return _booking();
  }

  @override
  Future<List<ConsultationBookingEntity>> getMyBookings() async {
    if (shouldThrow) throw ServerFailure('server error');
    return bookingsToReturn;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    if (shouldThrow) throw ServerFailure('server error');
  }
}

// =============================================================================
// TESTS
// =============================================================================

void main() {
  late _FakeBookingRepository repo;
  late BookingCubit cubit;

  setUp(() {
    repo = _FakeBookingRepository();
    cubit = BookingCubit(repo);
  });

  tearDown(() => cubit.close());

  // ── selectSlot ──────────────────────────────────────────────────────────────

  group('selectSlot', () {
    test('emits BookingSlotSelected with given slot and mode', () {
      cubit.selectSlot(_slot, mode: ConsultMode.nonVerbal);

      expect(cubit.state, isA<BookingSlotSelected>());
      final s = cubit.state as BookingSlotSelected;
      expect(s.slot, _slot);
      expect(s.mode, ConsultMode.nonVerbal);
    });

    test('defaults mode to video when not specified', () {
      cubit.selectSlot(_slot);

      final s = cubit.state as BookingSlotSelected;
      expect(s.mode, ConsultMode.video);
    });
  });

  // ── confirmBooking ──────────────────────────────────────────────────────────

  group('confirmBooking — happy path', () {
    test('emits submitting then confirmed with created booking', () async {
      cubit.selectSlot(_slot, mode: ConsultMode.nonVerbal);

      // Subscribe BEFORE triggering the action.
      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<BookingSubmitting>(),
          isA<BookingConfirmed>().having(
            (s) => s.booking.id,
            'booking.id',
            'booking-1',
          ),
        ]),
      );

      await cubit.confirmBooking(doctorId: 'doc-1');
      await future;
    });
  });

  group('confirmBooking — slot conflict', () {
    test('emits submitting → error → reverts to BookingSlotSelected', () async {
      repo.shouldThrowConflict = true;
      cubit.selectSlot(_slot, mode: ConsultMode.nonVerbal);

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<BookingSubmitting>(),
          isA<BookingError>().having(
            (s) => s.message,
            'message',
            contains('Slot sudah'),
          ),
          isA<BookingSlotSelected>(),
        ]),
      );

      await cubit.confirmBooking(doctorId: 'doc-1');
      await future;
    });
  });

  group('confirmBooking — generic server error', () {
    test('emits submitting → error → reverts to BookingSlotSelected', () async {
      repo.shouldThrow = true;
      cubit.selectSlot(_slot, mode: ConsultMode.nonVerbal);

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<BookingSubmitting>(),
          isA<BookingError>(),
          isA<BookingSlotSelected>(),
        ]),
      );

      await cubit.confirmBooking(doctorId: 'doc-1');
      await future;
    });
  });

  group('confirmBooking — no-op when not in slotSelected state', () {
    test('does not emit any state when called from initial state', () async {
      final states = <BookingState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.confirmBooking(doctorId: 'doc-1');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, isEmpty);
    });
  });

  // ── loadMyBookings ──────────────────────────────────────────────────────────

  group('loadMyBookings', () {
    test('emits BookingBookingsLoaded with the returned list', () async {
      repo.bookingsToReturn = [_booking()];

      final future = expectLater(
        cubit.stream,
        emits(
          isA<BookingBookingsLoaded>().having(
            (s) => s.bookings,
            'bookings',
            [_booking()],
          ),
        ),
      );

      cubit.loadMyBookings();
      await future;
    });

    test('emits BookingError when repo throws', () async {
      repo.shouldThrow = true;

      final future = expectLater(
        cubit.stream,
        emits(isA<BookingError>()),
      );

      cubit.loadMyBookings();
      await future;
    });
  });

  // ── cancelBooking ───────────────────────────────────────────────────────────

  group('cancelBooking', () {
    test('cancels then reloads bookings (emits bookingsLoaded)', () async {
      repo.bookingsToReturn = [];

      final future = expectLater(
        cubit.stream,
        emits(isA<BookingBookingsLoaded>()),
      );

      cubit.cancelBooking('booking-1');
      await future;
    });

    test('emits BookingError when cancel fails', () async {
      repo.shouldThrow = true;

      final future = expectLater(
        cubit.stream,
        emits(isA<BookingError>()),
      );

      cubit.cancelBooking('booking-1');
      await future;
    });
  });

  // ── reset ────────────────────────────────────────────────────────────────────

  group('reset', () {
    test('returns to initial state after slot selection', () {
      cubit.selectSlot(_slot);
      cubit.reset();

      expect(cubit.state, isA<BookingInitial>());
    });
  });
}
