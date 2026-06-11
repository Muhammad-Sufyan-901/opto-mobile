// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/post_reply_model.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';

/// Maps [PostReplyModel] to the pure-Dart [PostReplyEntity] used in the domain
/// and presentation layers.
extension PostReplyModelX on PostReplyModel {
  PostReplyEntity toEntity() => PostReplyEntity(
        id: id,
        postId: postId,
        authorId: authorId,
        body: body,
        createdAt: createdAt,
        // Joined author display name; populated at repository level.
        authorName: null,
      );
}
