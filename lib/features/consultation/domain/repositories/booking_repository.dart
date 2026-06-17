// Domain contract for consultation booking operations.
//
// Implementations live in the data layer
// (`lib/features/consultation/data/repositories/booking_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/error/failures.dart';
import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/features/consultation/domain/entities/consultation_booking_entity.dart';

/// Abstract contract for consultation booking operations.
///
/// RLS restricts all mutations and reads to the authenticated patient who owns
/// the booking; the assigned doctor may additionally read their own bookings
/// via a separate doctor-facing surface.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class BookingRepository {
  /// Creates a new consultation booking for the currently signed-in patient.
  ///
  /// [doctorId] must be a valid `doctors.id` UUID.
  /// [slotStart] is the desired UTC start time for the session.  The server
  ///   resolves an existing free `doctor_availability` slot at that time for the
  ///   given doctor, or creates one, then books it atomically — so no real slot
  ///   UUID is required from the client.
  /// [mode] sets the preferred delivery channel for the session.
  /// [bookedViaVoice] should be `true` when the booking was completed
  ///   entirely via the Aura Voice path — recorded as an accessibility KPI.
  ///
  /// Throws [AuthFailure] when the patient is unauthenticated.
  /// Throws [ConflictFailure] when [slotStart] is already taken for [doctorId].
  /// Throws [ServerFailure] on network / RLS error.
  Future<ConsultationBookingEntity> createBooking({
    required String doctorId,
    required DateTime slotStart,
    required ConsultMode mode,
    bool bookedViaVoice = false,
  });

  /// Fetches all bookings belonging to the currently signed-in patient,
  /// ordered by [createdAt] descending.
  ///
  /// Includes bookings in all lifecycle states
  /// ([BookingStatus.booked], [BookingStatus.completed],
  /// [BookingStatus.cancelled]).
  ///
  /// Throws [AuthFailure] when the patient is unauthenticated.
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<ConsultationBookingEntity>> getMyBookings();

  /// Cancels the booking identified by [bookingId].
  ///
  /// RLS enforces that only the booking owner can cancel their own booking.
  /// The repository implementation should also release the associated
  /// availability slot (set `is_booked = false`) to make it available again.
  ///
  /// Throws [AuthFailure] when the patient is unauthenticated.
  /// Throws [NotFoundFailure] when no booking exists for [bookingId].
  /// Throws [ServerFailure] on network / RLS error.
  Future<void> cancelBooking(String bookingId);
}
