import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ids_elder_rehab_app/core/config/app_info.dart';

import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/middlewares/authentication_middleware.dart';
import 'package:ids_elder_rehab_app/core/middlewares/roles_middleware.dart';
import 'package:ids_elder_rehab_app/features/dev/presentation/screens/dev_screen.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/screens/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: AppRoutes.onboarding.path,

  // Global Guard Middleware to check if user is authenticated
  redirect: AuthenticationMiddleware.guard,
  routes: [
    // ==========================================
    // Onboarding Routes (Initial Screen that every user seen for the first time)
    // ==========================================
    GoRoute(
      path: AppRoutes.onboarding.path,
      name: AppRoutes.onboarding.name,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),

    // ==========================================
    // Developer Routes (For Widget Testing Purpose Only MUST NOT SHOWN IN PRODUCTION)
    // ==========================================
    if (AppInfo.isDevelopment)
      GoRoute(
        path: AppRoutes.developer.path,
        name: AppRoutes.developer.name,
        builder: (BuildContext context, GoRouterState state) {
          return const DevScreen();
        },
      ),

    // ==========================================
    // Authentication Routes (Public)
    // ==========================================
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          body: Center(
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.login.path,
          name: AppRoutes.login.name,
          builder: (BuildContext context, GoRouterState state) {
            final String? errorMessage = state.uri.queryParameters['error'];

            return Scaffold(
              body: Center(
                child: Text(errorMessage ?? 'Login'),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.register.path,
          name: AppRoutes.register.name,
          builder: (BuildContext context, GoRouterState state) {
            final String? errorMessage = state.uri.queryParameters['error'];

            return Scaffold(
              body: Center(
                child: Text(errorMessage ?? 'Register'),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.forgotPassword.path,
          name: AppRoutes.forgotPassword.name,
          builder: (BuildContext context, GoRouterState state) {
            final String? errorMessage = state.uri.queryParameters['error'];

            return Scaffold(
              body: Center(
                child: Text(errorMessage ?? 'Forgot Password'),
              ),
            );
          },
        ),
      ],
    ),

    // ==========================================
    // Doctor Routes (Protected only for doctor)
    // ==========================================
    ShellRoute(
      // Role-based middleware to protect "doctor only" routes
      redirect: (BuildContext context, GoRouterState state) {
        return RolesMiddleware.requireRole(
          context,
          state,
          allowedRole: 'doctor',
        );
      },
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          body: Center(
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.doctorDashboard.path,
          name: AppRoutes.doctorDashboard.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(
                child: Text('Doctor Dashboard'),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.doctorAssessment.path,
          name: AppRoutes.doctorAssessment.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(
                child: Text('Doctor Assessment'),
              ),
            );
          },
        ),
      ],
    ),
    // Handle direct access to doctor route prefix (e.g. /doctor)
    GoRoute(
      path: AppRoutes.doctorRoutePrefix,
      redirect: (BuildContext context, GoRouterState state) {
        return AppRoutes.doctorDashboard.path;
      },
    ),

    // ==========================================
    // Caregiver Routes (Protected only for caregiver)
    // ==========================================
    ShellRoute(
      // Role-based middleware to protect "caregiver only" routes
      redirect: (BuildContext context, GoRouterState state) {
        return RolesMiddleware.requireRole(
          context,
          state,
          allowedRole: 'caregiver',
        );
      },
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          body: Center(
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.caregiverDashboard.path,
          name: AppRoutes.caregiverDashboard.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(
                child: Text('Caregiver Dashboard'),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.caregiverAssessment.path,
          name: AppRoutes.caregiverAssessment.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(
                child: Text('Caregiver Assessment'),
              ),
            );
          },
        ),
      ],
    ),
    // Handle direct access to caregiver route prefix (e.g. /caregiver)
    GoRoute(
      path: AppRoutes.caregiverRoutePrefix,
      redirect: (BuildContext context, GoRouterState state) {
        return AppRoutes.caregiverDashboard.path;
      },
    ),

    // ==========================================
    // Lansia Routes (Protected only for lansia)
    // ==========================================
    ShellRoute(
      // Role-based middleware to protect "lansia only" routes
      redirect: (BuildContext context, GoRouterState state) {
        return RolesMiddleware.requireRole(
          context,
          state,
          allowedRole: 'lansia',
        );
      },
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(
          body: Center(
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.lansiaDashboard.path,
          name: AppRoutes.lansiaDashboard.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(
                child: Text('Lansia Dashboard'),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.lansiaAssessment.path,
          name: AppRoutes.lansiaAssessment.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(
                child: Text('Lansia Assessment'),
              ),
            );
          },
        ),
      ],
    ),
    // Handle direct access to lansia route prefix (e.g. /lansia)
    GoRoute(
      path: AppRoutes.lansiaRoutePrefix,
      redirect: (BuildContext context, GoRouterState state) {
        return AppRoutes.lansiaDashboard.path;
      },
    ),

    // ==========================================
    // Other Routes goes here
    // ==========================================
  ],
);
