// Freezed + json_serializable DTO for the `posts` Supabase table.
//
// Mirrors the extended row shape defined in `database_schema.md` §4 CONNECT.posts
// plus the columns added in migration 20260614000000_community_feed_thread.sql.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

/// Data-layer representation of a row in the `posts` table.
///
/// Use [PostModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/connect/domain/entities/post_entity.dart`.
@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `profiles.id` — the post author.
    @JsonKey(name: 'author_id') required String authorId,

    /// Text body of the post.
    required String body,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// Optional short heading for the post.
    String? title,

    /// Topic/circle label used by filter chips (e.g. "Prosthetic care").
    String? topic,

    /// Optional voice-note recording URL.
    @JsonKey(name: 'voice_url') String? voiceUrl,
  }) = _PostModel;

  /// Deserialises a Supabase / JSON map to a [PostModel].
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
