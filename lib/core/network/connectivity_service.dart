import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Thin wrapper around [InternetConnectionChecker] used by repositories
/// that need to gate cloud calls on network availability.
///
/// Registered as a GetIt lazy singleton so the underlying checker
/// is shared (and avoids redundant DNS lookups across callers).
///
/// Usage:
/// ```dart
/// if (await sl<ConnectivityService>().isOnline) { ... }
/// ```
class ConnectivityService {
  ConnectivityService()
      : _checker = InternetConnectionChecker.createInstance();

  final InternetConnectionChecker _checker;

  /// Returns `true` when the device has an active internet connection.
  ///
  /// Performs a lightweight TCP probe; resolves in < 2 s under normal
  /// conditions. Returns `false` in airplane mode or when DNS is
  /// unreachable — suitable for scene-describe offline gating.
  Future<bool> get isOnline => _checker.hasConnection;
}
