import 'voice_intent.dart';

/// Pure-Dart, stateless parser that maps a raw STT phrase to a [VoiceResult].
///
/// - No Flutter SDK imports.
/// - No side-effects; fully deterministic given the same input.
/// - Bilingual: accepts both English and Indonesian (ID) phrases.
/// - Priority order: Emergency > all others (to prevent accidental SOS misfires
///   the other way — it should be easy to trigger emergency, not hard).
class IntentParser {
  const IntentParser();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Parses [rawPhrase] (raw STT output) into a [VoiceResult].
  ///
  /// Normalisation applied before matching:
  ///   1. [String.trim]
  ///   2. [String.toLowerCase]
  ///   3. Remove common punctuation (`.`, `,`, `?`, `!`, `'`, `"`)
  VoiceResult parse(String rawPhrase) {
    final phrase = _normalise(rawPhrase);
    if (phrase.isEmpty) return UnknownPhrase(rawPhrase.trim());

    // Build the ordered list of candidate matches.
    // Each entry is (VoiceIntent factory, description for confirmation hint).
    // We evaluate them in priority order:
    //   1. Emergency (highest — must never be skipped)
    //   2. Remaining intents in catalog order
    final candidates = <_Match>[];

    // 1. Emergency
    if (_matchesEmergency(phrase)) {
      candidates.add(_Match(const CallEmergencyIntent(), 'Call Emergency / SOS'));
    }

    // 2. Describe scene
    if (_matchesDescribeScene(phrase)) {
      candidates.add(_Match(const DescribeSceneIntent(), 'Describe scene'));
    }

    // 3. Read text
    if (_matchesReadText(phrase)) {
      candidates.add(_Match(const ReadTextIntent(), 'Read text'));
    }

    // 4. Order prosthetic
    if (_matchesOrderProsthetic(phrase)) {
      candidates.add(_Match(const OrderProstheticIntent(), 'Order prosthetic'));
    }

    // 5. Find doctor (with slot extraction)
    final doctorSlot = _extractDoctorSlot(phrase);
    if (doctorSlot != null) {
      candidates.add(_Match(
        FindDoctorIntent(doctorName: doctorSlot.isEmpty ? null : doctorSlot),
        'Find a doctor',
      ));
    }

    // 6. My schedule
    if (_matchesMySchedule(phrase)) {
      candidates.add(_Match(const MyScheduleIntent(), 'My appointments / schedule'));
    }

    // 7. Open community
    if (_matchesOpenCommunity(phrase)) {
      candidates.add(_Match(const OpenCommunityIntent(), 'Open community'));
    }

    // 8. Navigate to (with slot extraction)
    final destination = _extractNavigationSlot(phrase);
    if (destination != null) {
      candidates.add(_Match(
        NavigateToIntent(destination: destination.isEmpty ? null : destination),
        'Navigate to a place',
      ));
    }

    // 9. Accessibility settings
    if (_matchesAccessibilitySettings(phrase)) {
      candidates.add(_Match(
        const AccessibilitySettingsIntent(),
        'Accessibility settings',
      ));
    }

    // Always return the trimmed raw phrase (not normalised) so callers can
    // display what the user actually said (correct casing, punctuation).
    if (candidates.isEmpty) return UnknownPhrase(rawPhrase.trim());
    if (candidates.length == 1) return ResolvedIntent(candidates.first.intent);

    // Ambiguous — more than one intent matched.
    return NeedsConfirmation(
      phrase: phrase,
      hint: candidates.first.hint,
    );
  }

  // ---------------------------------------------------------------------------
  // Normalisation
  // ---------------------------------------------------------------------------

  static String _normalise(String raw) =>
      raw.trim().toLowerCase().replaceAll(RegExp("[.,?!'\"]+"), '');

  // ---------------------------------------------------------------------------
  // Per-intent matchers
  // ---------------------------------------------------------------------------

  // 1. Emergency — EN: "call emergency", "sos", "help"
  //               ID: "panggil darurat", "darurat", "tolong"
  static bool _matchesEmergency(String p) {
    // Note: `contains` subsumes equality — no `p == 'x'` guards needed.
    return p.contains('sos') ||
        p.contains('help') ||
        p.contains('call emergency') ||
        p.contains('emergency') ||
        p.contains('panggil darurat') ||
        p.contains('darurat') ||
        p.contains('tolong');
  }

  // 2. Describe scene — EN: "whats in front of me", "describe this",
  //                         "describe scene", "what do i see"
  //                    ID: "apa ini", "deskripsikan",
  //                         "apa yang ada di depan"
  //
  // Note: _normalise strips apostrophes, so "what's" → "whats" before matching.
  static bool _matchesDescribeScene(String p) {
    return p.contains('whats in front of me') ||
        p.contains('describe this') ||
        p.contains('describe scene') ||
        p.contains('what do i see') ||
        p.contains('apa ini') ||
        p.contains('deskripsikan') ||
        p.contains('apa yang ada di depan');
  }

  // 3. Read text — EN: "read text", "read this", "ocr"
  //               ID: "baca teks", "baca ini"
  static bool _matchesReadText(String p) {
    return p.contains('read text') ||
        p.contains('read this') ||
        p.contains('ocr') ||
        p.contains('baca teks') ||
        p.contains('baca ini');
  }

  // 4. Order prosthetic — EN: "order prosthetic", "prosthetic"
  //                       ID: "pesan prostetik", "prostetik"
  static bool _matchesOrderProsthetic(String p) {
    return p.contains('order prosthetic') ||
        p.contains('prosthetic') ||
        p.contains('pesan prostetik') ||
        p.contains('prostetik');
  }

  // 5. Find doctor — EN: "find a doctor", "find doctor", "call dr ___"
  //                  ID: "cari dokter", "panggil dr ___"
  // Returns the extracted slot string (possibly empty), or null if no match.
  static String? _extractDoctorSlot(String p) {
    // "call dr <name>" or "panggil dr <name>"
    const callDrPrefixes = [
      'call dr ',
      'call dr. ',
      'panggil dr ',
      'panggil dr. ',
      'call doctor ',
    ];
    for (final prefix in callDrPrefixes) {
      if (p.startsWith(prefix)) {
        return p.substring(prefix.length).trim();
      }
    }
    // Generic find-doctor phrases (no slot)
    if (p.contains('find a doctor') ||
        p.contains('find doctor') ||
        p.contains('cari dokter')) {
      return ''; // match confirmed, no slot
    }
    return null; // no match
  }

  // 6. My schedule — EN: "my schedule", "my appointments"
  //                  ID: "jadwal saya", "jadwal"
  static bool _matchesMySchedule(String p) {
    return p.contains('my schedule') ||
        p.contains('my appointments') ||
        p.contains('jadwal saya') ||
        p.contains('jadwal');
  }

  // 7. Open community — EN: "open community", "community"
  //                     ID: "buka komunitas", "komunitas"
  static bool _matchesOpenCommunity(String p) {
    return p.contains('open community') ||
        p.contains('community') ||
        p.contains('buka komunitas') ||
        p.contains('komunitas');
  }

  // 8. Navigate to — EN: "navigate to ___", "take me to ___"
  //                  ID: "navigasi ke ___", "pergi ke ___"
  // Returns the extracted destination string (possibly empty), or null if no match.
  static String? _extractNavigationSlot(String p) {
    const navigatePrefixes = [
      'navigate to ',
      'take me to ',
      'navigasi ke ',
      'pergi ke ',
    ];
    for (final prefix in navigatePrefixes) {
      if (p.startsWith(prefix)) {
        return p.substring(prefix.length).trim();
      }
    }
    return null;
  }

  // 9. Accessibility settings — EN: "accessibility settings", "dark mode",
  //                                  "increase text", "enlarge text"
  //                             ID: "perbesar teks", "mode gelap",
  //                                  "pengaturan aksesibilitas"
  static bool _matchesAccessibilitySettings(String p) {
    return p.contains('accessibility settings') ||
        p.contains('dark mode') ||
        p.contains('increase text') ||
        p.contains('enlarge text') ||
        p.contains('perbesar teks') ||
        p.contains('mode gelap') ||
        p.contains('pengaturan aksesibilitas');
  }
}

// ---------------------------------------------------------------------------
// Internal helper
// ---------------------------------------------------------------------------

class _Match {
  final VoiceIntent intent;
  final String hint;
  const _Match(this.intent, this.hint);
}
