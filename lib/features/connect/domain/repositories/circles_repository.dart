// Domain contract for Connect community circles operations.
//
// Implementations live in the data layer
// (`lib/features/connect/data/repositories/circles_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/circle_entity.dart';

/// Abstract contract for Connect community circles operations.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps them
/// to error states.
abstract class CirclesRepository {
  /// Returns all circles with current-user membership status.
  ///
  /// Throws [ServerFailure] on network/RLS error.
  Future<List<CircleEntity>> getCircles();

  /// Returns a single circle by its [slug] (= posts.topic value).
  ///
  /// Throws [ServerFailure] when the circle is not found or on network error.
  Future<CircleEntity> getCircle(String slug);

  /// Joins the authenticated user to the circle with [circleId].
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on RLS/error.
  Future<void> joinCircle(String circleId);

  /// Removes the authenticated user from the circle with [circleId].
  ///
  /// Throws [AuthFailure] when unauthenticated, [ServerFailure] on RLS/error.
  Future<void> leaveCircle(String circleId);
}
