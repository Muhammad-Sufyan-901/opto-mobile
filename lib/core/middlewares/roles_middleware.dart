import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/di/dependencies_injection_container.dart';
import 'package:ids_elder_rehab_app/core/utils/route_helper.dart';
import 'package:ids_elder_rehab_app/core/utils/secure_storage_helper.dart';

class RolesMiddleware {
  /// Dynamic middleware to protect specific routes based on user role
  static Future<String?> requireRole(
    BuildContext context,
    GoRouterState state, {
    required String allowedRole,
  }) async {
    final storageHelper = sl<SecureStorageHelper>();
    final String? currentRole = await storageHelper.getRole();

    // if role is not allowed, redirect to login with message
    if (currentRole != allowedRole) {
      debugPrint(
        '⛔ Access Denied: Need role "$allowedRole" to access this page, but user is "$currentRole"',
      );

      final String fallbackRoute = RouteHelper.getDashboardRouteByRole(
        currentRole,
      );
      final String errorMessage =
          'Anda tidak memiliki izin untuk mengakses halaman ini.';

      // Redirect to dashboard based on their roles with error message
      return '$fallbackRoute?error=$errorMessage';
    }

    // if role is allowed, return null to allow access
    return null;
  }
}
