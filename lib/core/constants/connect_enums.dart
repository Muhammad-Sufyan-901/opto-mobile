/// Typed enums for the Connect (Community) feature.
///
/// These mirror the corresponding Postgres enums defined in the database schema
/// for the `connect` module. Use these instead of bare strings for any business
/// logic, RLS-aware repositories, or BLoC state that branches on follow types,
/// report reasons, or report status values.
library;

/// Whether a follow relationship targets a topic tag or another user.
enum FollowType {
  topic,
  people;

  /// Parses a raw string value (e.g. from Supabase) to a [FollowType].
  /// Returns [FollowType.topic] as the safe fallback for unknown values.
  static FollowType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'topic':
        return FollowType.topic;
      case 'people':
        return FollowType.people;
      default:
        return FollowType.topic;
    }
  }

  /// Returns the canonical lowercase string used in RLS policies and storage.
  String get value => name;

  /// Canonical DB string — alias for [value] for consistency with other DB-mapped enums.
  String get dbValue => value;
}

/// The reason a user has reported a piece of community content.
enum ReportReason {
  spam,
  harassment,
  misinformation,
  inappropriate,
  other;

  /// Parses a raw string value (e.g. from Supabase) to a [ReportReason].
  /// Returns [ReportReason.other] as the safe fallback for unknown values.
  static ReportReason fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'spam':
        return ReportReason.spam;
      case 'harassment':
        return ReportReason.harassment;
      case 'misinformation':
        return ReportReason.misinformation;
      case 'inappropriate':
        return ReportReason.inappropriate;
      case 'other':
        return ReportReason.other;
      default:
        return ReportReason.other;
    }
  }

  /// Returns the canonical lowercase string used in RLS policies and storage.
  String get value => name;

  /// Canonical DB string — alias for [value] for consistency with other DB-mapped enums.
  String get dbValue => value;
}

/// The moderation lifecycle status of a community content report.
enum ReportStatus {
  pending,
  reviewed,
  actioned,
  dismissed;

  /// Parses a raw string value (e.g. from Supabase) to a [ReportStatus].
  /// Returns [ReportStatus.pending] as the safe fallback for unknown values.
  static ReportStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return ReportStatus.pending;
      case 'reviewed':
        return ReportStatus.reviewed;
      case 'actioned':
        return ReportStatus.actioned;
      case 'dismissed':
        return ReportStatus.dismissed;
      default:
        return ReportStatus.pending;
    }
  }

  /// Returns the canonical lowercase string used in RLS policies and storage.
  String get value => name;

  /// Canonical DB string — alias for [value] for consistency with other DB-mapped enums.
  String get dbValue => value;
}
