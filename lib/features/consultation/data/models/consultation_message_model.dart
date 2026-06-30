// Freezed + json_serializable DTO for the `consultation_messages` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` —
// CONSULTATION.consultation_messages.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
//
// 🔒 MEDICALLY SENSITIVE — RLS restricts access to the patient and the
//    assigned doctor only.  This model MUST NOT appear in community feeds,
//    map queries, or any public join.  Never cache beyond session need.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation_message_model.freezed.dart';
part 'consultation_message_model.g.dart';

/// 🔒 Data-layer representation of a row in the `consultation_messages` table.
///
/// Use [ConsultationMessageModel.fromJson] to deserialise a Supabase response
/// map.  The matching domain entity lives in
/// `lib/features/consultation/domain/entities/consultation_message_entity.dart`.
@freezed
abstract class ConsultationMessageModel with _$ConsultationMessageModel {
  const factory ConsultationMessageModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `consultation_bookings.id`.
    @JsonKey(name: 'booking_id') required String bookingId,

    /// UUID of the profile who sent this message (patient or doctor).
    @JsonKey(name: 'sender_id') required String senderId,

    /// The message text body.
    required String body,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ConsultationMessageModel;

  /// Deserialises a Supabase / JSON map to a [ConsultationMessageModel].
  factory ConsultationMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationMessageModelFromJson(json);
}
