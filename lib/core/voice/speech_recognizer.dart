import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Abstract interface for speech-to-text — keeps the STT implementation
/// swappable (real device vs. test stub) without coupling [VoiceController]
/// to a concrete package.
abstract class SpeechRecognizer {
  /// Initialises the speech engine.
  ///
  /// Returns `true` if the engine is available and ready; `false` if the
  /// platform does not support STT or the user denied the microphone permission.
  Future<bool> initialize();

  /// Starts listening and forwards each **final** result phrase to [onResult].
  ///
  /// Implementations MUST emit only finalised (non-partial) results so that
  /// [VoiceController] can immediately parse and act on the phrase.
  Future<void> startListening({required void Function(String phrase) onResult});

  /// Stops an active listening session gracefully.
  Future<void> stopListening();

  /// Whether the engine is currently in a listening session.
  bool get isListening;

  /// Releases any underlying resources.
  void dispose();
}

/// Production implementation backed by the `speech_to_text` package.
///
/// Locale defaults to `id_ID` (Indonesian) which also accepts English because
/// Opto targets bilingual ID/EN users.
///
/// Thread-safety: `speech_to_text` v7 dispatches all result/error callbacks on
/// the main isolate, so [_handleResult] and [_handleError] may call Flutter
/// APIs (including [ChangeNotifier.notifyListeners] via [VoiceController])
/// without additional synchronisation.
final class SpeechToTextRecognizer implements SpeechRecognizer {
  SpeechToTextRecognizer() : _stt = SpeechToText();

  final SpeechToText _stt;
  void Function(String phrase)? _onResult;

  // ---------------------------------------------------------------------------
  // SpeechRecognizer interface
  // ---------------------------------------------------------------------------

  @override
  Future<bool> initialize() async {
    return _stt.initialize(
      onError: _handleError,
      debugLogging: false,
    );
  }

  @override
  Future<void> startListening({
    required void Function(String phrase) onResult,
  }) async {
    _onResult = onResult;
    await _stt.listen(
      onResult: _handleResult,
      listenOptions: SpeechListenOptions(
        localeId: 'id_ID',
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: false, // emit only final results
      ),
    );
  }

  @override
  Future<void> stopListening() async {
    await _stt.stop();
    _onResult = null;
  }

  @override
  bool get isListening => _stt.isListening;

  @override
  void dispose() {
    _stt.cancel();
    _onResult = null;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _handleResult(SpeechRecognitionResult result) {
    if (!result.finalResult) return; // guard: only emit final phrases
    final phrase = result.recognizedWords.trim();
    if (phrase.isEmpty) return;
    _onResult?.call(phrase);
  }

  void _handleError(SpeechRecognitionError error) {
    // Errors are surfaced via [isListening] becoming false.
    // [VoiceController] observes that transition and updates its state.
    // Log at debug level for diagnostics (e.g., 'permission denied', 'timeout').
    debugPrint('[SpeechToTextRecognizer] error: ${error.errorMsg} '
        '(permanent: ${error.permanent})');
  }
}
