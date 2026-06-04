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
  static const String lansiaRoutePrefix = '/lansia';

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

  // Auth routes (Login, Register, Forgot Password)
  static const AppRoute login = AppRoute(
    path: '/login',
    name: 'login',
  );
  static const AppRoute register = AppRoute(
    path: '/register',
    name: 'register',
  );
  static const AppRoute forgotPassword = AppRoute(
    path: '/forgot-password',
    name: 'forgot-password',
  );

  // Lansia routes (Grouped with "/lansia" as parent)
  static const AppRoute lansiaDashboard = AppRoute(
    path: '$lansiaRoutePrefix/dashboard',
    name: 'lansia_dashboard',
  );
  static const AppRoute lansiaAssessment = AppRoute(
    path: '$lansiaRoutePrefix/assessment',
    name: 'lansia_assessment',
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
