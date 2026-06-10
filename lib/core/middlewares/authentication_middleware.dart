import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/utils/route_helper.dart';
import 'package:opto/core/utils/secure_storage_helper.dart';

class AuthenticationMiddleware {
  static FutureOr<String?> guard(
    BuildContext context,
    GoRouterState state,
  ) async {
    // Use Supabase session as the source of truth (not secure-storage token).
    final session = Supabase.instance.client.auth.currentSession;
    final bool isAuthenticated = session != null;

    final bool isGoingToPublicRoute = RouteHelper.isPublicRoute(
      state.matchedLocation,
    );

    // Scenario 1: Not authenticated — trying to access a protected route.
    if (!isAuthenticated && !isGoingToPublicRoute) {
      debugPrint('AuthMiddleware: unauthenticated access blocked.');

      // Clear any stale secure-storage role cache.
      final storage = sl<SecureStorageHelper>();
      await storage.clearAll();

      return '${AppRoutes.login.path}?error=Your+session+has+expired.+Please+sign+in+again.';
    }

    // Scenario 2: Authenticated — trying to access a public/auth route.
    if (isAuthenticated && isGoingToPublicRoute) {
      debugPrint(
        'AuthMiddleware: authenticated user redirected from public route.',
      );

      // Get user role from cache to determine the correct dashboard.
      final String? role = await sl<SecureStorageHelper>().getRole();
      return RouteHelper.getDashboardRouteByRole(role);
    }

    // Scenario 3: Authenticated — accessing a protected route. Allow.
    return null;
  }
}
