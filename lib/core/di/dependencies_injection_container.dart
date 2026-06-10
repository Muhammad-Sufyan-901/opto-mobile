import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/config/secure_storage_config.dart';
import 'package:opto/core/utils/secure_storage_helper.dart';
import 'package:opto/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:opto/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:opto/features/auth/domain/repositories/auth_repository.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:opto/features/profile/data/repositories/accessibility_settings_repository_impl.dart';
import 'package:opto/features/profile/data/repositories/caregiver_link_repository_impl.dart';
import 'package:opto/features/profile/data/repositories/emergency_contact_repository_impl.dart';
import 'package:opto/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:opto/features/profile/domain/repositories/accessibility_settings_repository.dart';
import 'package:opto/features/profile/domain/repositories/caregiver_link_repository.dart';
import 'package:opto/features/profile/domain/repositories/emergency_contact_repository.dart';
import 'package:opto/features/profile/domain/repositories/profile_repository.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // ===============================================================
  // CORE LAYERS
  // ===============================================================

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

  // ===============================================================
  // DATA SOURCES (leaf dependencies — no state)
  // ===============================================================

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  // ===============================================================
  // REPOSITORIES (depend on data sources)
  // ===============================================================

  sl.registerLazySingleton<AccessibilitySettingsRepository>(
    () => AccessibilitySettingsRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
      settingsBox: Hive.box('settings_box'),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<EmergencyContactRepository>(
    () => EmergencyContactRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<CaregiverLinkRepository>(
    () => CaregiverLinkRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorage: sl<SecureStorageHelper>(),
      settingsRepository: sl<AccessibilitySettingsRepository>(),
    ),
  );

  // ===============================================================
  // BLOCS / CUBITS (depend on repositories)
  // ===============================================================

  sl.registerLazySingleton<AccessibilitySettingsCubit>(
    () => AccessibilitySettingsCubit(sl<AccessibilitySettingsRepository>()),
  );

  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(sl<AuthRepository>()),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(sl<ProfileRepository>()),
  );
}
