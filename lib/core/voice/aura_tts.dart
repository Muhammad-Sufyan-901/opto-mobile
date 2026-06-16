import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Aura text-to-speech engine — registered as a GetIt lazy singleton.
///
/// Produces audible output for Vision AI results (OCR, object labels,
/// scene descriptions) and other Aura announcements so that results are
/// heard even when no platform screen reader (TalkBack / VoiceOver) is
/// active.
///
/// Two settings are kept in sync with [AccessibilitySettingsEntity]
/// via [setEnabled] / [setRate], called by `app.dart`'s BlocBuilder
/// whenever [AccessibilitySettingsCubit] reports a change — mirroring
/// the pattern used by [VoiceController.setVoiceEnabled].
///
/// Usage:
/// ```dart
/// await sl<AuraTts>().speak('Bank Mandiri is in front of you.');
/// ```
class AuraTts extends ChangeNotifier {
  AuraTts() : _tts = FlutterTts();

  final FlutterTts _tts;

  bool _enabled = true;

  // speakingRate: 0.0 (slowest) → 1.0 (fastest); mirrors
  // AccessibilitySettingsEntity.speakingRate (default 0.45).
  double _rate = 0.45;
  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // Configuration API (called from app.dart)
  // ---------------------------------------------------------------------------

  /// Syncs spoken-guidance preference with
  /// [AccessibilitySettingsEntity.spokenGuidanceEnabled].
  ///
  /// If guidance is being disabled while speech is in progress, the
  /// ongoing utterance is stopped immediately.
  void setEnabled(bool enabled) {
    if (_enabled == enabled) return;
    _enabled = enabled;
    if (!enabled) _tts.stop();
    notifyListeners();
  }

  /// Syncs speaking rate with
  /// [AccessibilitySettingsEntity.speakingRate] (0.0–1.0).
  void setRate(double rate) {
    if (_rate == rate) return;
    _rate = rate;
    // Apply immediately if already initialised.
    if (_initialized) _tts.setSpeechRate(rate);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Speaks [text] aloud, if spoken guidance is enabled.
  ///
  /// Stops any ongoing utterance first so the latest result always
  /// takes precedence over a still-speaking earlier result.
  Future<void> speak(String text) async {
    if (!_enabled || text.trim().isEmpty) return;
    await _ensureInitialized();
    await _tts.stop();
    await _tts.speak(text);
  }

  /// Stops any ongoing speech immediately.
  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    // id-ID locale: natively Indonesian, also accepts English input —
    // consistent with SpeechToTextRecognizer's localeId choice.
    await _tts.setLanguage('id-ID');
    await _tts.setSpeechRate(_rate);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
    debugPrint('[AuraTts] TTS engine initialised (rate=$_rate).');
  }
}
