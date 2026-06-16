import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:opto/core/accessibility/haptic_controller.dart';
import 'package:opto/core/config/app_info.dart';
import 'package:opto/core/voice/aura_tts.dart';
import 'package:opto/core/voice/voice_controller.dart';
import 'package:opto/core/constants/app_theme_mode.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/router/app_router.dart';
import 'package:opto/core/router/deep_link_handler.dart';
import 'package:opto/core/themes/app_themes.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Start the feature deep-link listener. Auth callbacks are handled by
    // main.dart's _initDeepLinks(); this handles everything else.
    DeepLinkHandler.start(appRouter);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // GetIt owns both lifecycles; BlocProvider.value exposes without closing.
        BlocProvider<AuthBloc>.value(value: sl<AuthBloc>()),
        BlocProvider<AccessibilitySettingsCubit>.value(
          value: sl<AccessibilitySettingsCubit>(),
        ),
      ],
      // Load settings when user signs in; reset to defaults when they sign out.
      child: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          state.mapOrNull(
            authenticated: (_) {
              final userId = Supabase.instance.client.auth.currentUser?.id;
              if (userId != null) {
                ctx.read<AccessibilitySettingsCubit>().loadForUser(userId);
              }
            },
            unauthenticated: (_) =>
                ctx.read<AccessibilitySettingsCubit>().resetToDefaults(),
          );
        },
        child: BlocBuilder<AccessibilitySettingsCubit, AccessibilitySettingsEntity>(
          builder: (context, settings) {
            // Keep HapticController in sync with user settings.
            sl<HapticController>().value = settings.hapticIntensity;
            // Keep VoiceController in sync with user's voice-enabled preference.
            sl<VoiceController>().setVoiceEnabled(settings.voiceEnabled);
            // Keep AuraTts in sync with spoken-guidance preference and rate.
            sl<AuraTts>().setEnabled(settings.spokenGuidanceEnabled);
            sl<AuraTts>().setRate(settings.speakingRate);

            final (ThemeData theme, ThemeData? dark, ThemeMode flutterMode) =
                switch (settings.theme) {
              AppThemeMode.system => (
                  AppThemes.lightTheme,
                  AppThemes.darkTheme,
                  ThemeMode.system,
                ),
              AppThemeMode.light =>
                (AppThemes.lightTheme, null, ThemeMode.light),
              AppThemeMode.dark =>
                (AppThemes.darkTheme, null, ThemeMode.dark),
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
                // Compose OS font-size with the user's in-app preference so
                // that neither is discarded. design_system.md §3 / §15.4:
                // honor MediaQuery.textScaler in the range 1.0–3.0.
                final double osScale =
                    MediaQuery.of(context).textScaler.scale(1.0);
                final double userScale = settings.textScale.clamp(1.0, 3.0);
                final double effectiveScale =
                    (osScale > userScale ? osScale : userScale).clamp(1.0, 3.0);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(effectiveScale),
                  ),
                  child: child!,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
