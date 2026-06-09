import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/config/secure_storage_config.dart';
import 'package:opto/core/theme/theme_cubit.dart';
import 'package:opto/core/utils/secure_storage_helper.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // ===============================================================
  // CORE LAYERS
  // ===============================================================

  // Theme — persisted to the 'settings_box' opened by HiveClient.init().
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(Hive.box('settings_box')),
  );

  // Supabase client — initialized in main.dart before this runs.
  // Repositories depend on this; widgets must never call it directly.
  sl.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // FlutterSecureStorage — biometric/session gate (kept post-Supabase migration
  // to store the local biometric-unlock flag alongside Supabase's own session).
  sl.registerLazySingleton(
    () => SecureStorageConfig.instance,
  );

  // SecureStorage Helper
  sl.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(sl()),
  );
}
