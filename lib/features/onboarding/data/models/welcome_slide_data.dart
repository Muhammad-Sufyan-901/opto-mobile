/// Presentation-layer data for a single Welcome intro slide.
///
/// No Freezed needed — it's a pure const data holder with no serialisation.
class WelcomeSlideData {
  const WelcomeSlideData({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.illustrationLabel,
    this.isLast = false,
  });

  /// Uppercase section tag (e.g. "WELCOME TO OPTO"). Already uppercased.
  final String eyebrow;

  /// Primary screen title — announced as a heading via [Semantics].
  final String title;

  /// Body paragraph — read at full volume by TalkBack / VoiceOver.
  final String body;

  /// Descriptive caption for the illustration placeholder (shown in mono).
  /// Used verbatim from the design canvas; replace with alt text once real
  /// illustration assets are supplied.
  final String illustrationLabel;

  /// When [true] the CTA button reads "Get started" instead of "Next".
  final bool isLast;
}

/// The three slides defined in the `Opto Onboarding.html` design file
/// (source: `screens-welcome.jsx` — copy is verbatim from the bundle).
const List<WelcomeSlideData> kWelcomeSlides = [
  WelcomeSlideData(
    eyebrow: 'WELCOME TO OPTO',
    title: 'One app for your whole day',
    body:
        'Read mail, navigate streets, identify objects and call for help — '
        'all in a single place built around how you see.',
    illustrationLabel: 'illustration: hand holding phone, warm scene',
  ),
  WelcomeSlideData(
    eyebrow: 'MADE TO BE HEARD',
    title: 'Speaks your language, listens too',
    body:
        'Every screen works with TalkBack and your voice. Large buttons, '
        'clear speech, and nothing buried more than a tap away.',
    illustrationLabel: 'illustration: sound waves + voice bubble',
  ),
  WelcomeSlideData(
    eyebrow: 'BUILT WITH YOU',
    title: 'Set up the way that fits you',
    body:
        'Tell Opto how you see and hear best. We tune text, contrast and '
        'voice so the app feels right from the very first tap.',
    illustrationLabel: 'illustration: person adjusting settings dial',
    isLast: true,
  ),
];
