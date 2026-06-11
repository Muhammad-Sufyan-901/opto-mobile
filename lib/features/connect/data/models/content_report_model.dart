// Freezed + json_serializable DTO for the `content_reports` Supabase table.
//
// Mirrors the row shape defined in `database_schema.md` §4 CONNECT.content_reports.
// All DB columns are snake_case; Dart fields are camelCase via [@JsonKey].
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:opto/core/constants/connect_enums.dart';

part 'content_report_model.freezed.dart';
part 'content_report_model.g.dart';

// =============================================================================
// JSON CONVERTERS
// =============================================================================

/// Converts between [ReportReason] and the lowercase string stored in Postgres.
class _ReportReasonConverter implements JsonConverter<ReportReason, String?> {
  const _ReportReasonConverter();

  @override
  ReportReason fromJson(String? json) => ReportReason.fromString(json);

  @override
  String toJson(ReportReason r) => r.dbValue;
}

/// Converts between [ReportStatus] and the lowercase string stored in Postgres.
class _ReportStatusConverter implements JsonConverter<ReportStatus, String?> {
  const _ReportStatusConverter();

  @override
  ReportStatus fromJson(String? json) => ReportStatus.fromString(json);

  @override
  String toJson(ReportStatus s) => s.dbValue;
}

// =============================================================================
// MODEL
// =============================================================================

/// Data-layer representation of a row in the `content_reports` table.
///
/// Use [ContentReportModel.fromJson] to deserialise a Supabase response map.
/// The matching domain entity lives in
/// `lib/features/connect/domain/entities/content_report_entity.dart`.
@freezed
abstract class ContentReportModel with _$ContentReportModel {
  const factory ContentReportModel({
    /// Primary key (UUID).
    required String id,

    /// FK → `profiles.id` — the user who filed the report.
    @JsonKey(name: 'reporter_id') required String reporterId,

    /// FK → `posts.id` — the reported post.
    @JsonKey(name: 'post_id') required String postId,

    /// The reason the reporter chose when submitting.
    @_ReportReasonConverter() required ReportReason reason,

    /// Current moderation lifecycle status (default: pending).
    @_ReportStatusConverter() required ReportStatus status,
  }) = _ContentReportModel;

  /// Deserialises a Supabase / JSON map to a [ContentReportModel].
  factory ContentReportModel.fromJson(Map<String, dynamic> json) =>
      _$ContentReportModelFromJson(json);
}
