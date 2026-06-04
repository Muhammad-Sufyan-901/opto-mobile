import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:ids_elder_rehab_app/core/config/api_client.dart';
import 'package:ids_elder_rehab_app/core/config/secure_storage_config.dart';
import 'package:ids_elder_rehab_app/core/theme/theme_cubit.dart';
import 'package:ids_elder_rehab_app/core/utils/secure_storage_helper.dart';

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

  // Register ApiClient as LazySingleton
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl()),
  );

  // Register Dio as LazySingleton
  sl.registerLazySingleton(
    () => sl<ApiClient>().dio,
  );

  // Register FlutterSecureStorage
  sl.registerLazySingleton(
    () => SecureStorageConfig.instance,
  );

  // Register SecureStorage Helper
  sl.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(sl()),
  );
}
