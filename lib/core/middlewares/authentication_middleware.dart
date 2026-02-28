import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/di/dependencies_injection_container.dart';
import 'package:ids_elder_rehab_app/core/utils/secure_storage_helper.dart';
import 'package:ids_elder_rehab_app/core/utils/route_helper.dart';

class AuthenticationMiddleware {
  static FutureOr<String?> guard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final SecureStorageHelper storageHelper = sl<SecureStorageHelper>();

    final bool hasToken = await storageHelper.hasToken();

    final bool isGoingToPublicRoute = RouteHelper.isPublicRoute(
      state.matchedLocation,
    );

    // Scenario 1: User is not logged in and trying to access protected route
    if (!hasToken && !isGoingToPublicRoute) {
      debugPrint(
        'Access Denied: User is not logged in and trying to access protected route.',
      );

      // Delete all data of the user from secure storage
      await storageHelper.clearAll();

      final String errorMessage =
          'Sesi anda telah berakhir, silakan login kembali.';

      // Redirect to login with error message
      return '${AppRoutes.login.path}?error=$errorMessage';
    }

    // Scenario 2: User is logged in and trying to access public route
    if (hasToken && isGoingToPublicRoute) {
      debugPrint(
        'Access Denied: User is logged in and trying to access public route.',
      );

      // Get user role
      final String? role = await storageHelper.getRole();

      // Get dashboard route based on role
      return RouteHelper.getDashboardRouteByRole(role);
    }

    // Scenario 3: User is logged in and trying to access protected route (allowed secure user)
    return null;
  }
}
