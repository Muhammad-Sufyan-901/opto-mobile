import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';

/// Remote data source that proxies camera frames to the Anthropic Claude
/// multimodal LLM via the `scene-describe` Supabase Edge Function.
///
/// The Edge Function holds the Anthropic API key as a server-side secret —
/// it never reaches the client. Only the Supabase anon key is used here.
///
/// Access is gated by `verify_jwt = true` on the function, so the user
/// must be authenticated (RLS `auth.uid()` present in the JWT) before
/// the function accepts the request.
class SceneDescribeRemoteDatasource {
  const SceneDescribeRemoteDatasource();

  // Client-side timeout before falling back to on-device (risk flag #1
  // from the Phase 3F plan — scene-describe latency > 3 s).
  static const _timeout = Duration(seconds: 8);

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Calls the `scene-describe` Edge Function with the JPEG image at
  /// [filePath] and returns a [SceneResult] with [SceneResultSource.cloud].
  ///
  /// Throws [NetworkFailure] when the function call times out.
  /// Throws [ServerFailure] when the function returns an error response.
  Future<SceneResult> describeScene(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await SupabaseClientProvider.client.functions
          .invoke(
            'scene-describe',
            body: {'image': base64Image},
          )
          .timeout(
            _timeout,
            onTimeout: () => throw NetworkFailure(
              'Deskripsi adegan habis waktu. '
              'Scene description timed out.',
            ),
          );

      final data = response.data as Map<String, dynamic>?;
      final description = data?['description'] as String?;

      if (description == null || description.trim().isEmpty) {
        throw const ServerFailure(
          'Fungsi scene-describe mengembalikan respons kosong.',
        );
      }

      return SceneResult(
        description: description.trim(),
        source: SceneResultSource.cloud,
      );
    } on NetworkFailure {
      rethrow;
    } on ServerFailure {
      rethrow;
    } on FunctionException catch (e) {
      debugPrint('[SceneDescribeRemote] FunctionException: $e');
      throw ServerFailure(
        'scene-describe: ${e.details?.toString() ?? e.toString()}',
      );
    } catch (e) {
      debugPrint('[SceneDescribeRemote] unexpected error: $e');
      throw ServerFailure(e.toString());
    }
  }
}
