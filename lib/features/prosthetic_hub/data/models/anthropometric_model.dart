// Freezed + json_serializable DTO for the `anthropometric_data` table.
//
// 🔒 SENSITIVE: owner-only RLS. Never join into catalog or community queries.
// Mirrors the row shape defined in `database_schema.md`
// §Prosthetic.anthropometric_data.
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';

part 'anthropometric_model.freezed.dart';
part 'anthropometric_model.g.dart';

// =============================================================================
// ENUM JSON HELPERS
// =============================================================================

DataSource _dataSourceFromJson(String? v) => DataSource.fromString(v);
String _dataSourceToJson(DataSource s) => s.dbValue;

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `anthropometric_data` table.
///
/// All measurement fields are nullable — they may be partially completed.
///
/// 🔒 SECURITY: This model must never appear in a join or select that is
/// accessible to other users. Queries must be scoped to [auth.uid()].
@freezed
abstract class AnthropometricModel with _$AnthropometricModel {
  const factory AnthropometricModel({
    /// Primary key (UUID).
    required String id,

    /// FK to `profiles.id` — the owner of this measurement record.
    @JsonKey(name: 'user_id') required String userId,

    /// Socket size in millimetres (nullable — may not yet be measured).
    @JsonKey(name: 'socket_size_mm') double? socketSizeMm,

    /// Socket curvature in mm (nullable).
    double? curvature,

    /// Iris diameter in millimetres (nullable).
    @JsonKey(name: 'iris_diameter_mm') double? irisDiameterMm,

    /// Hex colour code matched on-device via colour CV (nullable).
    @JsonKey(name: 'matched_iris_hex') String? matchedIrisHex,

    /// How the measurements were recorded.
    @JsonKey(
      fromJson: _dataSourceFromJson,
      toJson: _dataSourceToJson,
    )
    required DataSource source,

    /// Row creation timestamp (ISO 8601 string from Postgres).
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _AnthropometricModel;

  factory AnthropometricModel.fromJson(Map<String, dynamic> json) =>
      _$AnthropometricModelFromJson(json);
}
