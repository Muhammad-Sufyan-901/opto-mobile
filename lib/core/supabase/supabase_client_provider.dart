import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin accessor for the Supabase client singleton.
///
/// Repositories (and only repositories) should depend on this provider —
/// widgets must never call [SupabaseClient] directly.
///
/// Usage:
/// ```dart
/// final client = SupabaseClientProvider.client;
/// ```
class SupabaseClientProvider {
  SupabaseClientProvider._();

  /// The initialized [SupabaseClient] instance.
  ///
  /// Throws a [StateError] if accessed before [Supabase.initialize] has
  /// been called in [main.dart].
  static SupabaseClient get client => Supabase.instance.client;
}
