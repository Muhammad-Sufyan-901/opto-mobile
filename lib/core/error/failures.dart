abstract class Failure {
  final String message;

  const Failure(this.message);
}

// Failure from Server
class ServerFailure extends Failure {
  const ServerFailure(super.message);
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
