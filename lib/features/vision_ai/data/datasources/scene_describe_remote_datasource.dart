import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';
import 'package:opto/features/vision_ai/data/datasources/image_compressor.dart';
import 'package:opto/features/vision_ai/domain/entities/vision_result.dart';

/// Remote data source that proxies compressed camera frames to the Gemini
/// 2.5 Flash-Lite multimodal LLM via the `scene-describe` Supabase Edge
/// Function.
///
/// **Provider:** Google Gemini 2.5 Flash-Lite (free plan, dev-only by default;
/// paid plan for production). The [VisionAiConfig.cloudSceneAllowed] gate in
/// [VisionRepositoryImpl] prevents this class being called in production when
/// the free tier is configured — Gemini's free tier trains on submitted data,
/// which violates UU PDP for real user camera frames (see
/// `vision_ai_model_research.md` §2 "Critical implementation nuance").
/// Switch to the paid plan by setting `SCENE_DESCRIBE_TIER=paid` in `.env`
/// and providing a billing-enabled `GEMINI_API_KEY` secret.
///
/// The Edge Function holds the GEMINI_API_KEY as a server-side secret;
/// only the Supabase anon key is used here. Access is gated by
/// `verify_jwt = true`, so the user must be authenticated before the
/// function accepts the request.
///
/// **Proxy-and-discard:** frames are processed in-memory inside the Edge
/// Function and never written to Storage or logged (UU PDP compliance).
///
/// **Compression:** frames are resized to a 1024 px longest edge at JPEG
/// quality 85 before base64-encoding. This happens in a background isolate
/// via [ImageCompressor.compressToJpeg] and keeps the upload well inside
/// the Edge Function's ~1 MB base64 ceiling.
///
/// **Latency:** measured round-trips to the deployed function range ~3-21 s
/// (cold start + Gemini vision inference, occasionally retried server-side
/// up to 3 attempts on a transient 5xx — see
/// `supabase/functions/scene-describe/index.ts`). The client timeout below
/// is sized to that reality; do not lower it without re-measuring, or most
/// calls will spuriously fall back on-device.
class SceneDescribeRemoteDatasource {
  const SceneDescribeRemoteDatasource();

  // Client-side timeout before the repository falls back to the on-device
  // path (see `vision_repository_impl.dart`).
  static const _timeout = Duration(seconds: 30);

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Compresses the JPEG at [filePath], calls the `scene-describe` Edge
  /// Function, and returns a [SceneResult] with [SceneResultSource.cloud].
  ///
  /// Throws [NetworkFailure] when the function call times out.
  /// Throws [ServerFailure] when the function returns an error response.
  Future<SceneResult> describeScene(String filePath) async {
    try {
      // ── 1. Read raw bytes ──────────────────────────────────────────────────
      final rawBytes = await File(filePath).readAsBytes();

      // ── 2. Compress in background isolate (1024 px / JPEG 85) ─────────────
      // Keeps upload time well inside the 3 s end-to-end latency budget
      // (research §2 implementation nuance #1).
      final compressed =
          await ImageCompressor.compressToJpeg(rawBytes);
      final base64Image = base64Encode(compressed);

      // ── 3. Invoke Edge Function ────────────────────────────────────────────
      final response = await SupabaseClientProvider.client.functions
          .invoke(
            'scene-describe',
            body: {'image': base64Image},
          )
          .timeout(
            _timeout,
            onTimeout: () => throw NetworkFailure(
              'Deskripsi adegan habis waktu — coba lagi.',
            ),
          );

      // ── 4. Parse response ──────────────────────────────────────────────────
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
    } on RateLimitFailure {
      rethrow;
    } on ServerFailure {
      rethrow;
    } on FunctionException catch (e) {
      debugPrint('[SceneDescribeRemote] FunctionException: $e');
      // Supabase surfaces non-2xx as FunctionException with a numeric `status`.
      // Map HTTP 429 (both Gemini upstream quota and the in-function limiter)
      // to RateLimitFailure so the repository can tag the result distinctly
      // from a generic offline/server failure.
      if (e.status == 429) {
        final details = e.details;
        // Check for code:"quota" from the Edge Function's jsonQuotaError helper.
        if (details is Map && details['code'] == 'quota') {
          throw RateLimitFailure(
            details['error']?.toString() ??
                'Batas harian deskripsi tercapai. Coba lagi besok.',
          );
        }
        throw const RateLimitFailure(
          'Batas harian deskripsi tercapai. Coba lagi besok.',
        );
      }
      throw ServerFailure(
        'scene-describe: ${e.details?.toString() ?? e.toString()}',
      );
    } catch (e) {
      debugPrint('[SceneDescribeRemote] unexpected error: $e');
      throw ServerFailure(e.toString());
    }
  }
}
