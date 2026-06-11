// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/post_model.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';

/// Maps [PostModel] to the pure-Dart [PostEntity] used in the domain
/// and presentation layers.
extension PostModelX on PostModel {
  PostEntity toEntity() => PostEntity(
        id: id,
        authorId: authorId,
        body: body,
        createdAt: createdAt,
        // Computed/joined fields populated at repository level
        authorName: null,
        authorAvatarUrl: null,
        mediaList: const [],
        replyCount: 0,
        likeCount: 0,
        likedByMe: false,
      );
}
