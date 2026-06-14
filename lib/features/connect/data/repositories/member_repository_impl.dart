// Concrete implementation of [MemberRepository].
//
// Delegates to [ConnectRemoteDataSource] for all PostgREST calls.
// The data source returns fully-hydrated [MemberProfileEntity] / [PostEntity]
// objects directly, so this layer is a thin pass-through.
import 'package:opto/features/connect/data/datasources/connect_remote_data_source.dart';
import 'package:opto/features/connect/domain/entities/member_profile_entity.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/repositories/member_repository.dart';

/// Production implementation of [MemberRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class MemberRepositoryImpl implements MemberRepository {
  const MemberRepositoryImpl({
    required ConnectRemoteDataSource remoteDataSource,
  }) : _ds = remoteDataSource;

  final ConnectRemoteDataSource _ds;

  @override
  Future<MemberProfileEntity> getMemberProfile(String memberId) =>
      _ds.getMemberProfile(memberId);

  @override
  Future<bool> toggleFollow(String memberId) =>
      _ds.toggleMemberFollow(memberId);

  @override
  Future<List<PostEntity>> getContributions(String memberId) =>
      _ds.getMemberContributions(memberId);
}
