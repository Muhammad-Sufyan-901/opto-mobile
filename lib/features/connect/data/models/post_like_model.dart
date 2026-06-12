// Freezed + json_serializable DTO for the `post_likes` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` §4 CONNECT.post_likes.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
// The table has a UNIQUE(post_id, user_id) constraint enforced at DB level.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_like_model.freezed.dart';
part 'post_like_model.g.dart';

/// Data-layer representation of a row in the `post_likes` table.
///
/// Use [PostLikeModel.fromJson] to deserialise a Supabase response map.
/// Hydration into a full [PostEntity] is done at the repository level.
@freezed
abstract class PostLikeModel with _$PostLikeModel {
  const factory PostLikeModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `posts.id` — the liked post.
    @JsonKey(name: 'post_id') required String postId,

    /// FK → `profiles.id` — the user who liked the post.
    @JsonKey(name: 'user_id') required String userId,

    /// Row creation timestamp — set by Postgres default.
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PostLikeModel;

  /// Deserialises a Supabase / JSON map to a [PostLikeModel].
  factory PostLikeModel.fromJson(Map<String, dynamic> json) =>
      _$PostLikeModelFromJson(json);
}
