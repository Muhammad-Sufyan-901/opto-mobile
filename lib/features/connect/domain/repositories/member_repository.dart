// Domain contract for Connect community member profile operations.
//
// Implementations live in the data layer
// (`lib/features/connect/data/repositories/member_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/member_profile_entity.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';

/// Abstract contract for Connect community member profile operations.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class MemberRepository {
  /// Returns the public profile + community stats for a member.
  ///
  /// Throws [ServerFailure] when the member is not found or on network error.
  Future<MemberProfileEntity> getMemberProfile(String memberId);

  /// Toggles follow state for [memberId]. Returns the new [isFollowedByMe] value.
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on RLS/error.
  Future<bool> toggleFollow(String memberId);

  /// Returns recent posts authored by [memberId], ordered by created_at desc.
  ///
  /// Throws [ServerFailure] on network/RLS error.
  Future<List<PostEntity>> getContributions(String memberId);
}
