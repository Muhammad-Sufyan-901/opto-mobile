// Repository implementation for the poi_contributions domain area.
//
// Delegates all I/O to [MapRemoteDataSource].
import 'package:opto/features/accessibility_map/data/datasources/map_remote_data_source.dart';
import 'package:opto/features/accessibility_map/data/models/poi_contribution_model_ext.dart';
import 'package:opto/features/accessibility_map/domain/entities/poi_contribution_entity.dart';
import 'package:opto/features/accessibility_map/domain/repositories/contributions_repository.dart';

/// Production [ContributionsRepository] backed by [MapRemoteDataSource].
class ContributionsRepositoryImpl implements ContributionsRepository {
  const ContributionsRepositoryImpl({required MapRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  final MapRemoteDataSource _remote;

  @override
  Future<PoiContributionEntity> submitContribution({
    required String poiId,
    Map<String, dynamic> change = const {},
  }) async {
    final model = await _remote.insertContribution(
      poiId: poiId,
      change: change,
    );
    return model.toEntity();
  }

  @override
  Future<List<PoiContributionEntity>> getMyContributions() async {
    final models = await _remote.getMyContributions();
    return models.map((m) => m.toEntity()).toList();
  }
}
