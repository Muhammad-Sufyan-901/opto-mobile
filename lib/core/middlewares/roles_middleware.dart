import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/user_role.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/utils/route_helper.dart';
import 'package:opto/core/utils/secure_storage_helper.dart';

class RolesMiddleware {
  /// Dynamic middleware to protect specific routes based on user role.
  ///
  /// Pass a [UserRole] value instead of a bare string to stay type-safe.
  static Future<String?> requireRole(
    BuildContext context,
    GoRouterState state, {
    required UserRole allowedRole,
  }) async {
    final storageHelper = sl<SecureStorageHelper>();
    final String? rawRole = await storageHelper.getRole();
    final UserRole currentRole = UserRole.fromString(rawRole);

    // if role is not allowed, redirect to dashboard with error message
    if (currentRole != allowedRole) {
      debugPrint(
        '⛔ Access Denied: Need role "${allowedRole.name}" to access this page, '
        'but user is "${currentRole.name}"',
      );

      final String fallbackRoute = RouteHelper.getDashboardRouteByRole(rawRole);
      const String errorMessage =
          'You do not have permission to access this page.';

      return '$fallbackRoute?error=$errorMessage';
    }

    // Role is allowed — proceed
    return null;
  }
}
