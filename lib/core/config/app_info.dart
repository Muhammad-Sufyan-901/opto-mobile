import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvironmentMode { development, production }

class AppInfo {
  static String get appName => dotenv.env['APP_NAME'] ?? 'IDS Elder Rehab';
  static String get appDescription => dotenv.env['APP_DESCRIPTION'] ?? '';

  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static String get appBuildNumber => dotenv.env['APP_BUILD_NUMBER'] ?? '1';
  static String get appBuildVersion => '$appVersion+$appBuildNumber';

  static EnvironmentMode get environment {
    final String? envString = dotenv.env['APP_ENV_MODE']?.toLowerCase();

    if (envString == 'production') {
      return EnvironmentMode.production;
    }

    return EnvironmentMode.development;
  }

  static bool get isDevelopment => environment == EnvironmentMode.development;
  static bool get isProduction => environment == EnvironmentMode.production;
}
