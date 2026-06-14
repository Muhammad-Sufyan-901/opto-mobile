// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/post_model.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';

/// Maps [PostModel] to the pure-Dart [PostEntity] used in the domain
/// and presentation layers.
///
/// Joined / aggregated fields (author name, avatar, verified flag, counts,
/// likedByMe) are NOT on the model itself — they are passed in as optional
/// arguments and assembled by the data source or repository after executing
/// the enriched PostgREST query.
extension PostModelX on PostModel {
  PostEntity toEntity({
    String? authorName,
    String? authorAvatarUrl,
    bool authorIsVerified = false,
    int replyCount = 0,
    int likeCount = 0,
    bool likedByMe = false,
  }) =>
      PostEntity(
        id: id,
        authorId: authorId,
        body: body,
        createdAt: createdAt,
        title: title,
        topic: topic,
        voiceUrl: voiceUrl,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        authorIsVerified: authorIsVerified,
        mediaList: const [],
        replyCount: replyCount,
        likeCount: likeCount,
        likedByMe: likedByMe,
      );
}
