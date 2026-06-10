import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/hive_client.dart';
import 'core/constants/app_env_keys.dart';
import 'core/di/dependencies_injection_container.dart' as deps_container;

Future<void> main() async {
  // Widgets Binding (Ensure Flutter is initialized)
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID', null);

  // Supabase Client (Backend — PostgREST, Auth, Storage, Realtime)
  // The anon key is safe to hold here; RLS controls row-level access.
  // Service-role keys must NEVER appear in the Flutter app.
  await Supabase.initialize(
    url: dotenv.env[AppEnvKeys.supabaseUrl] ?? '',
    // ignore: deprecated_member_use
    // publishableKey is the new name for anonKey in supabase_flutter >= 2.14.
    // This comment can be removed once the upstream API stabilises.
    publishableKey: dotenv.env[AppEnvKeys.supabasePublishableKey] ?? '',
    debug: false,
  );

  // Hive Client (Local Database — offline cache)
  await HiveClient.init();

  // GetIt Dependencies Injection Container (Used to inject dependencies like Bloc, Repository, Data Source, etc)
  await deps_container.init();

  // App Bootstraping (Run the app)
  runApp(const App());
}
