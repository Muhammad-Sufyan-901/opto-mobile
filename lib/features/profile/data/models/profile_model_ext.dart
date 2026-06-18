// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/profile/data/models/profile_model.dart';
import 'package:opto/features/profile/domain/entities/profile_entity.dart';

/// Maps [ProfileModel] to the pure-Dart [ProfileEntity] used in the domain
/// and presentation layers.
extension ProfileModelX on ProfileModel {
  ProfileEntity toEntity() => ProfileEntity(
        id: id,
        role: role,
        fullName: fullName,
        phone: phone,
        visionProfile: visionProfile,
        avatarUrl: avatarUrl,
        username: username,
        pronouns: pronouns,
        bio: bio,
        location: location,
        createdAt: createdAt,
        preferredLanguage: preferredLanguage,
        clinicId: clinicId,
        clinicName: clinicName,
      );
}
