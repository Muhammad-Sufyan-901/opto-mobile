// Domain entity for a community content report.
//
// This is the pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.

import 'package:opto/core/constants/connect_enums.dart';

/// Immutable domain representation of a user-submitted content report.
///
/// Reports move through a moderation lifecycle tracked by [status]:
/// `pending` → `reviewed` → `actioned` or `dismissed`.
class ContentReportEntity {
  const ContentReportEntity({
    required this.id,
    required this.reporterId,
    required this.postId,
    required this.reason,
    required this.status,
  });

  /// Primary key (UUID).
  final String id;

  /// UUID of the user who filed the report — foreign key to `auth.users`.
  final String reporterId;

  /// UUID of the reported post — foreign key to `connect_posts`.
  final String postId;

  /// Categorised reason for the report.
  final ReportReason reason;

  /// Current moderation lifecycle status of the report.
  final ReportStatus status;

  ContentReportEntity copyWith({
    String? id,
    String? reporterId,
    String? postId,
    ReportReason? reason,
    ReportStatus? status,
  }) {
    return ContentReportEntity(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      postId: postId ?? this.postId,
      reason: reason ?? this.reason,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentReportEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          reporterId == other.reporterId &&
          postId == other.postId &&
          reason == other.reason &&
          status == other.status;

  @override
  int get hashCode => Object.hash(id, reporterId, postId, reason, status);
}
