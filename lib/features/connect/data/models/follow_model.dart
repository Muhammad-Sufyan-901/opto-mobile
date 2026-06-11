// Freezed + json_serializable DTO for the `follows` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` §4 CONNECT.follows.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opto/core/constants/connect_enums.dart';

part 'follow_model.freezed.dart';
part 'follow_model.g.dart';

// =============================================================================
// JSON CONVERTERS
// =============================================================================

/// Converts between [FollowType] and the lowercase string stored in Postgres.
class _FollowTypeConverter implements JsonConverter<FollowType, String?> {
  const _FollowTypeConverter();

  @override
  FollowType fromJson(String? json) => FollowType.fromString(json);

  @override
  String toJson(FollowType type) => type.dbValue;
}

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `follows` table.
///
/// The composite PK is (follower_id, target_id) — no surrogate `id` column.
/// Use [FollowModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/connect/domain/entities/follow_entity.dart`.
@freezed
abstract class FollowModel with _$FollowModel {
  const factory FollowModel({
    /// FK → `profiles.id` — the user who is following.
    @JsonKey(name: 'follower_id') required String followerId,

    /// FK → `profiles.id` — the user or topic being followed.
    @JsonKey(name: 'target_id') required String targetId,

    /// Whether this is a topic-tag follow or a people follow.
    @_FollowTypeConverter() required FollowType type,
  }) = _FollowModel;

  /// Deserialises a Supabase / JSON map to a [FollowModel].
  factory FollowModel.fromJson(Map<String, dynamic> json) =>
      _$FollowModelFromJson(json);
}
