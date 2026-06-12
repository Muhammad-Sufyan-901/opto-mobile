import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';

/// Maps Supabase SDK exceptions to typed [Failure] values used by repositories.
///
/// Keeps the Supabase dependency out of domain/presentation layers —
/// call this inside `data/` (data sources or repository implementations).
///
/// Usage:
/// ```dart
/// try {
///   final data = await client.from('profiles').select().single();
/// } on PostgrestException catch (e) {
///   return Left(SupabaseErrorMapper.fromPostgrest(e));
/// } on AuthException catch (e) {
///   return Left(SupabaseErrorMapper.fromAuth(e));
/// }
/// ```
class SupabaseErrorMapper {
  SupabaseErrorMapper._();

  // ──────────────────────────────────────────────────────────────────────────
  // PostgREST (database / RLS) errors
  // ──────────────────────────────────────────────────────────────────────────

  static Failure fromPostgrest(PostgrestException e) {
    final code = e.code;

    // PGRST116: no rows returned (map to NotFoundFailure, not ServerFailure)
    if (code == 'PGRST116') {
      return NotFoundFailure('Tidak ditemukan: ${e.message}');
    }

    // 42501 / RLS violation
    if (code == '42501') {
      return ServerFailure(
        'Anda tidak memiliki izin untuk melakukan tindakan ini.',
      );
    }

    // 23505: unique violation → ConflictFailure so BLoCs can show
    // domain-specific messages (e.g. "slot already taken")
    if (code == '23505') {
      return ConflictFailure(
        'Data sudah ada atau slot tidak tersedia.',
      );
    }

    // 23503: foreign key violation
    if (code == '23503') {
      return ServerFailure(
        'Operasi gagal karena data terkait tidak ditemukan.',
      );
    }

    // HTTP-range error codes surfaced by PostgREST
    final statusCode = int.tryParse(code ?? '') ?? 0;
    if (statusCode >= 500) {
      return ServerFailure(
        'Server sedang mengalami gangguan. Mohon coba lagi nanti.',
      );
    }

    return ServerFailure(e.message);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Auth errors
  // ──────────────────────────────────────────────────────────────────────────

  static Failure fromAuth(AuthException e) {
    final message = e.message.toLowerCase();

    // "Email not confirmed" is a distinct case from wrong credentials —
    // the user registered but hasn't clicked the confirmation link yet.
    if (message.contains('email not confirmed')) {
      return const AuthFailure(
        'Please confirm your email first — we sent a confirmation link to your inbox.',
      );
    }

    if (message.contains('invalid login credentials')) {
      return const AuthFailure(
        'Email or password is incorrect. Please check and try again.',
      );
    }

    if (message.contains('email already registered') ||
        message.contains('user already registered')) {
      return const AuthFailure(
        'Email ini sudah terdaftar. Silakan masuk atau gunakan email lain.',
      );
    }

    if (message.contains('token') && message.contains('expired')) {
      return const AuthFailure(
        'Sesi Anda telah berakhir. Silakan masuk kembali.',
      );
    }

    if (message.contains('rate limit')) {
      return const AuthFailure(
        'Terlalu banyak percobaan. Silakan tunggu beberapa saat.',
      );
    }

    if (message.contains('otp') || message.contains('invalid otp')) {
      return const AuthFailure(
        'Kode OTP tidak valid atau telah kedaluwarsa.',
      );
    }

    return AuthFailure(e.message);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Storage errors
  // ──────────────────────────────────────────────────────────────────────────

  static Failure fromStorage(StorageException e) {
    final statusCode = int.tryParse(e.statusCode ?? '') ?? 0;

    if (statusCode == 400) {
      return StorageFailure('File tidak valid: ${e.message}');
    }

    if (statusCode == 403) {
      return const StorageFailure(
        'Anda tidak memiliki izin untuk mengakses file ini.',
      );
    }

    if (statusCode == 404) {
      return const StorageFailure('File tidak ditemukan.');
    }

    if (statusCode >= 500) {
      return const StorageFailure(
        'Layanan penyimpanan sedang bermasalah. Mohon coba lagi.',
      );
    }

    return StorageFailure(e.message);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Generic fallback
  // ──────────────────────────────────────────────────────────────────────────

  /// Converts any Supabase-related exception to a [Failure].
  /// Prefer the specific methods above when the exception type is known.
  static Failure fromException(Object e) {
    if (e is PostgrestException) return fromPostgrest(e);
    if (e is AuthException) return fromAuth(e);
    if (e is StorageException) return fromStorage(e);
    return ServerFailure(e.toString());
  }
}
