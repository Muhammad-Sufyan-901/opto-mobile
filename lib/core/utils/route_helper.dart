import 'package:ids_elder_rehab_app/core/config/app_info.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';

class RouteHelper {
  static final Set<String> _publicRoutes = {
    AppRoutes.onboarding.path,
    AppRoutes.login.path,
    AppRoutes.register.path,
    AppRoutes.forgotPassword.path,
    AppRoutes.lansiaDashboard.path,
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
      'lansia': AppRoutes.lansiaDashboard.path,
    };

    // Return dashboard route based on role
    return roleDashboards[lowerRole] ?? AppRoutes.lansiaDashboard.path;
  }
}
