// Domain contract for anthropometric data operations.
//
// 🔒 SENSITIVE: all operations are owner-scoped (RLS enforced by Postgres).
// Never import or call from community, map, or catalog code paths.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/anthropometric_entity.dart';

/// Repository contract for the `anthropometric_data` table.
///
/// Implementations must scope all operations to the currently authenticated
/// user — [SupabaseClient.auth.currentUser.id].
abstract class AnthropometricRepository {
  /// Returns the current user's measurement record, or `null` if none exists.
  Future<AnthropometricEntity?> getMyAnthropometric();

  /// Creates or updates the current user's measurement record.
  ///
  /// [source] indicates whether measurements were self-entered or provided by
  /// an ocularist.
  Future<void> upsertAnthropometric({
    double? socketSizeMm,
    double? curvature,
    double? irisDiameterMm,
    String? matchedIrisHex,
    required DataSource source,
  });
}
