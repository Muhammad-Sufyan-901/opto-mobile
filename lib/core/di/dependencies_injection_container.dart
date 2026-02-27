import 'package:get_it/get_it.dart';
import 'package:ids_elder_rehab_app/core/config/api_client.dart';
import 'package:ids_elder_rehab_app/core/config/secure_storage_config.dart';
import 'package:ids_elder_rehab_app/core/utils/secure_storage_helper.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // ===============================================================
  // CORE LAYERS
  // ===============================================================

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
