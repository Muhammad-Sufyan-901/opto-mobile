// Freezed + json_serializable DTO for the `doctors` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` — CONSULTATION.doctors.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
//
// NOTE: fullName, avatarUrl, and clinicName are NOT columns on this table —
// they are joined from `profiles` and `clinics` at the repository level.
// The ext.dart mapper sets them to null; the repo impl populates them.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_model.freezed.dart';
part 'doctor_model.g.dart';

/// Data-layer representation of a row in the `doctors` table.
///
/// Use [DoctorModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/consultation/domain/entities/doctor_entity.dart`.
@freezed
abstract class DoctorModel with _$DoctorModel {
  const factory DoctorModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `profiles.id` — the doctor's user profile.
    @JsonKey(name: 'profile_id') required String profileId,

    /// Medical specialty description (e.g. "Ophthalmology", "Optometry").
    required String specialty,

    /// FK → `clinics.id` — nullable if the doctor is not clinic-affiliated.
    @JsonKey(name: 'clinic_id') String? clinicId,

    /// Whether the doctor's credentials have been verified by the platform.
    @JsonKey(name: 'is_verified') required bool isVerified,
  }) = _DoctorModel;

  /// Deserialises a Supabase / JSON map to a [DoctorModel].
  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
}
