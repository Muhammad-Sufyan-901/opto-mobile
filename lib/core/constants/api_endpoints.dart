abstract class ApiEndpoints {
  // ==========================================
  // PREFIXES
  // ==========================================
  static const String authPrefix = '/auth';

  // ==========================================
  // AUTHENTICATION ENDPOINTS
  // ==========================================
  static const String login = '$authPrefix/login';
  static const String register = '$authPrefix/register';
  static const String logout = '$authPrefix/logout';
  static const String refreshToken = '$authPrefix/refresh';
}
