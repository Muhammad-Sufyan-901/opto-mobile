import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/config/app_info.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/router/app_router.dart';
import 'package:opto/core/theme/theme_cubit.dart';
import 'package:opto/core/themes/app_themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider.value: GetIt owns the lifecycle — BlocProvider just
    // exposes it to the widget tree without closing it on unmount.
    return BlocProvider<ThemeCubit>.value(
      value: sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, mode) {
          // Resolve Material theme config from the Opto AppThemeMode.
          final (ThemeData theme, ThemeData? dark, ThemeMode flutterMode) =
              switch (mode) {
            AppThemeMode.system => (
                AppThemes.lightTheme,
                AppThemes.darkTheme,
                ThemeMode.system,
              ),
            AppThemeMode.light => (AppThemes.lightTheme, null, ThemeMode.light),
            AppThemeMode.dark => (AppThemes.darkTheme, null, ThemeMode.dark),
            AppThemeMode.highContrast => (
                AppThemes.highContrastTheme,
                null,
                ThemeMode.light,
              ),
          };

          return MaterialApp.router(
            title: AppInfo.appName,
            debugShowCheckedModeBanner: AppInfo.isDevelopment,
            theme: theme,
            darkTheme: dark,
            themeMode: flutterMode,
            routerConfig: appRouter,
            builder: (BuildContext context, Widget? child) {
              // Honor 300% text scaling with reflow (design system §3 / §15.4).
              // minScaleFactor: 1.0 ensures we never scale below the authored size.
              return MediaQuery.withClampedTextScaling(
                minScaleFactor: 1.0,
                maxScaleFactor: 3.0,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
