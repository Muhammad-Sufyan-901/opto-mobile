import 'package:flutter/foundation.dart';

import 'intent_parser.dart';
import 'speech_recognizer.dart';
import 'voice_intent.dart';

/// Lifecycle state of [VoiceController].
enum VoiceControllerState {
  /// Engine idle — not listening, no pending result.
  idle,

  /// Initialising the STT engine (permission check + warm-up).
  initializing,

  /// Microphone open and listening for speech.
  listening,

  /// STT result received; parsing intent.
  processing,

  /// Intent parsed; [VoiceController.lastResult] is populated.
  result,

  /// An error occurred (STT unavailable, permission denied, etc.).
  error,
}

/// Core-level voice engine controller — registered as a GetIt lazy singleton.
///
/// Exposes the current [state], [lastResult], and [lastPhrase] via
/// [ChangeNotifier] so that the app shell (or any listener) can observe
/// transitions without requiring BuildContext or feature imports.
///
/// The controller deliberately does **not** import `go_router` or any
/// feature package — it only emits state. The app shell reads [lastResult]
/// and performs the actual navigation.
///
/// Voice can be globally disabled (e.g. when [AccessibilitySettingsCubit]
/// reports that the user turned it off) via [setVoiceEnabled].
class VoiceController extends ChangeNotifier {
  VoiceController({
    required SpeechRecognizer recognizer,
    required IntentParser parser,
  })  : _recognizer = recognizer,
        _parser = parser;

  final SpeechRecognizer _recognizer;
  final IntentParser _parser;

  // ---------------------------------------------------------------------------
  // State fields
  // ---------------------------------------------------------------------------

  VoiceControllerState _state = VoiceControllerState.idle;
  VoiceResult? _lastResult;
  String? _lastPhrase;
  bool _voiceEnabled = true;
  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // Public getters
  // ---------------------------------------------------------------------------

  /// Current lifecycle state of the controller.
  VoiceControllerState get state => _state;

  /// The most recent [VoiceResult] produced by [IntentParser], or `null`
  /// if no phrase has been parsed yet (or after [reset]).
  VoiceResult? get lastResult => _lastResult;

  /// The most recent normalised phrase that was parsed, or `null` if none.
  String? get lastPhrase => _lastPhrase;

  /// Whether voice input is currently enabled.
  bool get isVoiceEnabled => _voiceEnabled;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Called by `app.dart` when [AccessibilitySettingsCubit] reports a change
  /// to the voice-enabled preference.
  void setVoiceEnabled(bool enabled) {
    if (_voiceEnabled == enabled) return;
    _voiceEnabled = enabled;
    if (!enabled && _state == VoiceControllerState.listening) {
      // Stop an active session if voice is being disabled.
      stopListening();
    }
    notifyListeners();
  }

  /// Starts a listening session.
  ///
  /// Guards:
  /// - Voice must be enabled ([_voiceEnabled]).
  /// - Must not already be listening or initialising.
  Future<void> startListening() async {
    if (!_voiceEnabled) return;
    if (_state == VoiceControllerState.listening ||
        _state == VoiceControllerState.initializing) {
      return;
    }

    // Initialise once.
    if (!_initialized) {
      _setState(VoiceControllerState.initializing);
      final available = await _recognizer.initialize();
      if (!available) {
        _setState(VoiceControllerState.error);
        return;
      }
      _initialized = true;
    }

    _setState(VoiceControllerState.listening);

    try {
      await _recognizer.startListening(
        onResult: _handlePhrase,
      );
    } catch (_) {
      // Reset _initialized so the next call re-attempts engine initialisation.
      _initialized = false;
      _setState(VoiceControllerState.error);
    }
  }

  /// Stops an active listening session.
  ///
  /// Note: [lastResult] is NOT cleared — the app shell may still read it after
  /// stopping. Call [reset] to explicitly discard the last result.
  Future<void> stopListening() async {
    if (_state != VoiceControllerState.listening) return;
    await _recognizer.stopListening();
    _setState(VoiceControllerState.idle);
  }

  /// Resets the controller back to [VoiceControllerState.idle] and clears
  /// [lastResult] / [lastPhrase]. Useful after the app shell has consumed a result.
  void reset() {
    _lastResult = null;
    _lastPhrase = null;
    _setState(VoiceControllerState.idle);
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _handlePhrase(String phrase) {
    _lastPhrase = phrase;
    _setState(VoiceControllerState.processing);

    final result = _parser.parse(phrase);
    _lastResult = result;
    _setState(VoiceControllerState.result);
  }

  void _setState(VoiceControllerState next) {
    if (_state == next) return;
    _state = next;
    notifyListeners();
  }
}
