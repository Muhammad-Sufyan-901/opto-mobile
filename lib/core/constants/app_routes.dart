class AppRoute {
  final String path;
  final String name;

  const AppRoute({
    required this.path,
    required this.name,
  });
}

abstract class AppRoutes {
  // Onboarding routes
  static const AppRoute onboarding = AppRoute(
    path: '/onboarding',
    name: 'onboarding',
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
}
