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
