// Domain entity for a follow relationship in the Connect community.
//
// This is the pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.

import 'package:opto/core/constants/connect_enums.dart';

/// Immutable domain representation of a follow relationship.
///
/// A follow can target either a topic tag or another user, distinguished by
/// [type]. The composite primary key in the DB is `(follower_id, target_id, type)`.
class FollowEntity {
  const FollowEntity({
    required this.followerId,
    required this.targetId,
    required this.type,
  });

  /// UUID of the user who is following.
  final String followerId;

  /// UUID or tag slug being followed (user UUID for [FollowType.people];
  /// topic identifier for [FollowType.topic]).
  final String targetId;

  /// Whether this follow targets a topic tag or another user.
  final FollowType type;

  FollowEntity copyWith({
    String? followerId,
    String? targetId,
    FollowType? type,
  }) {
    return FollowEntity(
      followerId: followerId ?? this.followerId,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowEntity &&
          runtimeType == other.runtimeType &&
          followerId == other.followerId &&
          targetId == other.targetId &&
          type == other.type;

  @override
  int get hashCode => Object.hash(followerId, targetId, type);
}
