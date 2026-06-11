// Freezed + json_serializable DTO for the `post_replies` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` §4 CONNECT.post_replies.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_reply_model.freezed.dart';
part 'post_reply_model.g.dart';

/// Data-layer representation of a row in the `post_replies` table.
///
/// Use [PostReplyModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/connect/domain/entities/post_reply_entity.dart`.
@freezed
abstract class PostReplyModel with _$PostReplyModel {
  const factory PostReplyModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `posts.id` — the post this reply belongs to.
    @JsonKey(name: 'post_id') required String postId,

    /// FK → `profiles.id` — the reply author.
    @JsonKey(name: 'author_id') required String authorId,

    /// Text body of the reply.
    required String body,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PostReplyModel;

  /// Deserialises a Supabase / JSON map to a [PostReplyModel].
  factory PostReplyModel.fromJson(Map<String, dynamic> json) =>
      _$PostReplyModelFromJson(json);
}
