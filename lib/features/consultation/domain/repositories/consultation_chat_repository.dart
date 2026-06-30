// Domain contract for the consultation text-chat repository.
//
// 🔒 MEDICALLY SENSITIVE — conversation data between patient and doctor.
//    All data surfaced by this contract is restricted to the patient and their
//    assigned doctor via Supabase RLS.  Never expose to community, catalog,
//    or map layers.

import 'package:opto/features/consultation/domain/entities/consultation_message_entity.dart';

/// Contract for the consultation text-chat data source.
///
/// Implementations must:
///   • Restrict data to the authenticated user's bookings (enforced by RLS).
///   • Never surface message data outside the consultation feature.
///   • Cancel any active stream subscriptions when no longer needed.
///
/// 🔒 [ConsultationMessageEntity] is medically sensitive — treat accordingly.
abstract class ConsultationChatRepository {
  /// Returns a live stream of all messages for [bookingId], ordered by
  /// [createdAt] ascending.  The stream re-emits whenever a new message is
  /// inserted (Supabase Realtime, filtered by booking_id).
  ///
  /// The caller is responsible for cancelling the subscription when done.
  Stream<List<ConsultationMessageEntity>> watchMessages(String bookingId);

  /// Inserts a new message from the current authenticated user into [bookingId].
  ///
  /// Throws a [Failure] subclass on network or authorization errors.
  Future<void> sendMessage({
    required String bookingId,
    required String body,
  });

  /// The current authenticated user's id (Supabase auth.uid()), or `null` if
  /// not authenticated.
  ///
  /// Exposed so the cubit can derive [fromMe] without importing the Supabase
  /// client directly.
  String? get currentUserId;
}
