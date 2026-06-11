// Freezed + json_serializable DTO for the `doctor_availability` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` —
// CONSULTATION.doctor_availability.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_availability_model.freezed.dart';
part 'doctor_availability_model.g.dart';

/// Data-layer representation of a row in the `doctor_availability` table.
///
/// Use [DoctorAvailabilityModel.fromJson] to deserialise a Supabase response
/// map.  The matching domain entity lives in
/// `lib/features/consultation/domain/entities/doctor_availability_entity.dart`.
@freezed
abstract class DoctorAvailabilityModel with _$DoctorAvailabilityModel {
  const factory DoctorAvailabilityModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `doctors.id` — the doctor who owns this slot.
    @JsonKey(name: 'doctor_id') required String doctorId,

    /// Start of the bookable time window (UTC timestamptz).
    @JsonKey(name: 'slot_start') required DateTime slotStart,

    /// End of the bookable time window (UTC timestamptz).
    @JsonKey(name: 'slot_end') required DateTime slotEnd,

    /// Whether this slot has already been claimed by a booking.
    @JsonKey(name: 'is_booked') required bool isBooked,
  }) = _DoctorAvailabilityModel;

  /// Deserialises a Supabase / JSON map to a [DoctorAvailabilityModel].
  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorAvailabilityModelFromJson(json);
}
