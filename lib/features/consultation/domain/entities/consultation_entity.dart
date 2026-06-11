// Domain entity for a completed consultation record.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.
//
// Corresponds to the `consultations` table in the Supabase database.
//
// 🔒 MEDICALLY SENSITIVE — RLS restricts access to the patient and the
//    assigned doctor only.  This entity MUST NOT appear in community feeds,
//    map queries, or any public join.  Never cache beyond session need.

/// Immutable domain representation of a consultation outcome record.
///
/// 🔒 This entity contains medically sensitive data.  Access is restricted
/// to the patient and their assigned doctor via RLS.  All nullable fields
/// ([summary], [prescription], [recordingPath]) may be absent if the doctor
/// has not yet completed their notes or if the patient declined recording.
///
/// [recordingPath] is only populated when the patient explicitly opted in
/// to session recording; it resolves to a private Storage object and must
/// be fetched via a signed URL from the repository.
class ConsultationEntity {
  const ConsultationEntity({
    required this.id,
    required this.bookingId,
    required this.createdAt,
    this.summary,
    this.prescription,
    this.recordingPath,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the parent booking — foreign key to `consultation_bookings.id`.
  final String bookingId;

  /// Doctor's clinical summary / notes; null if not yet written.
  final String? summary;

  /// Prescription text issued during the consultation; null if none issued.
  final String? prescription;

  /// Private Storage path to the session recording.
  /// Non-null only when the patient opted in to recording.
  /// Resolve to a signed URL via the repository before playback.
  final String? recordingPath;

  /// Timestamp when the consultation record was created.
  final DateTime createdAt;

  ConsultationEntity copyWith({
    String? id,
    String? bookingId,
    String? summary,
    String? prescription,
    String? recordingPath,
    DateTime? createdAt,
  }) {
    return ConsultationEntity(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      summary: summary ?? this.summary,
      prescription: prescription ?? this.prescription,
      recordingPath: recordingPath ?? this.recordingPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsultationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bookingId == other.bookingId &&
          summary == other.summary &&
          prescription == other.prescription &&
          recordingPath == other.recordingPath &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        bookingId,
        summary,
        prescription,
        recordingPath,
        createdAt,
      );
}
