import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Handles incoming opto:// feature deep links and routes them via [GoRouter].
///
/// Runs alongside the existing Supabase auth deep link handler in main.dart.
/// This class handles everything EXCEPT opto://login-callback (which belongs
/// to the auth handler).
class DeepLinkHandler {
  DeepLinkHandler._();

  // ── opto:// host → GoRouter path mapping ─────────────────────────────────
  // Hosts mirror the VoiceIntent routePaths from core/voice/voice_intent.dart
  // so voice commands and external deep links share one routing table.
  static const Map<String, String> _hostRoutes = {
    'vision': '/vision-ai',
    'prosthetic': '/prosthetic-hub',
    'consult': '/consult',
    'community': '/community',
    'sos': '/sos',
    'settings': '/profile',
    'home': '/home',
    'aura': '/aura',
  };

  /// Returns true for any opto:// URI that is NOT the auth callback.
  static bool isFeatureLink(Uri uri) =>
      uri.scheme == 'opto' && uri.host != 'login-callback';

  /// Maps an opto:// URI to a GoRouter path, or null if unknown host.
  static String? routeFor(Uri uri) => _hostRoutes[uri.host];

  /// Starts the deep-link listener. Call this from [App]'s [State.initState].
  ///
  /// - [router]: The app's [GoRouter] instance (from app_router.dart).
  ///
  /// Behaviour:
  /// - Subscribes to AppLinks.uriLinkStream for links while app is running.
  /// - Calls getInitialLink() for cold-start links; navigation is deferred to
  ///   the first post-frame callback so the router is ready.
  /// - Auth callbacks (opto://login-callback) are silently ignored here —
  ///   they are handled by main.dart's _initDeepLinks().
  static void start(GoRouter router) {
    final appLinks = AppLinks();

    // Live stream — app already running.
    appLinks.uriLinkStream.listen(
      (uri) {
        if (!isFeatureLink(uri)) return;
        final path = routeFor(uri);
        if (path != null) router.go(path);
        // Unknown host: silently ignore (future hosts handled by later phases).
      },
      onError: (Object e) => debugPrint('[DeepLinkHandler] stream error: $e'),
    );

    // Cold-start — app opened via a deep link.
    // Use addPostFrameCallback so GoRouter's initial route is set first.
    appLinks.getInitialLink().then((uri) {
      if (uri == null || !isFeatureLink(uri)) return;
      final path = routeFor(uri);
      if (path == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) => router.go(path));
    }).catchError((dynamic e) {
      debugPrint('[DeepLinkHandler] getInitialLink error: $e');
      return null;
    });
  }
}
