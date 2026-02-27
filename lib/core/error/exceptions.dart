// Base Exception
abstract class BaseException implements Exception {
  final String message;

  const BaseException({
    required this.message,
  });
}

// Thrown when there is a problem with the API / Server (Backend)
class ServerException extends BaseException {
  final int? statusCode;

  const ServerException({
    required super.message,
    this.statusCode,
  });
}

// Thrown when there is a problem with the local database
class CacheException extends BaseException {
  const CacheException({
    required super.message,
  });
}

// Thrown when the device has no internet connection
class NetworkException extends BaseException {
  const NetworkException({
    super.message =
        'Tidak ada koneksi internet. Mohon periksa jaringan internet Anda.',
  });
}
