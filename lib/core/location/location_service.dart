// Cross-cutting location service for Opto.
//
// Wraps `geolocator` with typed outcomes so callers never see raw exceptions.
// Re-used by:
//  - Accessibility Map  (Phase 3B) — "nearby POIs" bounding-box query
//  - Emergency SOS      (Phase 3E) — attach device position to SOS event
//
// Callers must handle every [LocationResult] variant; in particular they must
// surface [LocationPermissionDenied] and [LocationServiceDisabled] to the user
// via a spoken status (live region) before graceful degradation.
//
// IMPORTANT: Permission rationale strings live in:
//   - android/app/src/main/AndroidManifest.xml
//     (ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION)
//   - ios/Runner/Info.plist
//     (NSLocationWhenInUseUsageDescription)
import 'package:geolocator/geolocator.dart';

// =============================================================================
// RESULT TYPES
// =============================================================================

/// Typed result returned by [LocationService.getCurrentPosition].
sealed class LocationResult {
  const LocationResult();
}

/// Position successfully acquired.
final class LocationSuccess extends LocationResult {
  const LocationSuccess(this.position);

  /// Device position from geolocator.
  final Position position;
}

/// User denied the location permission.
///
/// [permanentlyDenied] is true when the OS "don't ask again" flag is set —
/// the caller should open app settings instead of re-requesting.
final class LocationPermissionDenied extends LocationResult {
  const LocationPermissionDenied({this.permanentlyDenied = false});

  final bool permanentlyDenied;
}

/// Location services (GPS/network) are off at the OS level.
final class LocationServiceDisabled extends LocationResult {
  const LocationServiceDisabled();
}

/// Position request timed out or raised an unexpected error.
final class LocationError extends LocationResult {
  const LocationError(this.message);

  final String message;
}

// =============================================================================
// ABSTRACT CONTRACT
// =============================================================================

/// Contract for obtaining the device's current geographic position.
abstract class LocationService {
  const LocationService();

  /// Requests permission (if needed), then returns the device's current
  /// position.
  ///
  /// Never throws — all outcomes are encoded in [LocationResult].
  Future<LocationResult> getCurrentPosition();

  /// Returns the last known position without requesting a fresh fix.
  ///
  /// Useful as an instant fallback before [getCurrentPosition] resolves.
  /// Returns `null` if no cached position is available.
  Future<Position?> getLastKnownPosition();
}

// =============================================================================
// IMPLEMENTATION
// =============================================================================

/// Production implementation backed by `geolocator`.
///
/// Desired accuracy: [LocationAccuracy.medium] — good enough for a
/// bounding-box POI query while preserving battery life.
/// Timeout: 10 seconds — surfaces [LocationError] rather than hanging.
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  static const Duration _timeout = Duration(seconds: 10);

  @override
  Future<LocationResult> getCurrentPosition() async {
    // 1. Check if location services are enabled at the OS level.
    final servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      return const LocationServiceDisabled();
    }

    // 2. Check / request permission.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationPermissionDenied(permanentlyDenied: true);
    }
    if (permission == LocationPermission.denied) {
      return const LocationPermissionDenied();
    }

    // 3. Acquire position.
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: _timeout,
        ),
      );
      return LocationSuccess(position);
    } on LocationServiceDisabledException {
      return const LocationServiceDisabled();
    } on PermissionDefinitionsNotFoundException catch (e) {
      return LocationError(
        'Location permission not declared in platform config: ${e.message}',
      );
    } catch (e) {
      return LocationError(e.toString());
    }
  }

  @override
  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }
}
