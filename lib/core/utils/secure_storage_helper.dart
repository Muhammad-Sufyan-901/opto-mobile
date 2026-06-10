import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage;

  // Key constants
  static const String _keyToken = 'auth_token';
  static const String _keyRole = 'user_role';

  SecureStorageHelper(this._storage);

  // ==========================================
  // CORE CRUD (WITH DYNAMIC KEYS)
  // ==========================================
  Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteString(String key) async {
    await _storage.delete(key: key);
  }

  Future<bool> hasString(String key) async {
    final value = await getString(key);
    return value != null && value.isNotEmpty;
  }

  // ==========================================
  // SPECIFIC CRUD (TOKEN & ROLE)
  // ==========================================

  // ==========================================
  // DEPRECATED TOKEN METHODS
  // (Session is now managed by Supabase Auth, not by storing a raw JWT token here.)
  // These methods are kept temporarily to avoid breaking any code that might reference
  // them, but they will be removed in a cleanup pass.
  // ==========================================

  /// @deprecated Supabase Auth manages the session. Use Supabase.instance.client.auth.currentSession.
  @Deprecated(
    'Session is managed by Supabase Auth. Use Supabase.instance.client.auth.currentSession.',
  )
  Future<void> saveToken(String token) => saveString(_keyToken, token);

  /// @deprecated Supabase Auth manages the session. Use Supabase.instance.client.auth.currentSession.
  @Deprecated(
    'Session is managed by Supabase Auth. Use Supabase.instance.client.auth.currentSession.',
  )
  Future<String?> getToken() => getString(_keyToken);

  /// @deprecated Supabase Auth manages the session. Use Supabase.instance.client.auth.currentSession.
  @Deprecated(
    'Session is managed by Supabase Auth. Use Supabase.instance.client.auth.currentSession.',
  )
  Future<void> deleteToken() => deleteString(_keyToken);

  /// @deprecated Supabase Auth manages the session. Use Supabase.instance.client.auth.currentSession.
  @Deprecated(
    'Session is managed by Supabase Auth. Use Supabase.instance.client.auth.currentSession.',
  )
  Future<bool> hasToken() => hasString(_keyToken);

  // -- Role
  Future<void> saveRole(String role) => saveString(_keyRole, role);
  Future<String?> getRole() => getString(_keyRole);
  Future<void> deleteRole() => deleteString(_keyRole);

  // -- Global
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
