// Freezed + json_serializable DTO for the `accessibility_pois` table.
//
// Mirrors the row shape defined in `database_schema.md` §Accessibility Map.
//
// NOTE: This table is public-read (RLS). NEVER join or expose any 🔒 table
//       columns (anthropometric_data, eye_photos, consultations, sos_events)
//       alongside these rows.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accessibility_poi_model.freezed.dart';
part 'accessibility_poi_model.g.dart';

/// Data-layer representation of a row in the `accessibility_pois` table.
///
/// Use [AccessibilityPoiModel.fromJson] to deserialise a Supabase map.
/// Use `AccessibilityPoiModelX.toEntity()` to convert to the domain entity.
@freezed
abstract class AccessibilityPoiModel with _$AccessibilityPoiModel {
  const factory AccessibilityPoiModel({
    /// Primary key (UUID).
    required String id,

    /// Human-readable name of the place.
    required String name,

    /// Latitude (WGS-84) — stored as `double precision` in Postgres.
    required double lat,

    /// Longitude (WGS-84) — stored as `double precision` in Postgres.
    required double lng,

    /// Accessibility feature flags as a jsonb map.
    ///
    /// Keys follow [PoiAttribute.jsonKey] conventions; values are booleans.
    /// Use `Map<String, dynamic>` to handle free-form / unknown keys.
    required Map<String, dynamic> attributes,

    /// Number of community verifications.
    @JsonKey(name: 'verified_count') @Default(0) int verifiedCount,

    /// Optional FK to the profiles table (the creator).
    @JsonKey(name: 'created_by') String? createdBy,
  }) = _AccessibilityPoiModel;

  /// Deserialises a Supabase / JSON map to an [AccessibilityPoiModel].
  factory AccessibilityPoiModel.fromJson(Map<String, dynamic> json) =>
      _$AccessibilityPoiModelFromJson(json);
}
