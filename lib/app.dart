import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/config/app_info.dart';
import 'package:ids_elder_rehab_app/core/router/app_router.dart';
import 'package:ids_elder_rehab_app/core/themes/app_themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppInfo.appName,
      debugShowCheckedModeBanner: AppInfo.isDevelopment,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.5,
          minScaleFactor: 0.8,
          child: child!,
        );
      },
    );
  }
}
