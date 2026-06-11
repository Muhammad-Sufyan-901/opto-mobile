// Pure-Dart domain entity for a POI contribution / verification.
//
// No serialisation dependencies — use [PoiContributionModel.toEntity()] in
// the data layer to produce instances from Supabase rows.

/// Immutable domain representation of a row in `poi_contributions`.
///
/// A contribution records a user's verify or suggest-edit action on a POI.
/// [status] is set to [ContributionStatus.pending] on insert; a moderator
/// (or server trigger) may later set it to approved/rejected.
///
/// [change] holds the suggested payload — for verify actions it is an empty
/// map `{}`; for suggest-edit it contains the proposed field updates.
class PoiContributionEntity {
  const PoiContributionEntity({
    required this.id,
    required this.poiId,
    required this.userId,
    required this.change,
    required this.status,
    this.createdAt,
  });

  /// Primary key (UUID).
  final String id;

  /// FK → `accessibility_pois.id`.
  final String poiId;

  /// FK → `profiles.id` (the contributing user).
  final String userId;

  /// Proposed changes jsonb. Empty map `{}` for a plain verify.
  final Map<String, dynamic> change;

  /// Moderation status — see [ContributionStatus].
  final String status;

  /// Row creation timestamp, nullable (optional from server).
  final DateTime? createdAt;

  PoiContributionEntity copyWith({
    String? id,
    String? poiId,
    String? userId,
    Map<String, dynamic>? change,
    String? status,
    DateTime? createdAt,
  }) {
    return PoiContributionEntity(
      id: id ?? this.id,
      poiId: poiId ?? this.poiId,
      userId: userId ?? this.userId,
      change: change ?? this.change,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoiContributionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
