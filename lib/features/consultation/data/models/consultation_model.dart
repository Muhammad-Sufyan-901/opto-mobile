// Freezed + json_serializable DTO for the `consultations` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` —
// CONSULTATION.consultations.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
//
// 🔒 MEDICALLY SENSITIVE — RLS restricts access to the patient and the
//    assigned doctor only.  This model MUST NOT appear in community feeds,
//    map queries, or any public join.  Never cache beyond session need.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation_model.freezed.dart';
part 'consultation_model.g.dart';

/// 🔒 Data-layer representation of a row in the `consultations` table.
///
/// Use [ConsultationModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/consultation/domain/entities/consultation_entity.dart`.
///
/// All nullable fields ([summary], [prescription], [recordingPath]) are absent
/// until the doctor completes their notes or until the patient opts in to
/// recording.
@freezed
abstract class ConsultationModel with _$ConsultationModel {
  const factory ConsultationModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `consultation_bookings.id` — the parent booking.
    @JsonKey(name: 'booking_id') required String bookingId,

    /// Doctor's clinical summary / notes; null if not yet written.
    String? summary,

    /// Prescription text issued during the consultation; null if none issued.
    String? prescription,

    /// Private Storage path to the session recording.
    /// Non-null only when the patient opted in to recording.
    @JsonKey(name: 'recording_path') String? recordingPath,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ConsultationModel;

  /// Deserialises a Supabase / JSON map to a [ConsultationModel].
  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);
}
