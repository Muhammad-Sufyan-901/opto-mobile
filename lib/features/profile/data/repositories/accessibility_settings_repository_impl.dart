// Concrete implementation of [AccessibilitySettingsRepository].
//
// Delegates to [ProfileRemoteDataSource] for Supabase calls and adds a
// Hive cache layer for instant boot reads (no network round-trip required for
// loading theme + haptic prefs before the first frame).
import 'package:hive/hive.dart';

import 'package:opto/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:opto/features/profile/data/models/accessibility_settings_model.dart';
import 'package:opto/features/profile/data/models/accessibility_settings_model_ext.dart';
import 'package:opto/features/profile/domain/entities/accessibility_settings_entity.dart';
import 'package:opto/features/profile/domain/repositories/accessibility_settings_repository.dart';

/// Production implementation of [AccessibilitySettingsRepository] with
/// a Hive write-through cache.
///
/// Failures that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class AccessibilitySettingsRepositoryImpl
    implements AccessibilitySettingsRepository {
  AccessibilitySettingsRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required Box<dynamic> settingsBox,
  })  : _remote = remoteDataSource,
        _box = settingsBox;

  final ProfileRemoteDataSource _remote;

  /// The Hive box opened by [HiveClient.init()] under the name `settings_box`.
  final Box<dynamic> _box;

  /// Key used to store / retrieve the serialised settings map inside [_box].
  static const _cacheKey = 'cached_accessibility_settings';

  // ── remote reads ───────────────────────────────────────────────────────────

  @override
  Future<AccessibilitySettingsEntity> getSettings(String userId) async {
    final model = await _remote.getSettings(userId);
    final entity = model.toEntity();
    cacheSettings(entity); // write-through
    return entity;
  }

  // ── remote writes ──────────────────────────────────────────────────────────

  @override
  Future<void> upsertSettings(AccessibilitySettingsEntity settings) async {
    final model = AccessibilitySettingsModel(
      userId: settings.userId,
      theme: settings.theme,
      textScale: settings.textScale,
      fontFamily: settings.fontFamily,
      hapticIntensity: settings.hapticIntensity,
      voiceEnabled: settings.voiceEnabled,
      hotwordEnabled: settings.hotwordEnabled,
      updatedAt: settings.updatedAt,
    );
    await _remote.upsertSettings(model);
    cacheSettings(settings); // keep cache in sync after successful write
  }

  // ── local cache ────────────────────────────────────────────────────────────

  @override
  AccessibilitySettingsEntity? getCachedSettings() {
    final raw = _box.get(_cacheKey);
    if (raw == null) return null;
    try {
      final json = Map<String, dynamic>.from(raw as Map);
      return AccessibilitySettingsModel.fromJson(json).toEntity();
    } catch (_) {
      // Corrupt cache — treat as absent.
      return null;
    }
  }

  @override
  void cacheSettings(AccessibilitySettingsEntity settings) {
    final model = AccessibilitySettingsModel(
      userId: settings.userId,
      theme: settings.theme,
      textScale: settings.textScale,
      fontFamily: settings.fontFamily,
      hapticIntensity: settings.hapticIntensity,
      voiceEnabled: settings.voiceEnabled,
      hotwordEnabled: settings.hotwordEnabled,
      updatedAt: settings.updatedAt,
    );
    _box.put(_cacheKey, model.toJson());
  }

  @override
  Future<void> clearCache() async {
    await _box.delete(_cacheKey);
  }
}
