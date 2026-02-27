import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/di/dependencies_injection_container.dart' as deps_container;

Future<void> main() async {
  // Widgets Binding (Ensure Flutter is initialized)
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // GetIt Dependencies Injection Container (Used to inject dependencies like Bloc, Repository, Data Source, etc)
  deps_container.init();

  // App Bootstraping (Run the app)
  runApp(const App());
}
