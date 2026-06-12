// Freezed + json_serializable DTO for the `poi_contributions` table.
//
// Mirrors the row shape defined in `database_schema.md` §Accessibility Map.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'poi_contribution_model.freezed.dart';
part 'poi_contribution_model.g.dart';

/// Data-layer representation of a row in the `poi_contributions` table.
///
/// Use [PoiContributionModel.fromJson] to deserialise a Supabase map.
/// Use `PoiContributionModelX.toEntity()` to convert to the domain entity.
@freezed
abstract class PoiContributionModel with _$PoiContributionModel {
  const factory PoiContributionModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `accessibility_pois.id`.
    @JsonKey(name: 'poi_id') required String poiId,

    /// FK → `profiles.id`.
    @JsonKey(name: 'user_id') required String userId,

    /// Proposed change payload. Empty map `{}` for a plain verification.
    required Map<String, dynamic> change,

    /// Moderation status string — use [ContributionStatus.fromString].
    required String status,

    /// Row creation timestamp (ISO-8601 string from Postgres; nullable).
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _PoiContributionModel;

  /// Deserialises a Supabase / JSON map to a [PoiContributionModel].
  factory PoiContributionModel.fromJson(Map<String, dynamic> json) =>
      _$PoiContributionModelFromJson(json);
}
