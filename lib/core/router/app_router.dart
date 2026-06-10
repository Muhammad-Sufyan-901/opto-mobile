import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/config/app_info.dart';

import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/user_role.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/middlewares/authentication_middleware.dart';
import 'package:opto/core/middlewares/roles_middleware.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opto/features/home/presentation/screens/home_screen.dart';
import 'package:opto/features/auth/presentation/screens/sign_in_hub_screen.dart';
import 'package:opto/features/auth/presentation/screens/email_auth_screen.dart';
import 'package:opto/features/auth/presentation/screens/phone_auth_screen.dart';
import 'package:opto/features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:opto/features/auth/presentation/screens/caregiver_setup_screen.dart';
import 'package:opto/features/auth/presentation/screens/email_register_screen.dart';
import 'package:opto/features/dev/presentation/screens/dev_screen.dart';
import 'package:opto/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:opto/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:opto/features/setup/presentation/screens/vision_profile_screen.dart';
import 'package:opto/features/setup/presentation/screens/display_setup_screen.dart';
import 'package:opto/features/setup/presentation/screens/voice_setup_screen.dart';
import 'package:opto/features/setup/presentation/screens/permissions_setup_screen.dart';
import 'package:opto/features/consultation/presentation/screens/consult_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/prosthetic_hub_screen.dart';
import 'package:opto/features/connect/presentation/screens/community_screen.dart';
import 'package:opto/features/profile/presentation/screens/profile_screen.dart';
import 'package:opto/features/setup/presentation/screens/setup_done_screen.dart';
import 'package:opto/features/sos/presentation/screens/sos_active_screen.dart';
import 'package:opto/features/vision_ai/presentation/screens/vision_ai_screen.dart';
import 'package:opto/features/voice/presentation/screens/aura_voice_screen.dart';

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
        // 06b · Email register — create a new account
        GoRoute(
          path: AppRoutes.authRegister.path,
          name: AppRoutes.authRegister.name,
          builder: (BuildContext context, GoRouterState state) {
            return const EmailRegisterScreen();
          },
        ),
      ],
    ),

    // ==========================================
    // Onboarding & Setup Routes (screens 10–14)
    // ProfileBloc is scoped to this shell so VisionProfileScreen and
    // SetupDoneScreen share the same bloc instance.
    // ==========================================
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>(),
          child: child,
        );
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
    // Doctor Routes (Protected — doctor role only)
    // ==========================================
    ShellRoute(
      redirect: (BuildContext context, GoRouterState state) {
        return RolesMiddleware.requireRole(
          context,
          state,
          allowedRole: UserRole.doctor,
        );
      },
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(body: Center(child: child));
      },
      routes: [
        GoRoute(
          path: AppRoutes.doctorDashboard.path,
          name: AppRoutes.doctorDashboard.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(child: Text('Doctor Dashboard')),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.doctorAssessment.path,
          name: AppRoutes.doctorAssessment.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(child: Text('Doctor Assessment')),
            );
          },
        ),
      ],
    ),
    // Handle direct access to /doctor prefix
    GoRoute(
      path: AppRoutes.doctorRoutePrefix,
      redirect: (BuildContext context, GoRouterState state) {
        return AppRoutes.doctorDashboard.path;
      },
    ),

    // ==========================================
    // Caregiver Routes (Protected — caregiver role only)
    // ==========================================
    ShellRoute(
      redirect: (BuildContext context, GoRouterState state) {
        return RolesMiddleware.requireRole(
          context,
          state,
          allowedRole: UserRole.caregiver,
        );
      },
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Scaffold(body: Center(child: child));
      },
      routes: [
        GoRoute(
          path: AppRoutes.caregiverDashboard.path,
          name: AppRoutes.caregiverDashboard.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(child: Text('Caregiver Dashboard')),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.caregiverAssessment.path,
          name: AppRoutes.caregiverAssessment.name,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(
              body: Center(child: Text('Caregiver Assessment')),
            );
          },
        ),
      ],
    ),
    // Handle direct access to /caregiver prefix
    GoRoute(
      path: AppRoutes.caregiverRoutePrefix,
      redirect: (BuildContext context, GoRouterState state) {
        return AppRoutes.caregiverDashboard.path;
      },
    ),

    // ==========================================
    // Opto Home Dashboard (Screen 15)
    // Post-setup landing screen for the 'user' role.
    // ==========================================
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
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

    // Screen 17 — Prosthetic Hub (with Phase 3A sub-routes as children)
    // TODO(phase-3a): Replace stub builders with real screens as they are created.
    GoRoute(
      path: AppRoutes.prostheticHub.path,
      name: AppRoutes.prostheticHub.name,
      builder: (BuildContext context, GoRouterState state) {
        return const ProstheticHubScreen();
      },
      routes: [
        // Catalog listing
        GoRoute(
          path: 'catalog',
          name: AppRoutes.prostheticCatalog.name,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Coming soon'))),
          routes: [
            // Product detail — nested under catalog
            GoRoute(
              path: ':productId',
              name: AppRoutes.prostheticProductDetail.name,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Coming soon'))),
            ),
          ],
        ),
        // Care tutorials listing
        GoRoute(
          path: 'tutorials',
          name: AppRoutes.careTutorials.name,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Coming soon'))),
          routes: [
            // Tutorial video player — nested under tutorials
            GoRoute(
              path: ':tutorialId',
              name: AppRoutes.tutorialPlayer.name,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Coming soon'))),
            ),
          ],
        ),
        // Anthropometric measurements
        GoRoute(
          path: 'measurements',
          name: AppRoutes.anthropometric.name,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Coming soon'))),
        ),
        // Eye photos
        GoRoute(
          path: 'eye-photos',
          name: AppRoutes.eyePhotos.name,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Coming soon'))),
        ),
        // Orders
        GoRoute(
          path: 'orders',
          name: AppRoutes.prostheticOrders.name,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Coming soon'))),
          routes: [
            // New order wizard — registered before :orderId to avoid shadowing
            GoRoute(
              path: 'new',
              name: AppRoutes.orderCreate.name,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Coming soon'))),
            ),
            // Order detail
            GoRoute(
              path: ':orderId',
              name: AppRoutes.orderDetail.name,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Coming soon'))),
            ),
          ],
        ),
        // Care reminders
        GoRoute(
          path: 'reminders',
          name: AppRoutes.careReminders.name,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Coming soon'))),
        ),
      ],
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
