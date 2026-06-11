// Domain contract for Connect community follow operations.
//
// Implementations live in the data layer
// (`lib/features/connect/data/repositories/follow_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/constants/connect_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/follow_entity.dart';

/// Abstract contract for Connect community follow/unfollow operations.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class FollowRepository {
  /// Returns all follow records for the current user (as follower).
  Future<List<FollowEntity>> getFollows();

  /// Creates a follow from the current user to [targetId] with the given [type].
  ///
  /// Throws [ServerFailure] on duplicate (unique constraint) or RLS error.
  Future<FollowEntity> follow({
    required String targetId,
    required FollowType type,
  });

  /// Removes the follow from the current user to [targetId].
  ///
  /// Throws [ServerFailure] if not found.
  Future<void> unfollow({required String targetId});
}
