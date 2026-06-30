abstract class Failure {
  final String message;

  const Failure(this.message);
}

// Failure from Server
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Failure from API rate-limiting (HTTP 429 / Gemini quota exhausted).
// BLoC presenters should surface a distinct "try again tomorrow" message
// rather than the generic offline fallback.
class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message);
}

// Failure from Local Storage
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Failure from Network
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Failure from Sensor/AI
class SensorFailure extends Failure {
  const SensorFailure(super.message);
}

// Failure from Supabase Auth (sign-in, sign-up, OTP, session)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// Failure from Supabase Storage (upload, download, signed URL)
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

// Failure when a requested resource does not exist (HTTP 404 / PGRST116).
// BLoC presenters should show a "not found" or "no results" state rather
// than a generic error.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

// Failure when an operation conflicts with existing data (HTTP 409 / 23505).
// Typical cause: booking a slot that has already been taken by another patient.
// BLoC presenters should surface a human-readable "try another slot" message.
class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}

// Failure from device location service (GPS unavailable, permission denied).
// BLoC presenters should fall back to distance-agnostic results rather than
// blocking the user on a location error.
class LocationFailure extends Failure {
  const LocationFailure(super.message);
}
