// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/content_report_model.dart';
import 'package:opto/features/connect/domain/entities/content_report_entity.dart';

/// Maps [ContentReportModel] to the pure-Dart [ContentReportEntity] used in
/// the domain and presentation layers.
extension ContentReportModelX on ContentReportModel {
  ContentReportEntity toEntity() => ContentReportEntity(
        id: id,
        reporterId: reporterId,
        postId: postId,
        reason: reason,
        status: status,
      );
}
