// Concrete implementation of [AuthRepository].
//
// Delegates to [AuthRemoteDataSource] for all Supabase Auth calls.
// After a successful sign-in or OTP verification it persists the user's
// role string to [SecureStorageHelper] so that [RolesMiddleware] can
// read it from local storage without an extra round-trip.
import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/core/supabase/supabase_error_mapper.dart';
import 'package:opto/core/utils/secure_storage_helper.dart';
import 'package:opto/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:opto/features/auth/domain/repositories/auth_repository.dart';

/// Production implementation of [AuthRepository].
///
/// Exceptions that escape the data source are already typed [Failure]
/// subclasses — they propagate up to the BLoC, which catches and maps
/// them to error states.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageHelper secureStorage,
  })  : _remote = remoteDataSource,
        _storage = secureStorage;

  final AuthRemoteDataSource _remote;
  final SecureStorageHelper _storage;

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
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _remote.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );

    // Upsert a minimal `profiles` row so RLS policies have a row to work with
    // even before the user completes onboarding.
    //
    // If sign-up requires email confirmation the session may be null here —
    // skip the upsert in that case (the profile trigger or onboarding will
    // create it after the user confirms).
    final user = response.user;
    if (user != null) {
      try {
        await SupabaseClientProvider.client.from('profiles').upsert({
          'id': user.id,
          'role': 'user',
          'full_name': ?fullName,
        });
        await _storage.saveRole('user');
      } on Object catch (e) {
        // Profile upsert failure should not block sign-up — the auth succeeded.
        // Surface as a non-fatal concern (log in production, swallow here).
        // ignore: avoid_print
        print('[AuthRepositoryImpl] profile upsert warning: $e');
      }
    }
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

      final row = await SupabaseClientProvider.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();

      final role = (row['role'] as String?) ?? 'user';
      await _storage.saveRole(role);
    } on Object catch (e) {
      // Role persistence is a best-effort optimisation — don't let it fail
      // the primary sign-in flow.
      final failure = SupabaseErrorMapper.fromException(e);
      // ignore: avoid_print
      print('[AuthRepositoryImpl] role persistence warning: $failure');
    }
  }
}
