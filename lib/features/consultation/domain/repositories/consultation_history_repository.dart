// 🔒 MEDICALLY SENSITIVE — Domain contract for consultation history.
//
// Implementations live in the data layer
// (`lib/features/consultation/data/repositories/consultation_history_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
//
// SECURITY CONTRACT:
//   • RLS restricts all reads to the authenticated patient who owns the
//     consultation record and their assigned doctor.
//   • [ConsultationEntity] data MUST NOT appear in community feeds, map
//     queries, or any public join — ever.
//   • Do not cache responses beyond the lifetime of the current app session.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/consultation/domain/entities/consultation_entity.dart';

/// Abstract contract for patient-facing consultation history operations.
///
/// 🔒 This repository surfaces medically sensitive records — patient summaries,
/// prescriptions, and session recordings.  Access is controlled exclusively by
/// Supabase RLS (row-level security); no client-side access checks substitute
/// for server-enforced policies.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class ConsultationHistoryRepository {
  /// Fetches all [ConsultationEntity] records belonging to the currently
  /// signed-in patient, ordered by [createdAt] descending.
  ///
  /// Records are only returned for completed bookings; pending or cancelled
  /// bookings will not have a corresponding [ConsultationEntity].
  ///
  /// 🔒 Results must not be written to persistent local storage.
  ///
  /// Throws [AuthFailure] when the patient is unauthenticated.
  /// Throws [ServerFailure] on network / RLS error.
  Future<List<ConsultationEntity>> getMyConsultations();

  /// Fetches the [ConsultationEntity] linked to the booking identified by
  /// [bookingId].
  ///
  /// Use this to load the outcome of a specific consultation after a booking
  /// has been completed.
  ///
  /// 🔒 The [bookingId] is resolved through the RLS policy — an unauthenticated
  /// caller or a caller who does not own the booking will receive a
  /// [NotFoundFailure] rather than an [AuthFailure] to avoid leaking record
  /// existence.
  ///
  /// Throws [AuthFailure] when the patient is unauthenticated.
  /// Throws [NotFoundFailure] when no consultation record exists for
  ///   [bookingId] or the caller lacks access.
  /// Throws [ServerFailure] on network / RLS error.
  Future<ConsultationEntity> getConsultation(String bookingId);
}
