// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/member_profile_model.dart';
import 'package:opto/features/connect/domain/entities/member_profile_entity.dart';

/// Maps [MemberProfileModel] to the pure-Dart [MemberProfileEntity] used in
/// the domain and presentation layers.
///
/// Community stats (postsCount, helpfulCount, circlesCount) and the social
/// relation (isFollowedByMe) are NOT on the model itself — they are passed in
/// as optional arguments and assembled by the data source after parallel RPC
/// and follow-check queries.
extension MemberProfileModelX on MemberProfileModel {
  MemberProfileEntity toEntity({
    int postsCount = 0,
    int helpfulCount = 0,
    int circlesCount = 0,
    bool isFollowedByMe = false,
  }) {
    return MemberProfileEntity(
      id: id,
      name: fullName,
      handle: handle,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
      isMentor: isMentor,
      bio: bio,
      joinedYear: createdAt.year,
      postsCount: postsCount,
      helpfulCount: helpfulCount,
      circlesCount: circlesCount,
      isFollowedByMe: isFollowedByMe,
    );
  }
}
