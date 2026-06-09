// Domain contract for authentication operations.
//
// Implementations live in the data layer
// (`lib/features/auth/data/repositories/auth_repository_impl.dart`).
//
// NOTE: This file must NOT import `supabase_flutter`, `hive`, or any
// infrastructure package — domain layer stays pure Dart.

/// Abstract contract for auth operations.
///
/// All methods throw a [Failure] subclass
/// (`lib/core/error/failures.dart`) on error rather than returning
/// Either — the BLoC layer catches typed failures and maps them to
/// error states.
abstract class AuthRepository {
  /// Signs in an existing user with email + password.
  ///
  /// Throws [AuthFailure] on invalid credentials, unconfirmed email, etc.
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  /// Creates a new account with email + password, optionally setting
  /// the user's full name in the `profiles` row.
  ///
  /// Throws [AuthFailure] if the email is already registered or
  /// the password does not meet Supabase's strength policy.
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  });

  /// Sends a one-time password (OTP) via SMS to [phone].
  ///
  /// [phone] must be in E.164 format (e.g. `+628123456789`).
  /// Throws [AuthFailure] on rate-limit or invalid number.
  Future<void> signInWithOtp({required String phone});

  /// Verifies the SMS OTP for [phone] and completes the sign-in.
  ///
  /// Throws [AuthFailure] if the OTP is expired or incorrect.
  Future<void> verifyOtp({required String phone, required String otp});

  /// Signs out the current user and clears the local Supabase session.
  ///
  /// Throws [AuthFailure] if the sign-out request fails.
  Future<void> signOut();

  /// Emits `true` when the user is authenticated and `false` after
  /// sign-out (or on session expiry).
  ///
  /// BLoC layers should subscribe to this stream on startup to react
  /// to session changes (deep-link sign-ins, token refresh failures, etc.).
  Stream<bool> get isAuthenticated;
}
