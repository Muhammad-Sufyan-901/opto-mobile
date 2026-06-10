// Concrete implementation of [AuthRepository].
//
// Delegates to [AuthRemoteDataSource] for all Supabase Auth and profiles
// calls.  After a successful sign-in or OTP verification it persists the
// user's role string to [SecureStorageHelper] so that [RolesMiddleware] can
// read it from local storage without an extra round-trip.
import 'package:flutter/foundation.dart' show debugPrint;

import 'package:opto/core/utils/secure_storage_helper.dart';
import 'package:opto/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:opto/features/auth/domain/repositories/auth_repository.dart'
    show AuthRepository, SignUpOutcome;
import 'package:opto/features/profile/domain/repositories/accessibility_settings_repository.dart';

/// Production implementation of [AuthRepository].
///
/// Exceptions that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageHelper secureStorage,
    required AccessibilitySettingsRepository settingsRepository,
  })  : _remote = remoteDataSource,
        _storage = secureStorage,
        _settingsRepo = settingsRepository;

  final AuthRemoteDataSource _remote;
  final SecureStorageHelper _storage;
  final AccessibilitySettingsRepository _settingsRepo;

  // ── sign in ────────────────────────────────────────────────────────────────

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await _remote.signInWithPassword(email: email, password: password);
    await _persistRoleFromCurrentUser();
  }

  // ── sign up ────────────────────────────────────────────────────────────────

  @override
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _remote.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );

    // When "Confirm email" is ON (the hosted Supabase default), signUp returns
    // a User but a null Session — the account exists but the user must click the
    // confirmation link before they can sign in.  In that case we skip the
    // profile upsert: without a session auth.uid() is null and the RLS INSERT
    // policy would reject it anyway.
    //
    // When confirmation is OFF (or the project uses auto-confirm), a session IS
    // returned immediately — upsert the minimal profile row and persist the role
    // so onboarding can read it.  The auth-state stream will fire and the BLoC
    // will emit AuthAuthenticated on its own.
    if (response.session != null) {
      // Session available — user is authenticated immediately.
      final user = response.user;
      if (user != null) {
        try {
          // CRITICAL 1 & 2: delegate to data source; 'role' is NOT in the payload.
          await _remote.upsertMinimalProfile(
            userId: user.id,
            fullName: fullName,
          );
          await _storage.saveRole('user');
        } on Object catch (e) {
          // Profile upsert failure should not block sign-up — the auth succeeded.
          debugPrint('[AuthRepositoryImpl] profile upsert warning: $e');
        }
      }
      return SignUpOutcome.authenticated;
    }

    // No session — email confirmation is required before sign-in is possible.
    return SignUpOutcome.emailConfirmationRequired;
  }

  // ── OTP ───────────────────────────────────────────────────────────────────

  @override
  Future<void> signInWithOtp({required String phone}) async {
    await _remote.signInWithOtp(phone: phone);
  }

  @override
  Future<void> verifyOtp({required String phone, required String otp}) async {
    await _remote.verifyOtp(phone: phone, otp: otp);
    await _persistRoleFromCurrentUser();
  }

  // ── sign out ───────────────────────────────────────────────────────────────

  @override
  Future<void> signOut() async {
    await _remote.signOut();
    await _storage.clearAll();
    // CRITICAL 3: clear Hive accessibility settings cache on sign-out.
    await _settingsRepo.clearCache();
  }

  // ── stream ────────────────────────────────────────────────────────────────

  @override
  Stream<bool> get isAuthenticated => _remote.authStateChanges;

  // ── helpers ───────────────────────────────────────────────────────────────

  /// Reads the role from the `profiles` table for the current user and
  /// persists it to secure storage.  Silently swallowed on failure.
  Future<void> _persistRoleFromCurrentUser() async {
    try {
      final userId = _remote.currentUser?.id;
      if (userId == null) return;

      // CRITICAL 1: delegate to data source instead of calling Supabase directly.
      final role = await _remote.getRoleForCurrentUser(userId) ?? 'user';
      await _storage.saveRole(role);
    } on Object catch (e) {
      // Role persistence is a best-effort optimisation — don't let it fail
      // the primary sign-in flow.
      debugPrint('[AuthRepositoryImpl] role persistence warning: $e');
    }
  }
}
