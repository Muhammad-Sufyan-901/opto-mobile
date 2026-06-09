// Domain contract for accessibility settings — `accessibility_settings` table.
//
// Implementations live in the data layer
// (`lib/features/profile/data/repositories/accessibility_settings_repository_impl.dart`).
//
// NOTE: No Supabase or infrastructure imports — domain layer stays pure Dart.
import 'package:opto/features/profile/domain/entities/accessibility_settings_entity.dart';

/// Abstract contract for `accessibility_settings` table operations.
///
/// The implementation adds a Hive cache layer so the app can read the last
/// known settings instantly at boot before any network request completes.
///
/// Methods throw [Failure] subclasses on error; the BLoC catches and maps
/// them to error states.
abstract class AccessibilitySettingsRepository {
  /// Fetches the settings row for [userId] from Supabase.
  ///
  /// Throws [ServerFailure] when the row does not exist or on network / RLS
  /// error.  Consider calling [getCachedSettings] first for instant reads.
  Future<AccessibilitySettingsEntity> getSettings(String userId);

  /// Upserts (insert-or-update) the settings row in Supabase and caches the
  /// result locally via [cacheSettings].
  ///
  /// Throws [ServerFailure] on RLS violation or network error.
  Future<void> upsertSettings(AccessibilitySettingsEntity settings);

  /// Returns the most recently cached settings from Hive without a network
  /// call.  Returns `null` if no cached value exists yet.
  ///
  /// Useful for bootstrapping theme / haptic settings before the async
  /// Supabase fetch resolves.
  AccessibilitySettingsEntity? getCachedSettings();

  /// Persists [settings] to the local Hive cache (no network call).
  ///
  /// Called automatically by [upsertSettings] and [getSettings] to keep the
  /// cache current.  May also be called directly if the app needs to persist
  /// an optimistic update before the server confirms.
  void cacheSettings(AccessibilitySettingsEntity settings);
}
