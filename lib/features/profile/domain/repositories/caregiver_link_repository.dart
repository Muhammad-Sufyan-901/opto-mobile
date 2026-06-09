// Domain contract for caregiver links — `caregiver_links` table.
//
// Implementations live in the data layer
// (`lib/features/profile/data/repositories/caregiver_link_repository_impl.dart`).
//
// SECURITY NOTE: `caregiver_links` is owner-only (RLS).  Caregiver IDs must
// never appear in community, map, or catalog surfaces.
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/features/profile/domain/entities/caregiver_link_entity.dart';

/// Abstract contract for `caregiver_links` table operations.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps
/// them to error states.
abstract class CaregiverLinkRepository {
  /// Returns all caregiver-link rows where [userId] appears as either the
  /// primary user (`user_id`) or the caregiver (`caregiver_id`).
  ///
  /// Throws [ServerFailure] on network or RLS error.
  Future<List<CaregiverLinkEntity>> getLinksForUser(String userId);

  /// Creates a new caregiver-link row with status [LinkStatus.pending].
  ///
  /// The invitation must be accepted by the caregiver via [updateLinkStatus].
  /// Throws [ServerFailure] on duplicate link or RLS violation.
  Future<void> requestLink({
    required String userId,
    required String caregiverId,
  });

  /// Updates the [status] of the link identified by [linkId].
  ///
  /// Typically used to accept ([LinkStatus.active]) or revoke
  /// ([LinkStatus.revoked]) an invitation.
  /// Throws [ServerFailure] if the link does not exist or on RLS violation.
  Future<void> updateLinkStatus(String linkId, LinkStatus status);
}
