// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/follow_model.dart';
import 'package:opto/features/connect/domain/entities/follow_entity.dart';

/// Maps [FollowModel] to the pure-Dart [FollowEntity] used in the domain
/// and presentation layers.
extension FollowModelX on FollowModel {
  FollowEntity toEntity() => FollowEntity(
        followerId: followerId,
        targetId: targetId,
        type: type,
      );
}
