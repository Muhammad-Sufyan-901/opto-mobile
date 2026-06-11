// Domain contract for Connect community content-report operations.
//
// Implementations live in the data layer
// (`lib/features/connect/data/repositories/report_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/constants/connect_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/content_report_entity.dart';

/// Abstract contract for Connect community content-report operations.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class ReportRepository {
  /// Submits a content report on [postId] with the given [reason].
  ///
  /// Sets initial [status] to [ReportStatus.pending] (server-side default).
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on
  /// duplicate/RLS error.
  Future<ContentReportEntity> reportPost({
    required String postId,
    required ReportReason reason,
  });
}
