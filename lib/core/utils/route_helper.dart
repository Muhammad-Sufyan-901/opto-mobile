import 'package:opto/core/config/app_info.dart';
import 'package:opto/core/constants/app_routes.dart';

class RouteHelper {
  static final Set<String> _publicRoutes = {
    AppRoutes.splash.path,
    AppRoutes.onboarding.path,
    AppRoutes.login.path,
    AppRoutes.authEmail.path,
    AppRoutes.authPhone.path,
    AppRoutes.authOtp.path,
    AppRoutes.authCaregiver.path,
    if (AppInfo.isDevelopment) AppRoutes.developer.path,
  };

  /// Check if a path is public route
  static bool isPublicRoute(String path) {
    return _publicRoutes.contains(path);
  }

  /// Get dashboard route based on role
  static String getDashboardRouteByRole(String? role) {
    final lowerRole = role?.toLowerCase();

    final Map<String, String> roleDashboards = {
      'doctor': AppRoutes.doctorDashboard.path,
      'caregiver': AppRoutes.caregiverDashboard.path,
      // Opto primary role → Home Dashboard.
      'user': AppRoutes.home.path,
      'admin': AppRoutes.home.path,
    };

    // Default: fall back to the Opto Home Dashboard.
    return roleDashboards[lowerRole] ?? AppRoutes.home.path;
  }
}
