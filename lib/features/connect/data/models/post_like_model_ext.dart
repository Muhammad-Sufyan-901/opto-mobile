// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/post_like_model.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';

/// Convenience accessors on [PostLikeModel].
///
/// Full [PostEntity] hydration (likeCount, likedByMe, etc.) is done at the
/// repository level, not here.
extension PostLikeModelX on PostLikeModel {
  /// Like rows are not hydrated into a full entity — the repository uses
  /// [likedPostId] to build the `likedByMe` flag on [PostEntity] instead.
  String get likedPostId => postId;
}
