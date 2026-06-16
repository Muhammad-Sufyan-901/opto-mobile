// ignore_for_file: avoid_print, depend_on_referenced_packages
// One-off script to upload the 5 prosthetic-supply product images to
// Supabase Storage (bucket: product-images).
//
// Usage:
//   SUPABASE_URL=https://xxx.supabase.co \
//   SUPABASE_SERVICE_ROLE_KEY=eyJ... \
//   dart run tool/upload_supply_images.dart
//
// The service-role key is required so the upload bypasses RLS.
// Never commit this key; pass it only via environment variables.

import 'dart:io';

import 'package:supabase/supabase.dart';

const _bucket = 'product-images';

// Paths relative to the project root.
const _images = [
  'assets/images/supplies/daily_cleaning_solution.png',
  'assets/images/supplies/self_cleaning_case.png',
  'assets/images/supplies/standard_storage_case.png',
  'assets/images/supplies/prosthetic_care_kit.png',
  'assets/images/supplies/microfiber_cleaning_cloth.png',
];

Future<void> main() async {
  // ── 1. Read credentials from environment ──────────────────────────────────
  final url = Platform.environment['SUPABASE_URL'];
  final serviceRoleKey = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];

  if (url == null || url.isEmpty) {
    stderr.writeln('Error: SUPABASE_URL environment variable is not set.');
    stderr.writeln('');
    stderr.writeln('Usage:');
    stderr.writeln(
      '  SUPABASE_URL=https://xxx.supabase.co \\',
    );
    stderr.writeln(
      '  SUPABASE_SERVICE_ROLE_KEY=eyJ... \\',
    );
    stderr.writeln('  dart run tool/upload_supply_images.dart');
    exit(1);
  }

  if (serviceRoleKey == null || serviceRoleKey.isEmpty) {
    stderr.writeln(
      'Error: SUPABASE_SERVICE_ROLE_KEY environment variable is not set.',
    );
    stderr.writeln('');
    stderr.writeln('Usage:');
    stderr.writeln(
      '  SUPABASE_URL=https://xxx.supabase.co \\',
    );
    stderr.writeln(
      '  SUPABASE_SERVICE_ROLE_KEY=eyJ... \\',
    );
    stderr.writeln('  dart run tool/upload_supply_images.dart');
    exit(1);
  }

  // ── 2. Initialise Supabase client with service-role key ───────────────────
  final client = SupabaseClient(url, serviceRoleKey);

  // ── 3. Upload each image ──────────────────────────────────────────────────
  int successCount = 0;

  for (final imagePath in _images) {
    final filename = imagePath.split('/').last; // e.g. daily_cleaning_solution.png

    print('Uploading $filename...');

    final file = File(imagePath);
    if (!file.existsSync()) {
      print('  ✗ $filename: file not found at $imagePath');
      continue;
    }

    final bytes = file.readAsBytesSync();

    try {
      await client.storage.from(_bucket).uploadBinary(
            filename,
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/png',
            ),
          );
      print('  ✓ $filename');
      successCount++;
    } on StorageException catch (e) {
      print('  ✗ $filename: ${e.message}');
    } catch (e) {
      print('  ✗ $filename: $e');
    }
  }

  // ── 4. Summary ────────────────────────────────────────────────────────────
  final total = _images.length;
  final failed = total - successCount;

  print('');
  if (failed == 0) {
    print('$total/$total uploaded successfully.');
  } else {
    print('$successCount/$total uploaded — $failed failed.');
  }

  // Dispose the client to close any open HTTP connections.
  client.dispose();

  exit(failed == 0 ? 0 : 1);
}
