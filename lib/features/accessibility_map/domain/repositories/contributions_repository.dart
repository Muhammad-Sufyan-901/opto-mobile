// Domain contract for the poi_contributions repository.
//
// Verification and suggest-edit actions insert a [poi_contributions] row.
// The verified_count increment on accessibility_pois is handled server-side
// (trigger/RPC) — the client MUST NOT directly update that column because
// there is no documented update RLS policy.
import 'package:opto/features/accessibility_map/domain/entities/poi_contribution_entity.dart';

/// Contract for submitting and reading POI contributions.
abstract class ContributionsRepository {
  const ContributionsRepository();

  // ── write ─────────────────────────────────────────────────────────────────

  /// Inserts a verification contribution for [poiId].
  ///
  /// [change] is `{}` for a plain verify; pass a non-empty map for
  /// suggest-edit contributions.
  ///
  /// [user_id] is stamped from `auth.currentUser.id` in the data source.
  /// [status] is always 'pending' on insert.
  Future<PoiContributionEntity> submitContribution({
    required String poiId,
    Map<String, dynamic> change = const {},
  });

  // ── read ──────────────────────────────────────────────────────────────────

  /// Returns all contribution rows for the current user (for history / P2 UI).
  Future<List<PoiContributionEntity>> getMyContributions();
}
