// Domain contract for profile CRUD operations on the `profiles` table.
//
// Implementations live in the data layer
// (`lib/features/profile/data/repositories/profile_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/features/profile/domain/entities/profile_entity.dart';

/// Abstract contract for `profiles` table operations.
///
/// Methods throw `Failure` subclasses on error; the BLoC catches and maps
/// them to error states.
abstract class ProfileRepository {
  /// Fetches the profile row for the given [userId].
  ///
  /// Throws `ServerFailure` when the row does not exist or when an RLS /
  /// network error occurs.
  Future<ProfileEntity> getProfile(String userId);

  /// Partially updates the `profiles` row for [userId].
  ///
  /// Only non-null parameters are written to the database — passing `null`
  /// for a field leaves it unchanged.
  ///
  /// Throws `ServerFailure` on RLS violation or network error.
  Future<void> updateProfile(
    String userId, {
    String? fullName,
    String? phone,
    VisionProfile? visionProfile,
    String? avatarUrl,
  });
}
