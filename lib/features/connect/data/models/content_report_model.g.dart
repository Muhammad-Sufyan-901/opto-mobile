// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentReportModel _$ContentReportModelFromJson(
  Map<String, dynamic> json,
) => _ContentReportModel(
  id: json['id'] as String,
  reporterId: json['reporter_id'] as String,
  postId: json['post_id'] as String,
  reason: const _ReportReasonConverter().fromJson(json['reason'] as String?),
  status: const _ReportStatusConverter().fromJson(json['status'] as String?),
);

Map<String, dynamic> _$ContentReportModelToJson(_ContentReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporter_id': instance.reporterId,
      'post_id': instance.postId,
      'reason': const _ReportReasonConverter().toJson(instance.reason),
      'status': const _ReportStatusConverter().toJson(instance.status),
    };
