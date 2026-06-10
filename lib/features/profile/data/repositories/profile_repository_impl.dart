// Concrete implementation of [ProfileRepository].
//
// Delegates to [ProfileRemoteDataSource] for all PostgREST calls.
// Maps data-layer [ProfileModel] to domain [ProfileEntity] via the
// [ProfileModelX.toEntity()] extension.
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:opto/features/profile/data/models/profile_model_ext.dart';
import 'package:opto/features/profile/domain/entities/profile_entity.dart';
import 'package:opto/features/profile/domain/repositories/profile_repository.dart';

/// Production implementation of [ProfileRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final ProfileRemoteDataSource _remote;

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    final model = await _remote.getProfile(userId);
    return model.toEntity();
  }

  @override
  Future<void> updateProfile(
    String userId, {
    String? fullName,
    String? phone,
    VisionProfile? visionProfile,
    String? avatarUrl,
  }) async {
    final fields = <String, dynamic>{
      'full_name': ?fullName,
      'phone': ?phone,
      'vision_profile': ?visionProfile?.dbValue,
      'avatar_url': ?avatarUrl,
    };

    if (fields.isEmpty) return; // nothing to update

    await _remote.updateProfile(userId, fields);
  }

  @override
  Future<void> updateVisionProfile(VisionProfile profile) async {
    await _remote.updateVisionProfile(profile.dbValue);
  }
}
