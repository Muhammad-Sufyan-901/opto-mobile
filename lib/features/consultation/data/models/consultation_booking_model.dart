// Freezed + json_serializable DTO for the `consultation_bookings` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` —
// CONSULTATION.consultation_bookings.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
//
// NOTE: The `mode` and `status` Postgres enum columns are stored as plain
// strings here.  The ext.dart mapper converts them to [ConsultMode] and
// [BookingStatus] domain enums via their respective `fromString()` factory.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation_booking_model.freezed.dart';
part 'consultation_booking_model.g.dart';

/// Data-layer representation of a row in the `consultation_bookings` table.
///
/// Use [ConsultationBookingModel.fromJson] to deserialise a Supabase response
/// map.  The matching domain entity lives in
/// `lib/features/consultation/domain/entities/consultation_booking_entity.dart`.
@freezed
abstract class ConsultationBookingModel with _$ConsultationBookingModel {
  const factory ConsultationBookingModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `profiles.id` — the patient.
    @JsonKey(name: 'user_id') required String userId,

    /// FK → `doctors.id` — the booked doctor.
    @JsonKey(name: 'doctor_id') required String doctorId,

    /// FK → `doctor_availability.id` — the reserved slot.
    @JsonKey(name: 'slot_id') required String slotId,

    /// Delivery mode — raw Postgres `consult_mode` enum string
    /// ('video', 'non_verbal', 'in_person').
    required String mode,

    /// Lifecycle status — raw Postgres `booking_status` enum string
    /// ('booked', 'completed', 'cancelled').
    required String status,

    /// Whether the booking was completed entirely via Aura Voice.
    @JsonKey(name: 'booked_via_voice') required bool bookedViaVoice,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ConsultationBookingModel;

  /// Deserialises a Supabase / JSON map to a [ConsultationBookingModel].
  factory ConsultationBookingModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationBookingModelFromJson(json);
}
