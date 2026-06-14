// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/post_reply_model.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';

/// Maps [PostReplyModel] to the pure-Dart [PostReplyEntity] used in the domain
/// and presentation layers.
///
/// Joined fields (author name, verified flag) are NOT on the model itself —
/// they are passed in as optional arguments and assembled by the data source
/// after executing the enriched PostgREST query.
extension PostReplyModelX on PostReplyModel {
  PostReplyEntity toEntity({
    String? authorName,
    bool authorIsVerified = false,
    int likeCount = 0,
  }) =>
      PostReplyEntity(
        id: id,
        postId: postId,
        authorId: authorId,
        body: body,
        createdAt: createdAt,
        authorName: authorName,
        authorIsVerified: authorIsVerified,
        parentReplyId: parentReplyId,
        isBestAnswer: isBestAnswer,
        voiceUrl: voiceUrl,
        likeCount: likeCount,
      );
}
