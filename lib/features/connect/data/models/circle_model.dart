// Freezed + json_serializable DTO for the `circles` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` §4 CONNECT.circles.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_model.freezed.dart';
part 'circle_model.g.dart';

/// Data-layer representation of a row in the `circles` table.
///
/// Use [CircleModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/connect/domain/entities/circle_entity.dart`.
@freezed
abstract class CircleModel with _$CircleModel {
  const factory CircleModel({
    /// Primary key (UUID).
    required String id,

    /// URL-safe unique identifier for the circle (= posts.topic value).
    required String slug,

    /// Display name of the circle.
    required String name,

    /// Short one-line description shown in circle cards.
    String? description,

    /// Longer markdown-capable body shown on the circle detail screen.
    String? about,

    /// Icon identifier from the Opto icon catalog.
    @JsonKey(name: 'icon_key') String? iconKey,

    /// Color token key used to tint the circle card.
    @JsonKey(name: 'color_key') String? colorKey,

    /// Pinned moderator note displayed at the top of the circle feed.
    @JsonKey(name: 'pinned_note') String? pinnedNote,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CircleModel;

  /// Deserialises a Supabase / JSON map to a [CircleModel].
  factory CircleModel.fromJson(Map<String, dynamic> json) =>
      _$CircleModelFromJson(json);
}
