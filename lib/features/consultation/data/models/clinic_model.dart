// Freezed + json_serializable DTO for the `clinics` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` — CONSULTATION.clinics.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinic_model.freezed.dart';
part 'clinic_model.g.dart';

/// Data-layer representation of a row in the `clinics` table.
///
/// Use [ClinicModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/consultation/domain/entities/clinic_entity.dart`.
@freezed
abstract class ClinicModel with _$ClinicModel {
  const factory ClinicModel({
    /// Primary key (UUID).
    required String id,

    /// Display name of the clinic or prosthetic manufacturer.
    required String name,

    /// Whether this entry is a prosthetic manufacturer rather than a clinic.
    @JsonKey(name: 'is_manufacturer') required bool isManufacturer,

    /// Latitude coordinate for map display.
    required double lat,

    /// Longitude coordinate for map display.
    required double lng,

    /// Street / postal address.
    required String address,
  }) = _ClinicModel;

  /// Deserialises a Supabase / JSON map to a [ClinicModel].
  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);
}
