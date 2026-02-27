class HttpStatus {
  // 2xx Success
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // 4xx Client Error
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;

  // 5xx Server Error
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
}
