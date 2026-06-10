// Freezed + json_serializable DTO for the `vendors` table.
//
// Mirrors the row shape defined in `database_schema.md` §Prosthetic.vendors.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_model.freezed.dart';
part 'vendor_model.g.dart';

/// Data-layer representation of a row in the `vendors` table.
///
/// Use [VendorModel.fromJson] to deserialise a Supabase map.
/// Use `VendorModelX.toEntity()` (in `vendor_model_ext.dart`) to convert to
/// the domain entity.
@freezed
abstract class VendorModel with _$VendorModel {
  const factory VendorModel({
    /// Primary key (UUID).
    required String id,

    /// Display name of the vendor / clinic.
    required String name,

    /// Whether the vendor has been verified by Opto.
    @JsonKey(name: 'is_verified') required bool isVerified,

    /// Optional FK to a linked clinic record.
    @JsonKey(name: 'clinic_id') String? clinicId,
  }) = _VendorModel;

  /// Deserialises a Supabase / JSON map to a [VendorModel].
  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);
}
