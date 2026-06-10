// Tests for IntentParser — lib/core/voice/intent_parser.dart
//
// The parser is pure Dart with no Flutter SDK dependencies,
// so all tests are synchronous plain `test()` blocks.
//
// Coverage:
//  Group 1  — English phrases map to the correct VoiceIntent (all 9)
//  Group 2  — Indonesian phrases map to the correct VoiceIntent (all 9)
//  Group 3  — Slot extraction for FindDoctorIntent and NavigateToIntent
//  Group 4  — Ambiguous phrases → NeedsConfirmation
//  Group 5  — Unknown / empty phrases → UnknownPhrase
//  Group 6  — Emergency priority
//  Group 7  — Case and punctuation normalisation

import 'package:flutter_test/flutter_test.dart';

import 'package:opto/core/voice/intent_parser.dart';
import 'package:opto/core/voice/voice_intent.dart';

void main() {
  const parser = IntentParser();

  // ---------------------------------------------------------------------------
  // Group 1 — English → intent (all 9 intents)
  // ---------------------------------------------------------------------------

  group('Group 1: English phrase → intent', () {
    test('describe this → DescribeSceneIntent', () {
      final result = parser.parse('describe this');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<DescribeSceneIntent>());
    });

    test('read text → ReadTextIntent', () {
      final result = parser.parse('read text');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<ReadTextIntent>());
    });

    test('order prosthetic → OrderProstheticIntent', () {
      final result = parser.parse('order prosthetic');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<OrderProstheticIntent>());
    });

    test('find a doctor → FindDoctorIntent (no slot)', () {
      final result = parser.parse('find a doctor');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<FindDoctorIntent>());
      // No doctor name provided → slot is null
      expect(intent.slot, isNull);
    });

    test('my schedule → MyScheduleIntent', () {
      final result = parser.parse('my schedule');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<MyScheduleIntent>());
    });

    test('open community → OpenCommunityIntent', () {
      final result = parser.parse('open community');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<OpenCommunityIntent>());
    });

    test('navigate to the pharmacy → NavigateToIntent', () {
      final result = parser.parse('navigate to the pharmacy');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<NavigateToIntent>());
      expect(intent.slot, 'the pharmacy');
    });

    test('call emergency → CallEmergencyIntent', () {
      final result = parser.parse('call emergency');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<CallEmergencyIntent>());
    });

    test('accessibility settings → AccessibilitySettingsIntent', () {
      final result = parser.parse('accessibility settings');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<AccessibilitySettingsIntent>());
    });
  });

  // ---------------------------------------------------------------------------
  // Group 2 — Indonesian phrase → intent (all 9 intents)
  // ---------------------------------------------------------------------------

  group('Group 2: Indonesian phrase → intent', () {
    test('apa ini → DescribeSceneIntent', () {
      final result = parser.parse('apa ini');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<DescribeSceneIntent>());
    });

    test('baca teks → ReadTextIntent', () {
      final result = parser.parse('baca teks');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<ReadTextIntent>());
    });

    test('pesan prostetik → OrderProstheticIntent', () {
      final result = parser.parse('pesan prostetik');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<OrderProstheticIntent>());
    });

    test('cari dokter → FindDoctorIntent', () {
      final result = parser.parse('cari dokter');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<FindDoctorIntent>());
    });

    test('jadwal saya → MyScheduleIntent', () {
      final result = parser.parse('jadwal saya');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<MyScheduleIntent>());
    });

    test('buka komunitas → OpenCommunityIntent', () {
      final result = parser.parse('buka komunitas');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<OpenCommunityIntent>());
    });

    test('navigasi ke apotek → NavigateToIntent with destination "apotek"', () {
      final result = parser.parse('navigasi ke apotek');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<NavigateToIntent>());
      expect(intent.slot, 'apotek');
    });

    test('darurat → CallEmergencyIntent', () {
      final result = parser.parse('darurat');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<CallEmergencyIntent>());
    });

    test('perbesar teks → AccessibilitySettingsIntent', () {
      final result = parser.parse('perbesar teks');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<AccessibilitySettingsIntent>());
    });
  });

  // ---------------------------------------------------------------------------
  // Group 3 — Slot extraction
  // ---------------------------------------------------------------------------

  group('Group 3: Slot extraction', () {
    test('call dr Anwar → FindDoctorIntent with slot "anwar" (lowercased)', () {
      final result = parser.parse('call dr Anwar');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<FindDoctorIntent>());
      expect(intent.slot, 'anwar');
    });

    test('panggil dr Budi → FindDoctorIntent with slot "budi" (lowercased)', () {
      final result = parser.parse('panggil dr Budi');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<FindDoctorIntent>());
      expect(intent.slot, 'budi');
    });

    test('navigate to the pharmacy → NavigateToIntent slot "the pharmacy"', () {
      final result = parser.parse('navigate to the pharmacy');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<NavigateToIntent>());
      expect(intent.slot, 'the pharmacy');
    });

    test('take me to the hospital → NavigateToIntent slot "the hospital"', () {
      final result = parser.parse('take me to the hospital');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<NavigateToIntent>());
      expect(intent.slot, 'the hospital');
    });

    test('navigasi ke apotek → NavigateToIntent slot "apotek"', () {
      final result = parser.parse('navigasi ke apotek');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<NavigateToIntent>());
      expect(intent.slot, 'apotek');
    });

    test('find doctor (no name prefix) → FindDoctorIntent slot is null', () {
      final result = parser.parse('find doctor');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<FindDoctorIntent>());
      // _extractDoctorSlot returns '' for generic match → stored as null
      expect(intent.slot, isNull);
    });

    test('call doctor Smith → FindDoctorIntent slot "smith"', () {
      final result = parser.parse('call doctor Smith');
      expect(result, isA<ResolvedIntent>());
      final intent = (result as ResolvedIntent).intent;
      expect(intent, isA<FindDoctorIntent>());
      expect(intent.slot, 'smith');
    });
  });

  // ---------------------------------------------------------------------------
  // Group 4 — Ambiguity → NeedsConfirmation
  // ---------------------------------------------------------------------------

  group('Group 4: Ambiguous phrases → NeedsConfirmation', () {
    // "navigate to community" matches both _extractNavigationSlot (starts with
    // "navigate to ") AND _matchesOpenCommunity (contains "community").
    // Result: 2 candidates → NeedsConfirmation.
    test('navigate to community → NeedsConfirmation (navigation + community)', () {
      final result = parser.parse('navigate to community');
      expect(result, isA<NeedsConfirmation>());
    });

    // "navigate to komunitas" also hits both matchers (Indonesian community word).
    test('navigasi ke komunitas → NeedsConfirmation (navigation + community)', () {
      final result = parser.parse('navigasi ke komunitas');
      expect(result, isA<NeedsConfirmation>());
    });

    // The NeedsConfirmation hint is the first matching intent's description.
    test('navigate to community → hint is not empty', () {
      final result = parser.parse('navigate to community') as NeedsConfirmation;
      expect(result.hint, isNotEmpty);
    });

    // The NeedsConfirmation phrase is the normalised (not raw) phrase.
    test('navigate to community → phrase field is normalised', () {
      final result = parser.parse('navigate to community') as NeedsConfirmation;
      expect(result.phrase, 'navigate to community');
    });
  });

  // ---------------------------------------------------------------------------
  // Group 5 — UnknownPhrase
  // ---------------------------------------------------------------------------

  group('Group 5: UnknownPhrase', () {
    test('"hello world" → UnknownPhrase', () {
      final result = parser.parse('hello world');
      expect(result, isA<UnknownPhrase>());
    });

    test('"!?!" (punctuation only) → UnknownPhrase', () {
      final result = parser.parse('!?!');
      expect(result, isA<UnknownPhrase>());
    });

    test('empty string → UnknownPhrase', () {
      final result = parser.parse('');
      expect(result, isA<UnknownPhrase>());
    });

    test('"random words xyz" → UnknownPhrase', () {
      final result = parser.parse('random words xyz');
      expect(result, isA<UnknownPhrase>());
    });

    test('UnknownPhrase preserves original (trimmed) phrase', () {
      final result = parser.parse('  hello world  ') as UnknownPhrase;
      expect(result.phrase, 'hello world');
    });
  });

  // ---------------------------------------------------------------------------
  // Group 6 — Emergency is highest priority
  // ---------------------------------------------------------------------------

  group('Group 6: Emergency priority', () {
    test('"sos" → CallEmergencyIntent', () {
      final result = parser.parse('sos');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<CallEmergencyIntent>());
    });

    test('"tolong" → CallEmergencyIntent (Indonesian)', () {
      final result = parser.parse('tolong');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<CallEmergencyIntent>());
    });

    // "help find a doctor" matches emergency (contains "help") AND
    // find-doctor (contains "find a doctor"). Because the result has
    // > 1 candidate, it returns NeedsConfirmation with the emergency
    // intent as the first (highest priority) candidate, so hint is
    // the emergency hint.
    test('"help find a doctor" → NeedsConfirmation; hint is emergency', () {
      final result = parser.parse('help find a doctor');
      expect(result, isA<NeedsConfirmation>());
      final nc = result as NeedsConfirmation;
      // Emergency is always the first candidate, so its hint surfaces first.
      expect(nc.hint.toLowerCase(), contains('emergency'));
    });

    // A standalone "call emergency" is unambiguous → resolved to emergency.
    test('"call emergency" → single ResolvedIntent (CallEmergencyIntent)', () {
      final result = parser.parse('call emergency');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<CallEmergencyIntent>());
    });
  });

  // ---------------------------------------------------------------------------
  // Group 7 — Case / punctuation normalisation
  // ---------------------------------------------------------------------------

  group('Group 7: Normalisation', () {
    test('READ TEXT (all caps) → ReadTextIntent', () {
      final result = parser.parse('READ TEXT');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<ReadTextIntent>());
    });

    test('"describe this!!!" (trailing punctuation) → DescribeSceneIntent', () {
      final result = parser.parse('describe this!!!');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<DescribeSceneIntent>());
    });

    test('"  navigate to the pharmacy  " (extra whitespace) → NavigateToIntent', () {
      final result = parser.parse('  navigate to the pharmacy  ');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<NavigateToIntent>());
    });

    test('mixed case "Accessibility Settings" → AccessibilitySettingsIntent', () {
      final result = parser.parse('Accessibility Settings');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<AccessibilitySettingsIntent>());
    });

    test('"My Schedule" (title case) → MyScheduleIntent', () {
      final result = parser.parse('My Schedule');
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<MyScheduleIntent>());
    });

    test('apostrophe stripped: "what\'s in front of me" → DescribeSceneIntent', () {
      // After normalise: "whats in front of me" which contains the trigger.
      final result = parser.parse("what's in front of me");
      expect(result, isA<ResolvedIntent>());
      expect((result as ResolvedIntent).intent, isA<DescribeSceneIntent>());
    });
  });
}
