abstract class AppEnvKeys {
  // App Info
  static const String appName = 'APP_NAME';
  static const String appVersion = 'APP_VERSION';
  static const String appBuildNumber = 'APP_BUILD_NUMBER';
  static const String appDescription = 'APP_DESCRIPTION';
  static const String appEnvMode = 'APP_ENV_MODE';

  // Supabase
  // Obtain from: Supabase Dashboard → Settings → API
  static const String supabaseUrl = 'SUPABASE_URL';
  static const String supabasePublishableKey = 'SUPABASE_PUBLISHABLE_KEY';

  // Vision AI — scene description tier
  // Values: 'free' (default) | 'paid'
  // 'free'  → cloud scene description is gated to development builds only
  //           (Gemini free tier trains on data; UU PDP compliance).
  // 'paid'  → cloud path enabled in all builds (billing-enabled key required).
  static const String sceneDescribeTier = 'SCENE_DESCRIBE_TIER';
}
