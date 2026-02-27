import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/screens/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding.path,
  debugLogDiagnostics: true,
  routes: [
    // Onboarding Routes
    GoRoute(
      path: AppRoutes.onboarding.path,
      name: AppRoutes.onboarding.name,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Auth Routes
    GoRoute(
      path: AppRoutes.login.path,
      name: AppRoutes.login.name,
      builder: (context, state) => const Scaffold(),
    ),
    GoRoute(
      path: AppRoutes.register.path,
      name: AppRoutes.register.name,
      builder: (context, state) => const Scaffold(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword.path,
      name: AppRoutes.forgotPassword.name,
      builder: (context, state) => const Scaffold(),
    ),

    // Other Routes goes here
  ],
);
