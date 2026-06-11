// Concrete implementation of [FollowRepository].
//
// Delegates to [ConnectRemoteDataSource] for all PostgREST calls.
// Maps data-layer [FollowModel] to domain [FollowEntity] via the
// [FollowModelX.toEntity()] extension.
import 'package:opto/core/constants/connect_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/features/connect/data/datasources/connect_remote_data_source.dart';
import 'package:opto/features/connect/data/models/follow_model_ext.dart';
import 'package:opto/features/connect/domain/entities/follow_entity.dart';
import 'package:opto/features/connect/domain/repositories/follow_repository.dart';

/// Production implementation of [FollowRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class FollowRepositoryImpl implements FollowRepository {
  const FollowRepositoryImpl({
    required ConnectRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final ConnectRemoteDataSource _remote;

  @override
  Future<List<FollowEntity>> getFollows() async {
    final userId = SupabaseClientProvider.client.auth.currentUser?.id;
    if (userId == null) throw const AuthFailure('Not authenticated');
    final models = await _remote.getFollows(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<FollowEntity> follow({
    required String targetId,
    required FollowType type,
  }) async {
    final model = await _remote.follow(
      targetId: targetId,
      type: type.dbValue,
    );
    return model.toEntity();
  }

  @override
  Future<void> unfollow({required String targetId}) =>
      _remote.unfollow(targetId: targetId);
}
