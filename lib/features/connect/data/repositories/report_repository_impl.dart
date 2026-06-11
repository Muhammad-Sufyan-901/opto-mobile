// Concrete implementation of [ReportRepository].
//
// Delegates to [ConnectRemoteDataSource] for all PostgREST calls.
// Maps data-layer [ContentReportModel] to domain [ContentReportEntity] via
// the [ContentReportModelX.toEntity()] extension.
import 'package:opto/core/constants/connect_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/data/datasources/connect_remote_data_source.dart';
import 'package:opto/features/connect/data/models/content_report_model_ext.dart';
import 'package:opto/features/connect/domain/entities/content_report_entity.dart';
import 'package:opto/features/connect/domain/repositories/report_repository.dart';

/// Production implementation of [ReportRepository].
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class ReportRepositoryImpl implements ReportRepository {
  const ReportRepositoryImpl({
    required ConnectRemoteDataSource remoteDataSource,
  }) : _remote = remoteDataSource;

  final ConnectRemoteDataSource _remote;

  @override
  Future<ContentReportEntity> reportPost({
    required String postId,
    required ReportReason reason,
  }) async {
    final model = await _remote.reportPost(
      postId: postId,
      reason: reason.dbValue,
    );
    return model.toEntity();
  }
}
