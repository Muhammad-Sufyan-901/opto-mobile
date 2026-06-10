import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';

/// Thin accessor for Supabase Storage operations.
///
/// Only repositories (and other `core/` helpers) should depend on this
/// provider — widgets must never call Storage directly.
///
/// Usage:
/// ```dart
/// final url = await StorageClientProvider.createSignedUrl(
///   'eye-photos', 'user-id/photo.jpg',
/// );
/// ```
class StorageClientProvider {
  StorageClientProvider._();

  /// The initialized [SupabaseStorageClient] instance.
  ///
  /// Throws a [StateError] if accessed before [Supabase.initialize] has
  /// been called in [main.dart].
  static SupabaseStorageClient get storage => Supabase.instance.client.storage;

  /// Creates a short-lived signed URL for [path] in [bucket].
  ///
  /// [expiresIn] is the URL lifetime in seconds (default: 3600 = 1 hour).
  ///
  /// Throws a [ServerFailure] if Supabase Storage returns a [StorageException].
  static Future<String> createSignedUrl(
    String bucket,
    String path, {
    int expiresIn = 3600,
  }) async {
    try {
      return await storage.from(bucket).createSignedUrl(path, expiresIn);
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  /// Uploads raw [bytes] to [path] in [bucket].
  ///
  /// [contentType] defaults to `'application/octet-stream'` when not provided.
  ///
  /// Returns the stored object path on success.
  /// Throws a [ServerFailure] if Supabase Storage returns a [StorageException].
  static Future<String> uploadBinary(
    String bucket,
    String path,
    Uint8List bytes, {
    String? contentType,
  }) async {
    try {
      return await storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType ?? 'application/octet-stream',
            ),
          );
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  /// Replaces an existing object at [path] in [bucket] with new [bytes].
  ///
  /// [contentType] defaults to `'application/octet-stream'` when not provided.
  ///
  /// Returns the stored object path on success.
  /// Throws a [ServerFailure] if Supabase Storage returns a [StorageException].
  static Future<String> updateBinary(
    String bucket,
    String path,
    Uint8List bytes, {
    String? contentType,
  }) async {
    try {
      return await storage.from(bucket).updateBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType ?? 'application/octet-stream',
            ),
          );
    } on StorageException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
