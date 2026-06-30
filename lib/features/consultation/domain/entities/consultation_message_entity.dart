// Domain entity for a single text-chat message in a consultation session.
//
// Pure-Dart — no Supabase / serialization dependencies.
//
// 🔒 MEDICALLY SENSITIVE — part of the consultation doctor-patient conversation.
//    This entity MUST NOT appear in community feeds, map queries, or any public
//    join.  Never cache beyond session need.

/// Immutable domain representation of a single consultation chat message.
///
/// [fromMe] is NOT stored here — it is derived at the cubit level by comparing
/// [senderId] to the currently authenticated user's id.  This keeps the entity
/// free of any Supabase auth dependency.
///
/// 🔒 This entity contains medically sensitive data.  Access is restricted to
/// the patient and their assigned doctor via RLS.
class ConsultationMessageEntity {
  const ConsultationMessageEntity({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.body,
    required this.createdAt,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the parent booking — FK to `consultation_bookings.id`.
  final String bookingId;

  /// UUID of the profile who sent this message (patient or doctor).
  final String senderId;

  /// The message text body.
  final String body;

  /// Timestamp when the message was persisted (Supabase server time).
  final DateTime createdAt;

  // ---------------------------------------------------------------------------
  // Equality & hashCode
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsultationMessageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bookingId == other.bookingId &&
          senderId == other.senderId &&
          body == other.body &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, bookingId, senderId, body, createdAt);
}
