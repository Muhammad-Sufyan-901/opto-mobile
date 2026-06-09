// Concrete implementation of [CaregiverLinkRepository].
//
// Delegates to [ProfileRemoteDataSource] for PostgREST calls and maps
// data-layer [CaregiverLinkModel]s to domain [CaregiverLinkEntity]s via
// the [CaregiverLinkModelX.toEntity()] extension.
//
// SECURITY NOTE: `caregiver_links` is owner-only (RLS).  Never expose
// caregiver IDs in community, map, or catalog surfaces.
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:opto/features/profile/data/models/caregiver_link_model_ext.dart';
import 'package:opto/features/profile/domain/entities/caregiver_link_entity.dart';
import 'package:opto/features/profile/domain/repositories/caregiver_link_repository.dart';

/// Production implementation of [CaregiverLinkRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class CaregiverLinkRepositoryImpl implements CaregiverLinkRepository {
  const CaregiverLinkRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final ProfileRemoteDataSource _remote;

  @override
  Future<List<CaregiverLinkEntity>> getLinksForUser(String userId) async {
    final models = await _remote.getCaregiverLinks(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> requestLink({
    required String userId,
    required String caregiverId,
  }) async {
    final json = <String, dynamic>{
      'user_id': userId,
      'caregiver_id': caregiverId,
      'status': LinkStatus.pending.dbValue,
    };
    await _remote.requestLink(json);
  }

  @override
  Future<void> updateLinkStatus(String linkId, LinkStatus status) async {
    await _remote.updateLinkStatus(linkId, status.dbValue);
  }
}
