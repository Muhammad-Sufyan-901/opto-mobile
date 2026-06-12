import 'package:get_it/get_it.dart';
// Prosthetic Hub — Care Guides
import 'package:opto/features/prosthetic_hub/data/repositories/care_guides_repository_mock.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/care_guides_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/care_guides_cubit.dart';
// Prosthetic Hub — Order Supplies
import 'package:opto/features/prosthetic_hub/data/repositories/supplies_repository_mock.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/supplies_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/order_supplies_cubit.dart';
// Prosthetic Hub — Specialist
import 'package:opto/features/prosthetic_hub/data/repositories/specialist_repository_mock.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/specialist_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/specialist_directory_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/specialist_chat_cubit.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/accessibility/haptic_controller.dart';
import 'package:opto/core/config/secure_storage_config.dart';
import 'package:opto/core/utils/secure_storage_helper.dart';
import 'package:opto/core/voice/intent_parser.dart';
import 'package:opto/core/voice/speech_recognizer.dart';
import 'package:opto/core/voice/voice_controller.dart';
import 'package:opto/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:opto/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:opto/features/auth/domain/repositories/auth_repository.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/connect/data/datasources/connect_remote_data_source.dart';
import 'package:opto/features/consultation/data/datasources/consultation_remote_data_source.dart';
import 'package:opto/features/consultation/data/repositories/booking_repository_impl.dart';
import 'package:opto/features/consultation/data/repositories/consultation_history_repository_impl.dart';
import 'package:opto/features/consultation/data/repositories/doctor_directory_repository_impl.dart';
import 'package:opto/features/consultation/domain/repositories/booking_repository.dart';
import 'package:opto/features/consultation/domain/repositories/consultation_history_repository.dart';
import 'package:opto/features/consultation/domain/repositories/doctor_directory_repository.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_bloc.dart';
import 'package:opto/features/consultation/presentation/cubit/booking_cubit.dart';
import 'package:opto/features/consultation/presentation/cubit/consultation_history_cubit.dart';
import 'package:opto/features/consultation/presentation/cubit/eye_care_exercises_cubit.dart';
import 'package:opto/features/connect/data/repositories/connect_repository_impl.dart';
import 'package:opto/features/connect/data/repositories/follow_repository_impl.dart';
import 'package:opto/features/connect/data/repositories/report_repository_impl.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';
import 'package:opto/features/connect/domain/repositories/follow_repository.dart';
import 'package:opto/features/connect/domain/repositories/report_repository.dart';
import 'package:opto/features/connect/presentation/bloc/compose_post_bloc.dart';
import 'package:opto/features/connect/presentation/bloc/connect_feed_bloc.dart';
import 'package:opto/features/connect/presentation/cubit/post_thread_cubit.dart';
import 'package:opto/features/connect/presentation/cubit/report_cubit.dart';
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

  // HapticController — core-level haptic preference holder.
  // Kept in sync with AccessibilitySettingsCubit via app.dart.
  sl.registerLazySingleton<HapticController>(() => HapticController());

  // VoiceController — Aura Voice engine.
  // Kept in sync with AccessibilitySettingsCubit via app.dart (setVoiceEnabled).
  sl.registerLazySingleton<SpeechRecognizer>(() => SpeechToTextRecognizer());
  sl.registerLazySingleton<IntentParser>(() => const IntentParser());
  sl.registerLazySingleton<VoiceController>(
    () => VoiceController(
      recognizer: sl<SpeechRecognizer>(),
      parser: sl<IntentParser>(),
    ),
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

  // ===============================================================
  // ── CONNECT (COMMUNITY) ──
  // ===============================================================

  // Data Sources
  sl.registerLazySingleton<ConnectRemoteDataSource>(
    () => ConnectRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerFactory<ConnectRepository>(
    () => ConnectRepositoryImpl(
      remoteDataSource: sl<ConnectRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<FollowRepository>(
    () => FollowRepositoryImpl(
      remoteDataSource: sl<ConnectRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      remoteDataSource: sl<ConnectRemoteDataSource>(),
    ),
  );

  // BLoCs / Cubits — registerFactory so each screen gets a fresh instance
  // with its own Realtime subscription lifecycle.
  sl.registerFactory<ConnectFeedBloc>(
    () => ConnectFeedBloc(sl<ConnectRepository>()),
  );

  sl.registerFactory<ComposePostBloc>(
    () => ComposePostBloc(sl<ConnectRepository>()),
  );

  sl.registerFactory<PostThreadCubit>(
    () => PostThreadCubit(sl<ConnectRepository>()),
  );

  sl.registerFactory<ReportCubit>(
    () => ReportCubit(sl<ReportRepository>()),
  );

  // ===============================================================
  // ── CONSULTATION (HEALTH & CONSULTATION) ──
  // ===============================================================
  // Repos use registerLazySingleton (no Realtime channel this phase, unlike
  // connect which registers factories because it owns a Realtime channel
  // per bloc instance).
  // BLoCs/cubits use registerFactory — each pushed route gets a fresh instance.

  // Data Source
  sl.registerLazySingleton<ConsultationRemoteDataSource>(
    () => ConsultationRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<DoctorDirectoryRepository>(
    () => DoctorDirectoryRepositoryImpl(
      remoteDataSource: sl<ConsultationRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl<ConsultationRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ConsultationHistoryRepository>(
    () => ConsultationHistoryRepositoryImpl(
      remoteDataSource: sl<ConsultationRemoteDataSource>(),
    ),
  );

  // BLoCs / Cubits
  sl.registerFactory<DoctorSearchBloc>(
    () => DoctorSearchBloc(sl<DoctorDirectoryRepository>()),
  );

  sl.registerFactory<BookingCubit>(
    () => BookingCubit(sl<BookingRepository>()),
  );

  sl.registerFactory<ConsultationHistoryCubit>(
    () => ConsultationHistoryCubit(sl<ConsultationHistoryRepository>()),
  );

  sl.registerFactory<EyeCareExercisesCubit>(
    () => EyeCareExercisesCubit(sl<DoctorDirectoryRepository>()),
  );

  // ===============================================================
  // ── PROSTHETIC HUB ──
  // ===============================================================
  // Mock repos use registerLazySingleton (stateless — safe to share).
  // Cubits use registerFactory (fresh instance per pushed route).

  // Care Guides
  sl.registerLazySingleton<CareGuidesRepository>(
    () => const CareGuidesRepositoryMock(),
  );
  sl.registerFactory<CareGuidesCubit>(
    () => CareGuidesCubit(sl<CareGuidesRepository>()),
  );

  // Order Supplies
  sl.registerLazySingleton<SuppliesRepository>(
    () => const SuppliesRepositoryMock(),
  );
  sl.registerFactory<OrderSuppliesCubit>(
    () => OrderSuppliesCubit(sl<SuppliesRepository>()),
  );

  // Message My Specialist
  sl.registerLazySingleton<SpecialistRepository>(
    () => const SpecialistRepositoryMock(),
  );
  sl.registerFactory<SpecialistDirectoryCubit>(
    () => SpecialistDirectoryCubit(sl<SpecialistRepository>()),
  );
  sl.registerFactory<SpecialistChatCubit>(
    () => SpecialistChatCubit(),
  );
}
