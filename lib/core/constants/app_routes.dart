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

  /// Prosthetic Hub → Product catalog listing.
  static const AppRoute prostheticCatalog = AppRoute(
    path: '/prosthetic-hub/catalog',
    name: 'prosthetic_catalog',
  );

  /// Prosthetic Hub → Product detail page.
  ///
  /// Navigate with:
  /// ```dart
  /// context.goNamed(AppRoutes.prostheticProductDetail.name,
  ///     pathParameters: {'productId': id});
  /// ```
  /// ⚠️ Do NOT use `.path` directly — it contains a `:productId` placeholder.
  static const AppRoute prostheticProductDetail = AppRoute(
    path: '/prosthetic-hub/catalog/:productId',
    name: 'prosthetic_product_detail',
  );

  /// Prosthetic Hub → Care & maintenance tutorial listing.
  static const AppRoute careTutorials = AppRoute(
    path: '/prosthetic-hub/tutorials',
    name: 'care_tutorials',
  );

  /// Prosthetic Hub → Tutorial video player.
  ///
  /// Navigate with:
  /// ```dart
  /// context.goNamed(AppRoutes.tutorialPlayer.name,
  ///     pathParameters: {'tutorialId': id});
  /// ```
  /// ⚠️ Do NOT use `.path` directly — it contains a `:tutorialId` placeholder.
  static const AppRoute tutorialPlayer = AppRoute(
    path: '/prosthetic-hub/tutorials/:tutorialId',
    name: 'tutorial_player',
  );

  /// Prosthetic Hub → Anthropometric measurements entry & history.
  static const AppRoute anthropometric = AppRoute(
    path: '/prosthetic-hub/measurements',
    name: 'anthropometric',
  );

  /// Prosthetic Hub → Eye photo capture & gallery.
  static const AppRoute eyePhotos = AppRoute(
    path: '/prosthetic-hub/eye-photos',
    name: 'eye_photos',
  );

  /// Prosthetic Hub → Orders listing.
  static const AppRoute prostheticOrders = AppRoute(
    path: '/prosthetic-hub/orders',
    name: 'prosthetic_orders',
  );

  /// Prosthetic Hub → New order creation wizard.
  static const AppRoute orderCreate = AppRoute(
    path: '/prosthetic-hub/orders/new',
    name: 'order_create',
  );

  /// Prosthetic Hub → Order detail / status.
  ///
  /// Navigate with:
  /// ```dart
  /// context.goNamed(AppRoutes.orderDetail.name,
  ///     pathParameters: {'orderId': id});
  /// ```
  /// ⚠️ Do NOT use `.path` directly — it contains a `:orderId` placeholder.
  static const AppRoute orderDetail = AppRoute(
    path: '/prosthetic-hub/orders/:orderId',
    name: 'order_detail',
  );

  /// Prosthetic Hub → Care reminders schedule & management.
  static const AppRoute careReminders = AppRoute(
    path: '/prosthetic-hub/reminders',
    name: 'care_reminders',
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

  /// Screen 20 — Profile & Settings (account + preferences).
  static const AppRoute profile = AppRoute(
    path: '/profile',
    name: 'profile',
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
