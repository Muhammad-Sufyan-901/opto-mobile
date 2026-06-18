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
import 'package:opto/features/consultation/presentation/screens/booking_screen.dart';
import 'package:opto/features/consultation/presentation/screens/call_room_screen.dart';
import 'package:opto/features/consultation/presentation/screens/connecting_screen.dart';
import 'package:opto/features/consultation/presentation/screens/consult_screen.dart';
import 'package:opto/features/consultation/presentation/screens/consultation_history_screen.dart';
import 'package:opto/features/consultation/presentation/screens/doctor_profile_screen.dart';
import 'package:opto/features/consultation/presentation/screens/intake_screen.dart';
import 'package:opto/features/consultation/presentation/screens/non_verbal_consult_screen.dart';
import 'package:opto/features/consultation/presentation/screens/summary_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/prosthetic_hub_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/care_guides_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/care_log_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/care_guide_detail_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/order_supplies_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/supply_order_summary_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/specialist_list_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/specialist_profile_screen.dart';
import 'package:opto/features/prosthetic_hub/presentation/screens/specialist_chat_screen.dart';
import 'package:opto/features/connect/presentation/screens/circle_detail_screen.dart';
import 'package:opto/features/connect/presentation/screens/community_home_screen.dart';
import 'package:opto/features/connect/presentation/screens/community_screen.dart';
import 'package:opto/features/connect/presentation/screens/compose_post_screen.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/presentation/screens/member_profile_screen.dart';
import 'package:opto/features/connect/presentation/screens/post_thread_screen.dart';
import 'package:opto/features/profile/presentation/screens/profile_screen.dart';
import 'package:opto/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:opto/features/profile/presentation/screens/profile_vision_screen.dart';
import 'package:opto/features/profile/presentation/screens/accessibility_screen.dart';
import 'package:opto/features/profile/presentation/screens/account_settings_screen.dart';
import 'package:opto/features/profile/presentation/screens/my_activity_screen.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';
import 'package:opto/features/setup/presentation/screens/setup_done_screen.dart';
import 'package:opto/features/sos/presentation/screens/sos_active_screen.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_mode.dart';
import 'package:opto/features/vision_ai/presentation/cubit/vision_ai_cubit.dart';
import 'package:opto/features/vision_ai/presentation/screens/vision_ai_screen.dart';
import 'package:opto/features/voice/presentation/screens/aura_voice_screen.dart';
import 'package:opto/core/location/location.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/nearby_pois/nearby_pois_bloc.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/poi_detail/poi_detail_cubit.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/add_poi/add_poi_cubit.dart';
import 'package:opto/features/accessibility_map/presentation/screens/nearby_pois_screen.dart';
import 'package:opto/features/accessibility_map/presentation/screens/poi_map_screen.dart';
import 'package:opto/features/accessibility_map/presentation/screens/poi_detail_screen.dart';
import 'package:opto/features/accessibility_map/presentation/screens/add_poi_screen.dart';

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
    // VisionAiCubit is scoped to this route so the camera + ML Kit
    // lifecycle is tied to the screen's presence in the navigator stack.
    // The cubit is a registerFactory so each push gets a fresh instance.
    GoRoute(
      path: AppRoutes.visionAi.path,
      name: AppRoutes.visionAi.name,
      builder: (BuildContext context, GoRouterState routerState) {
        // Accept an optional VisionMode from voice intent navigation
        // (passed as GoRouterState.extra: VisionMode).
        final initialMode =
            routerState.extra is VisionMode
                ? routerState.extra as VisionMode
                : null;
        return BlocProvider<VisionAiCubit>(
          create: (_) => sl<VisionAiCubit>(),
          child: VisionAiScreen(initialMode: initialMode),
        );
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

    // Screen 17-L — Log today's care
    GoRoute(
      path: AppRoutes.prostheticCareLog.path,
      name: AppRoutes.prostheticCareLog.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CareLogScreen(),
    ),

    // Screen 17a — Care guides list
    GoRoute(
      path: AppRoutes.prostheticCareGuides.path,
      name: AppRoutes.prostheticCareGuides.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CareGuidesScreen(),
    ),

    // Screen 17a-detail — Individual care guide
    GoRoute(
      path: AppRoutes.prostheticCareGuideDetail.path,
      name: AppRoutes.prostheticCareGuideDetail.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CareGuideDetailScreen(),
    ),

    // Screen 17b — Order supplies catalog
    GoRoute(
      path: AppRoutes.prostheticOrderSupplies.path,
      name: AppRoutes.prostheticOrderSupplies.name,
      builder: (BuildContext context, GoRouterState state) =>
          const OrderSuppliesScreen(),
    ),

    // Screen 17b-summary — Order summary & consent
    GoRoute(
      path: AppRoutes.prostheticOrderSummary.path,
      name: AppRoutes.prostheticOrderSummary.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SupplyOrderSummaryScreen(),
    ),

    // Screen 17c — Specialist directory
    GoRoute(
      path: AppRoutes.prostheticSpecialists.path,
      name: AppRoutes.prostheticSpecialists.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SpecialistListScreen(),
    ),

    // Screen 17c-profile — Specialist profile
    // Screen 17c-chat is nested here so GoRouter does not greedily match :id
    // and shadow the /chat suffix with a sibling route.
    GoRoute(
      path: AppRoutes.prostheticSpecialistProfile.path,
      name: AppRoutes.prostheticSpecialistProfile.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SpecialistProfileScreen(),
      routes: [
        // Screen 17c-chat — 1:1 specialist chat room
        GoRoute(
          path: 'chat', // relative → resolves to /prosthetic-hub/specialists/:id/chat
          name: AppRoutes.prostheticSpecialistChat.name,
          builder: (BuildContext context, GoRouterState state) =>
              const SpecialistChatScreen(),
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

    // Screen 18a — Doctor profile + availability
    GoRoute(
      path: AppRoutes.consultDoctorProfile.path,
      name: AppRoutes.consultDoctorProfile.name,
      builder: (BuildContext context, GoRouterState state) =>
          const DoctorProfileScreen(),
    ),

    // Screen 18b — Booking flow (slot + mode + confirm)
    GoRoute(
      path: AppRoutes.consultBooking.path,
      name: AppRoutes.consultBooking.name,
      builder: (BuildContext context, GoRouterState state) =>
          const BookingScreen(),
    ),

    // Screen 18c — Consultation history (🔒 medically sensitive)
    GoRoute(
      path: AppRoutes.consultHistory.path,
      name: AppRoutes.consultHistory.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ConsultationHistoryScreen(),
    ),

    // Screen 18d — Non-verbal consultation session (no video)
    GoRoute(
      path: AppRoutes.consultNonVerbal.path,
      name: AppRoutes.consultNonVerbal.name,
      builder: (BuildContext context, GoRouterState state) =>
          const NonVerbalConsultScreen(),
    ),

    // Screen 18e — Pre-consult intake (C4)
    GoRoute(
      path: AppRoutes.consultIntake.path,
      name: AppRoutes.consultIntake.name,
      builder: (BuildContext context, GoRouterState state) =>
          const IntakeScreen(),
    ),

    // Screen 18f — Connecting / waiting room (C5)
    GoRoute(
      path: AppRoutes.consultConnecting.path,
      name: AppRoutes.consultConnecting.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ConnectingScreen(),
    ),

    // Screen 18g — Live call room (C6)
    GoRoute(
      path: AppRoutes.consultCallRoom.path,
      name: AppRoutes.consultCallRoom.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CallRoomScreen(),
    ),

    // Screen 18h — Consult summary & e-prescription (C7)
    GoRoute(
      path: AppRoutes.consultSummary.path,
      name: AppRoutes.consultSummary.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SummaryScreen(),
    ),

    // Screen 19 — Community Home (K1)
    GoRoute(
      path: AppRoutes.community.path,
      name: AppRoutes.community.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CommunityHomeScreen(),
    ),

    // Screen 19-feed — Community Feed (K2 — full post list)
    GoRoute(
      path: AppRoutes.communityFeed.path,
      name: AppRoutes.communityFeed.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CommunityScreen(),
    ),

    // Screen 19a — Compose new post
    GoRoute(
      path: AppRoutes.communityCompose.path,
      name: AppRoutes.communityCompose.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ComposePostScreen(),
    ),

    // Screen 19b — Post thread (replies)
    GoRoute(
      path: AppRoutes.communityThread.path,
      name: AppRoutes.communityThread.name,
      builder: (BuildContext context, GoRouterState state) {
        final String postId = state.pathParameters['postId']!;
        // Accept an optional [PostEntity] seed via route extra for instant
        // OP render while the full thread loads from the network.
        final PostEntity? seedPost = state.extra is PostEntity
            ? state.extra as PostEntity
            : null;
        return PostThreadScreen(postId: postId, seedPost: seedPost);
      },
    ),

    // Screen 19c — Circle Detail (K5)
    GoRoute(
      path: AppRoutes.communityCircle.path,
      name: AppRoutes.communityCircle.name,
      builder: (BuildContext context, GoRouterState state) {
        final String slug = Uri.decodeComponent(
          state.pathParameters['slug']!,
        );
        return CircleDetailScreen(slug: slug);
      },
    ),

    // Screen 19d — Member Profile (K7)
    GoRoute(
      path: AppRoutes.communityMember.path,
      name: AppRoutes.communityMember.name,
      builder: (BuildContext context, GoRouterState state) {
        final String memberId = state.pathParameters['id']!;
        return MemberProfileScreen(memberId: memberId);
      },
    ),

    // Screen 20 — Profile Home
    GoRoute(
      path: AppRoutes.profile.path,
      name: AppRoutes.profile.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
    ),

    // Screen 20a — Edit Profile
    GoRoute(
      path: AppRoutes.profileEdit.path,
      name: AppRoutes.profileEdit.name,
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<ProfileBloc>(
            create: (_) => sl<ProfileBloc>(),
            child: const ProfileEditScreen(),
          ),
    ),

    // Screen 20b — Vision Profile (🔒 medical — owner-only display)
    GoRoute(
      path: AppRoutes.visionProfile.path,
      name: AppRoutes.visionProfile.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileVisionScreen(),
    ),

    // Screen 20c — Accessibility Preferences (wired to AccessibilitySettingsCubit singleton)
    GoRoute(
      path: AppRoutes.accessibilitySettings.path,
      name: AppRoutes.accessibilitySettings.name,
      builder: (BuildContext context, GoRouterState state) =>
          BlocProvider<AccessibilitySettingsCubit>.value(
            value: sl<AccessibilitySettingsCubit>(),
            child: const AccessibilityScreen(),
          ),
    ),

    // Screen 20d — Account & Settings
    GoRoute(
      path: AppRoutes.accountSettings.path,
      name: AppRoutes.accountSettings.name,
      builder: (BuildContext context, GoRouterState state) =>
          const AccountSettingsScreen(),
    ),

    // Screen 20e — My Activity
    GoRoute(
      path: AppRoutes.myActivity.path,
      name: AppRoutes.myActivity.name,
      builder: (BuildContext context, GoRouterState state) =>
          const MyActivityScreen(),
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

    // ── Accessibility Map (Phase 3B) ──────────────────────────────────────
    // NearbyPoisBloc is a lazy singleton in DI — the visual screen reads the
    // same already-loaded state as the list screen without re-fetching.
    GoRoute(
      path: AppRoutes.accessibilityMap.path,
      name: AppRoutes.accessibilityMap.name,
      builder: (context, state) => BlocProvider.value(
        value: sl<NearbyPoisBloc>(),
        child: NearbyPoisScreen(
          locationService: sl<LocationService>(),
        ),
      ),
      routes: [
        // Optional visual map (flutter_map tile layer).
        // Wrapped in ExcludeSemantics at the tile level — SR users use list.
        GoRoute(
          path: 'visual',
          name: AppRoutes.accessibilityMapVisual.name,
          builder: (context, state) => BlocProvider.value(
            value: sl<NearbyPoisBloc>(),
            child: const PoiMapScreen(),
          ),
        ),
        // Add a new POI — registered before :poiId to avoid shadowing.
        GoRoute(
          path: 'add',
          name: AppRoutes.addPoi.name,
          builder: (context, state) => BlocProvider<AddPoiCubit>(
            create: (_) => sl<AddPoiCubit>(),
            child: AddPoiScreen(
              locationService: sl<LocationService>(),
            ),
          ),
        ),
        // POI detail + verify/suggest-edit.
        GoRoute(
          path: ':poiId',
          name: AppRoutes.poiDetail.name,
          builder: (context, state) {
            final poiId = state.pathParameters['poiId']!;
            return BlocProvider<PoiDetailCubit>(
              create: (_) => sl<PoiDetailCubit>(),
              child: PoiDetailScreen(poiId: poiId),
            );
          },
        ),
      ],
    ),

    // ==========================================
    // Other Routes goes here
    // ==========================================
  ],
);
