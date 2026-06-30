import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:opto/core/config/app_info.dart';
import 'package:opto/core/constants/app_env_keys.dart';

/// Configuration helper for the Vision AI ("Aura") scene-description feature.
///
/// Single source of truth for the free/paid tier gate. All cloud-scene-
/// description decisions in the data layer funnel through [cloudSceneAllowed]
/// rather than re-reading env variables at call sites.
///
/// ## Tier semantics
///
/// | [SCENE_DESCRIBE_TIER] | Build / Environment           | [cloudSceneAllowed] |
/// |------------------------|-------------------------------|---------------------|
/// | `paid`                 | any                           | `true`              |
/// | `free` (default)       | debug build (`flutter run`)   | `true`              |
/// | `free` (default)       | `APP_ENV_MODE=development`    | `true`              |
/// | `free` (default)       | release build + production    | `false`             |
///
/// **Why:** Gemini's free tier trains on submitted inputs and outputs, which
/// violates UU PDP for real user camera frames. On the free plan, cloud scene
/// description is limited to development/debug builds (non-real-user data).
///
/// ## Testing
///
/// Override [mockCloudSceneAllowed] in unit tests to control the gate without
/// touching the environment:
/// ```dart
/// VisionAiConfig.mockCloudSceneAllowed = true;
/// addTearDown(() => VisionAiConfig.mockCloudSceneAllowed = null);
/// ```
class VisionAiConfig {
  VisionAiConfig._();

  // ---------------------------------------------------------------------------
  // Test override — mirrors AppInfo.mockEnvironment pattern.
  // ---------------------------------------------------------------------------

  @visibleForTesting
  static bool? mockCloudSceneAllowed;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// `true` when the [SCENE_DESCRIBE_TIER] env variable is set to `'paid'`.
  /// Defaults to `false` (free tier) when the variable is absent or blank.
  ///
  /// Strips surrounding quotes defensively — dotenv v6 normally strips them,
  /// but this guards against edge cases where the raw value is `"paid"` or
  /// `'paid'` (with quotes) rather than `paid`.
  static bool get isFreeTier {
    final raw = dotenv.env[AppEnvKeys.sceneDescribeTier];
    if (raw == null) return true;
    final tier = raw.toLowerCase().trim().replaceAll('"', '').replaceAll("'", '');
    return tier != 'paid';
  }

  /// `true` when the app is permitted to call the cloud scene-description
  /// Edge Function.
  ///
  /// Allowed when:
  /// - The tier is explicitly `paid` (billing-enabled key), OR
  /// - The tier is `free` AND the app is running in a development build
  ///   (i.e. [AppInfo.isDevelopment] is `true` because `APP_ENV_MODE=development`
  ///   is set in `.env`), OR
  /// - The app is a debug build ([kDebugMode] is `true`).
  ///
  /// The [kDebugMode] branch acts as a safety net for developers: `flutter run`
  /// always produces a debug binary regardless of the `.env` `APP_ENV_MODE`
  /// string, so this ensures the cloud path is always reachable during local
  /// development even if the `.env` asset is stale or misconfigured.
  ///
  /// In release builds ([kReleaseMode]) this falls back to the tier/env check,
  /// so production + free tier still returns `false` — no real user camera
  /// frames are ever sent to the free Gemini plan in a shipped APK/IPA.
  static bool get cloudSceneAllowed {
    if (mockCloudSceneAllowed != null) return mockCloudSceneAllowed!;
    return !isFreeTier || AppInfo.isDevelopment || kDebugMode;
  }
}
