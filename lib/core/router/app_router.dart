import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ids_elder_rehab_app/core/config/app_info.dart';

import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/middlewares/authentication_middleware.dart';
import 'package:ids_elder_rehab_app/core/middlewares/roles_middleware.dart';
import 'package:ids_elder_rehab_app/features/dashboard/presentation/screens/lansia_dashboard_screen.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/screens/home_screen.dart';
import 'package:ids_elder_rehab_app/features/auth/presentation/screens/sign_in_hub_screen.dart';
import 'package:ids_elder_rehab_app/features/auth/presentation/screens/email_auth_screen.dart';
import 'package:ids_elder_rehab_app/features/auth/presentation/screens/phone_auth_screen.dart';
import 'package:ids_elder_rehab_app/features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:ids_elder_rehab_app/features/auth/presentation/screens/caregiver_setup_screen.dart';
import 'package:ids_elder_rehab_app/features/dev/presentation/screens/dev_screen.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/screens/vision_profile_screen.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/screens/display_setup_screen.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/screens/voice_setup_screen.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/screens/permissions_setup_screen.dart';
import 'package:ids_elder_rehab_app/features/consultation/presentation/screens/consult_screen.dart';
import 'package:ids_elder_rehab_app/features/prosthetic_hub/presentation/screens/prosthetic_hub_screen.dart';
import 'package:ids_elder_rehab_app/features/connect/presentation/screens/community_screen.dart';
import 'package:ids_elder_rehab_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ids_elder_rehab_app/features/setup/presentation/screens/setup_done_screen.dart';
import 'package:ids_elder_rehab_app/features/sos/presentation/screens/sos_active_screen.dart';
import 'package:ids_elder_rehab_app/features/vision_ai/presentation/screens/vision_ai_screen.dart';
import 'package:ids_elder_rehab_app/features/voice/presentation/screens/aura_voice_screen.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: AppRoutes.splash.path,

  // Global Guard Middleware to check if user is authenticated
  redirect: AuthenticationMiddleware.guard,
  routes: [
    // ==========================================
    // Brand & Welcome Routes (first-launch flow)
    // ==========================================
    GoRoute(
      path: AppRoutes.splash.path,
      name: AppRoutes.splash.name,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding.path,
      name: AppRoutes.onboarding.name,
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomeScreen();
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
    // Authentication Routes (Public — Opto sign-in hub + sub-flows)
    // ==========================================
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return child;
      },
      routes: [
        // 05 · Sign-in hub
        GoRoute(
          path: AppRoutes.login.path,
          name: AppRoutes.login.name,
          builder: (BuildContext context, GoRouterState state) {
            return const SignInHubScreen();
          },
        ),
        // 06 · Email & password
        GoRoute(
          path: AppRoutes.authEmail.path,
          name: AppRoutes.authEmail.name,
          builder: (BuildContext context, GoRouterState state) {
            return const EmailAuthScreen();
          },
        ),
        // 07 · Phone number
        GoRoute(
          path: AppRoutes.authPhone.path,
          name: AppRoutes.authPhone.name,
          builder: (BuildContext context, GoRouterState state) {
            return const PhoneAuthScreen();
          },
        ),
        // 08 · OTP verification
        GoRoute(
          path: AppRoutes.authOtp.path,
          name: AppRoutes.authOtp.name,
          builder: (BuildContext context, GoRouterState state) {
            final String phoneNumber =
                (state.extra is String) ? state.extra as String : '+62 …';
            return OtpVerifyScreen(phoneNumber: phoneNumber);
          },
        ),
        // 09 · Caregiver / assisted setup
        GoRoute(
          path: AppRoutes.authCaregiver.path,
          name: AppRoutes.authCaregiver.name,
          builder: (BuildContext context, GoRouterState state) {
            return const CaregiverSetupScreen();
          },
        ),
      ],
    ),

    // ==========================================
    // Onboarding & Setup Routes (screens 10–14)
    // Public while auth is stubbed — add token gating when SetupCubit lands.
    // ==========================================
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return child;
      },
      routes: [
        // 10 · Vision profile
        GoRoute(
          path: AppRoutes.setupVision.path,
          name: AppRoutes.setupVision.name,
          builder: (BuildContext context, GoRouterState state) {
            return const VisionProfileScreen();
          },
        ),
        // 11 · Text size & contrast
        GoRoute(
          path: AppRoutes.setupDisplay.path,
          name: AppRoutes.setupDisplay.name,
          builder: (BuildContext context, GoRouterState state) {
            return const DisplaySetupScreen();
          },
        ),
        // 12 · Voice & sound
        GoRoute(
          path: AppRoutes.setupVoice.path,
          name: AppRoutes.setupVoice.name,
          builder: (BuildContext context, GoRouterState state) {
            return const VoiceSetupScreen();
          },
        ),
        // 13 · Permissions
        GoRoute(
          path: AppRoutes.setupPermissions.path,
          name: AppRoutes.setupPermissions.name,
          builder: (BuildContext context, GoRouterState state) {
            return const PermissionsSetupScreen();
          },
        ),
        // 14 · All set
        GoRoute(
          path: AppRoutes.setupDone.path,
          name: AppRoutes.setupDone.name,
          builder: (BuildContext context, GoRouterState state) {
            return const SetupDoneScreen();
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
    // Handle direct access to lansia route prefix (e.g. /lansia) →
    // redirect to the new Opto Home screen (A-3 migration).
    GoRoute(
      path: AppRoutes.lansiaRoutePrefix,
      redirect: (BuildContext context, GoRouterState state) {
        return AppRoutes.home.path;
      },
    ),

    // ==========================================
    // Opto Home Dashboard (Screen 15)
    // Replaces the rehab-leftover LansiaDashboardScreen as the main
    // post-setup landing screen. See system_architecture.md A-3.
    // ==========================================
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),

    // ==========================================
    // Lansia Dashboard (Legacy — kept to avoid dangling references.
    // Unreachable from the main navigation flow. Remove as part of A-3.)
    // ==========================================
    GoRoute(
      path: AppRoutes.lansiaDashboard.path,
      name: AppRoutes.lansiaDashboard.name,
      builder: (BuildContext context, GoRouterState state) {
        return const LansiaDashboardScreen();
      },
    ),

    // ==========================================
    // Module Destination Routes (Screens 16–22)
    // ==========================================

    // Screen 16 — Vision AI
    GoRoute(
      path: AppRoutes.visionAi.path,
      name: AppRoutes.visionAi.name,
      builder: (BuildContext context, GoRouterState state) {
        return const VisionAiScreen();
      },
    ),

    // Screen 17 — Prosthetic Hub
    GoRoute(
      path: AppRoutes.prostheticHub.path,
      name: AppRoutes.prostheticHub.name,
      builder: (BuildContext context, GoRouterState state) {
        return const ProstheticHubScreen();
      },
    ),

    // Screen 18 — Consult
    GoRoute(
      path: AppRoutes.consult.path,
      name: AppRoutes.consult.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ConsultScreen(),
    ),

    // Screen 19 — Community
    GoRoute(
      path: AppRoutes.community.path,
      name: AppRoutes.community.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CommunityScreen(),
    ),

    // Screen 20 — Profile
    GoRoute(
      path: AppRoutes.profile.path,
      name: AppRoutes.profile.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
    ),

    // Screen 21 — Emergency SOS
    GoRoute(
      path: AppRoutes.sos.path,
      name: AppRoutes.sos.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SosActiveScreen(),
    ),

    // Screen 22 — Aura Voice
    GoRoute(
      path: AppRoutes.auraVoice.path,
      name: AppRoutes.auraVoice.name,
      builder: (BuildContext context, GoRouterState state) =>
          const AuraVoiceScreen(),
    ),

    // ==========================================
    // Other Routes goes here
    // ==========================================
  ],
);
