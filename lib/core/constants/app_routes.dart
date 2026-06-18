class AppRoute {
  final String path;
  final String name;

  const AppRoute({
    required this.path,
    required this.name,
  });
}

abstract class AppRoutes {
  static const String doctorRoutePrefix = '/doctor';
  static const String caregiverRoutePrefix = '/caregiver';

  // ── Home / Dashboard ──────────────────────────────────────────────────────
  /// Main Opto Home Dashboard — reached after setup completes (screen 15).
  static const AppRoute home = AppRoute(
    path: '/home',
    name: 'home',
  );

  // ── Module destination routes (Screens 16–22) ───────────────────────────────
  /// Screen 16 — Vision AI camera (destinations section).
  static const AppRoute visionAi = AppRoute(
    path: '/vision-ai',
    name: 'vision_ai',
  );

  /// Screen 17 — Prosthetic Hub (catalog & ordering).
  static const AppRoute prostheticHub = AppRoute(
    path: '/prosthetic-hub',
    name: 'prosthetic_hub',
  );

  // ── Prosthetic Hub sub-routes (Phase 3A) ─────────────────────────────────

  /// Screen 17-L — Log today's prosthetic care.
  static const AppRoute prostheticCareLog = AppRoute(
    path: '/prosthetic-hub/log-care',
    name: 'prosthetic_care_log',
  );

  /// Screen 17a — Care guides list.
  static const AppRoute prostheticCareGuides = AppRoute(
    path: '/prosthetic-hub/care-guides',
    name: 'prosthetic_care_guides',
  );

  /// Screen 17a-detail — Individual care guide.
  ///
  /// Navigate by appending `/${guide.id}` to [prostheticCareGuides.path];
  /// receive the [CareGuide] via `GoRouterState.extra`.
  static const AppRoute prostheticCareGuideDetail = AppRoute(
    path: '/prosthetic-hub/care-guides/:id',
    name: 'prosthetic_care_guide_detail',
  );

  /// Screen 17b — Order supplies catalog.
  static const AppRoute prostheticOrderSupplies = AppRoute(
    path: '/prosthetic-hub/order-supplies',
    name: 'prosthetic_order_supplies',
  );

  /// Screen 17b-summary — Order summary & consent.
  ///
  /// Receive cart data via `GoRouterState.extra`.
  static const AppRoute prostheticOrderSummary = AppRoute(
    path: '/prosthetic-hub/order-supplies/summary',
    name: 'prosthetic_order_summary',
  );

  /// Screen 17c — Specialist directory.
  static const AppRoute prostheticSpecialists = AppRoute(
    path: '/prosthetic-hub/specialists',
    name: 'prosthetic_specialists',
  );

  /// Screen 17c-profile — Specialist profile.
  ///
  /// Navigate by appending `/${specialist.id}` to [prostheticSpecialists.path];
  /// receive the [Specialist] via `GoRouterState.extra`.
  static const AppRoute prostheticSpecialistProfile = AppRoute(
    path: '/prosthetic-hub/specialists/:id',
    name: 'prosthetic_specialist_profile',
  );

  /// Screen 17c-chat — 1:1 specialist chat room (nested under profile).
  ///
  /// Push by name with `pathParameters: {'id': specialist.id}`.
  /// Resolves to `/prosthetic-hub/specialists/:id/chat`.
  static const AppRoute prostheticSpecialistChat = AppRoute(
    path: 'chat', // relative — nested inside prostheticSpecialistProfile route
    name: 'prosthetic_specialist_chat',
  );

  // ── Accessibility Map sub-routes (Phase 3B) ──────────────────────────────

  /// Screen — Accessibility Map: nearby POI list (primary accessible view).
  static const AppRoute accessibilityMap = AppRoute(
    path: '/map',
    name: 'accessibility_map',
  );

  /// Accessibility Map → Optional flutter_map visual tile view.
  ///
  /// The map is decorative for screen readers; use [accessibilityMap] as the
  /// canonical accessible entry point.
  static const AppRoute accessibilityMapVisual = AppRoute(
    path: '/map/visual',
    name: 'accessibility_map_visual',
  );

  /// Accessibility Map → POI detail page.
  ///
  /// Navigate with:
  /// ```dart
  /// context.pushNamed(AppRoutes.poiDetail.name,
  ///     pathParameters: {'poiId': id});
  /// ```
  /// ⚠️ Do NOT use `.path` directly — it contains a `:poiId` placeholder.
  static const AppRoute poiDetail = AppRoute(
    path: '/map/:poiId',
    name: 'poi_detail',
  );

  /// Accessibility Map → Add a new accessible place form.
  static const AppRoute addPoi = AppRoute(
    path: '/map/add',
    name: 'add_poi',
  );

  /// Screen 18 — Health & Consultation (booking & history).
  static const AppRoute consult = AppRoute(
    path: '/consult',
    name: 'consult',
  );

  /// Screen 19 — Community (peer connections & events).
  static const AppRoute community = AppRoute(
    path: '/community',
    name: 'community',
  );

  /// Compose a new community post.
  static const AppRoute communityCompose = AppRoute(
    path: '/community/compose',
    name: 'communityCompose',
  );

  /// Thread view for a single post. The postId is embedded in the path.
  static const AppRoute communityThread = AppRoute(
    path: '/community/thread/:postId',
    name: 'communityThread',
  );

  /// Community feed (K2 — full post list, formerly the /community root).
  static const AppRoute communityFeed = AppRoute(
    path: '/community/feed',
    name: 'communityFeed',
  );

  /// Circle detail (K5). Navigate with:
  /// ```dart
  /// context.push('/community/circle/${Uri.encodeComponent(circle.slug)}');
  /// ```
  static const AppRoute communityCircle = AppRoute(
    path: '/community/circle/:slug',
    name: 'communityCircle',
  );

  /// Member public profile (K7). Navigate with:
  /// ```dart
  /// context.push('/community/member/${member.id}');
  /// ```
  static const AppRoute communityMember = AppRoute(
    path: '/community/member/:id',
    name: 'communityMember',
  );

  /// Screen 18a — Doctor profile and availability slots.
  static const AppRoute consultDoctorProfile = AppRoute(
    path: '/consult/doctor/:id',
    name: 'consult_doctor_profile',
  );

  /// Screen 18b — Consultation booking flow (slot pick + mode + confirm).
  static const AppRoute consultBooking = AppRoute(
    path: '/consult/book',
    name: 'consult_booking',
  );

  /// Screen 18c — Patient's consultation history (🔒 medically sensitive).
  static const AppRoute consultHistory = AppRoute(
    path: '/consult/history',
    name: 'consult_history',
  );

  /// Screen 18d — Non-verbal consultation session (audio/text, no video).
  static const AppRoute consultNonVerbal = AppRoute(
    path: '/consult/session/non-verbal',
    name: 'consult_non_verbal',
  );

  /// Screen 18e — Pre-consult intake (symptom chips, voice note, photo attach).
  ///
  /// Navigate with `GoRouterState.extra = {'doctor': DoctorEntity}`.
  static const AppRoute consultIntake = AppRoute(
    path: '/consult/intake',
    name: 'consult_intake',
  );

  /// Screen 18f — Connecting / waiting for doctor to join.
  ///
  /// Navigate with `GoRouterState.extra = {'doctor': DoctorEntity}`.
  static const AppRoute consultConnecting = AppRoute(
    path: '/consult/connecting',
    name: 'consult_connecting',
  );

  /// Screen 18g — Live consultation call room (voice-first; visual stub).
  ///
  /// Navigate with `GoRouterState.extra = {'doctor': DoctorEntity}`.
  static const AppRoute consultCallRoom = AppRoute(
    path: '/consult/session/call',
    name: 'consult_call_room',
  );

  /// Screen 18h — Post-consult summary and e-prescription.
  ///
  /// Navigate with `GoRouterState.extra = {'doctor': DoctorEntity}`.
  /// 🔒 Medically sensitive — session-only, never cached.
  static const AppRoute consultSummary = AppRoute(
    path: '/consult/summary',
    name: 'consult_summary',
  );

  /// Screen 20 — Profile & Settings (account + preferences).
  static const AppRoute profile = AppRoute(
    path: '/profile',
    name: 'profile',
  );

  /// Screen 20a — Edit profile (display name, pronouns, bio, location).
  static const AppRoute profileEdit = AppRoute(
    path: '/profile/edit',
    name: 'profile_edit',
  );

  /// Screen 20b — Vision profile (diagnosis, functional vision, prosthesis,
  /// assistive tech). 🔒 Displayed to the signed-in user only; never cached
  /// beyond session and never joined to community/catalog queries.
  static const AppRoute visionProfile = AppRoute(
    path: '/profile/vision',
    name: 'vision_profile',
  );

  /// Screen 20c — Accessibility preferences (screen reader, text size,
  /// contrast, haptics, speech rate). Wired to [AccessibilitySettingsCubit].
  static const AppRoute accessibilitySettings = AppRoute(
    path: '/profile/accessibility',
    name: 'accessibility_settings',
  );

  /// Screen 20d — Account & settings (email, phone, language, notifications,
  /// privacy, sign-out, delete account).
  static const AppRoute accountSettings = AppRoute(
    path: '/profile/account',
    name: 'account_settings',
  );

  /// Screen 20e — My activity (posts, saved, replies, liked).
  static const AppRoute myActivity = AppRoute(
    path: '/profile/activity',
    name: 'my_activity',
  );

  /// Screen 20f — Emergency contacts management.
  static const AppRoute emergencyContacts = AppRoute(
    path: '/profile/emergency',
    name: 'emergency_contacts',
  );

  /// Screen 21 — Emergency SOS (panic button + alert).
  static const AppRoute sos = AppRoute(
    path: '/sos',
    name: 'sos',
  );

  /// Screen 22 — Aura Voice (voice intents & control).
  static const AppRoute auraVoice = AppRoute(
    path: '/aura',
    name: 'aura_voice',
  );

  // Onboarding routes
  /// Brand splash — shown on first launch, auto-advances to [onboarding].
  static const AppRoute splash = AppRoute(
    path: '/splash',
    name: 'splash',
  );

  /// Welcome carousel — 3-slide intro before authentication.
  static const AppRoute onboarding = AppRoute(
    path: '/onboarding',
    name: 'onboarding',
  );

  // Developer routes
  static const AppRoute developer = AppRoute(
    path: '/developer',
    name: 'developer',
  );

  // Auth routes — Opto sign-in hub + sub-flows
  /// Sign-in hub — method selection (Google / email / phone / caregiver).
  static const AppRoute login = AppRoute(
    path: '/login',
    name: 'login',
  );

  /// Email & password entry.
  static const AppRoute authEmail = AppRoute(
    path: '/auth/email',
    name: 'auth_email',
  );

  /// Phone number entry → OTP.
  static const AppRoute authPhone = AppRoute(
    path: '/auth/phone',
    name: 'auth_phone',
  );

  /// OTP verification.
  static const AppRoute authOtp = AppRoute(
    path: '/auth/otp',
    name: 'auth_otp',
  );

  /// Caregiver / assisted setup.
  static const AppRoute authCaregiver = AppRoute(
    path: '/auth/caregiver',
    name: 'auth_caregiver',
  );

  /// Email register — create a new account.
  static const AppRoute authRegister = AppRoute(
    path: '/auth/register',
    name: 'auth_register',
  );

  // ── Onboarding & Setup routes (post-auth, screens 10–14) ──────────────────
  /// Step 10 — Vision profile selection.
  static const AppRoute setupVision = AppRoute(
    path: '/setup/vision',
    name: 'setup_vision',
  );

  /// Step 11 — Text size & contrast.
  static const AppRoute setupDisplay = AppRoute(
    path: '/setup/display',
    name: 'setup_display',
  );

  /// Step 12 — Voice & sound.
  static const AppRoute setupVoice = AppRoute(
    path: '/setup/voice',
    name: 'setup_voice',
  );

  /// Step 13 — App permissions.
  static const AppRoute setupPermissions = AppRoute(
    path: '/setup/permissions',
    name: 'setup_permissions',
  );

  /// Step 14 — All set / setup complete.
  static const AppRoute setupDone = AppRoute(
    path: '/setup/done',
    name: 'setup_done',
  );

  // Caregiver routes (Grouped with "/caregiver" as parent)
  static const AppRoute caregiverDashboard = AppRoute(
    path: '$caregiverRoutePrefix/dashboard',
    name: 'caregiver_dashboard',
  );
  static const AppRoute caregiverAssessment = AppRoute(
    path: '$caregiverRoutePrefix/assessment',
    name: 'caregiver_assessment',
  );

  // Doctor routes (Grouped with "/doctor" as parent)
  static const AppRoute doctorDashboard = AppRoute(
    path: '$doctorRoutePrefix/dashboard',
    name: 'doctor_dashboard',
  );
  static const AppRoute doctorAssessment = AppRoute(
    path: '$doctorRoutePrefix/assessment',
    name: 'doctor_assessment',
  );
}
