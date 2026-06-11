// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/post_media_model.dart';
import 'package:opto/features/connect/domain/entities/post_media_entity.dart';

/// Maps [PostMediaModel] to the pure-Dart [PostMediaEntity] used in the domain
/// and presentation layers.
extension PostMediaModelX on PostMediaModel {
  PostMediaEntity toEntity() => PostMediaEntity(
        id: id,
        postId: postId,
        storagePath: storagePath,
        altText: altText,
      );
}
