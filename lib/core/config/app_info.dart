import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:opto/core/constants/app_env_keys.dart';

enum EnvironmentMode { development, production }

class AppInfo {
  @visibleForTesting
  static EnvironmentMode? mockEnvironment;

  static String get appName =>
      dotenv.env[AppEnvKeys.appName] ?? 'IDS Elder Rehab';
  static String get appDescription =>
      dotenv.env[AppEnvKeys.appDescription] ?? '';

  static String get appVersion => dotenv.env[AppEnvKeys.appVersion] ?? '1.0.0';
  static String get appBuildNumber =>
      dotenv.env[AppEnvKeys.appBuildNumber] ?? '1';
  static String get appBuildVersion => '$appVersion+$appBuildNumber';

  static EnvironmentMode get environment {
    if (mockEnvironment != null) {
      return mockEnvironment!;
    }

    // If not mocked, read from .env
    final String? envString = dotenv.env[AppEnvKeys.appEnvMode]?.toLowerCase();

    if (envString == 'production') {
      return EnvironmentMode.production;
    }

    return EnvironmentMode.development;
  }

  static bool get isDevelopment => environment == EnvironmentMode.development;
  static bool get isProduction => environment == EnvironmentMode.production;
}
