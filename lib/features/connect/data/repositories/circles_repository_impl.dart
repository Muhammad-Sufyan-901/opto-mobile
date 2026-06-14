// Concrete implementation of [CirclesRepository].
//
// Delegates to [ConnectRemoteDataSource] for all PostgREST calls.
// The data source returns fully-hydrated [CircleEntity] objects directly,
// so this layer is a thin pass-through.
import 'package:opto/features/connect/data/datasources/connect_remote_data_source.dart';
import 'package:opto/features/connect/domain/entities/circle_entity.dart';
import 'package:opto/features/connect/domain/repositories/circles_repository.dart';

/// Production implementation of [CirclesRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class CirclesRepositoryImpl implements CirclesRepository {
  const CirclesRepositoryImpl({
    required ConnectRemoteDataSource remoteDataSource,
  }) : _ds = remoteDataSource;

  final ConnectRemoteDataSource _ds;

  @override
  Future<List<CircleEntity>> getCircles() => _ds.getCircles();

  @override
  Future<CircleEntity> getCircle(String slug) => _ds.getCircle(slug);

  @override
  Future<void> joinCircle(String circleId) => _ds.joinCircle(circleId);

  @override
  Future<void> leaveCircle(String circleId) => _ds.leaveCircle(circleId);
}
