/// Sealed class hierarchy representing every recognised Aura Voice intent.
///
/// Route path values mirror [AppRoutes] constants but are inlined here so that
/// `core/voice/` has no dependency on the router or any feature package.
sealed class VoiceIntent {
  /// The destination route path this intent navigates to.
  final String routePath;

  /// Optional entity slot extracted from the spoken phrase
  /// (e.g. doctor name for [FindDoctorIntent], destination for [NavigateToIntent]).
  final String? slot;

  const VoiceIntent({required this.routePath, this.slot});
}

/// Describes the scene in front of the camera → /vision-ai
final class DescribeSceneIntent extends VoiceIntent {
  const DescribeSceneIntent() : super(routePath: '/vision-ai');
}

/// Reads text via OCR → /vision-ai
final class ReadTextIntent extends VoiceIntent {
  const ReadTextIntent() : super(routePath: '/vision-ai');
}

/// Opens the prosthetic hub to place an order → /prosthetic-hub
final class OrderProstheticIntent extends VoiceIntent {
  const OrderProstheticIntent() : super(routePath: '/prosthetic-hub');
}

/// Finds or calls a specific doctor → /consult
/// [slot] holds the extracted doctor name if provided.
final class FindDoctorIntent extends VoiceIntent {
  const FindDoctorIntent({String? doctorName})
      : super(routePath: '/consult', slot: doctorName);
}

/// Opens the user's consultation schedule → /consult
final class MyScheduleIntent extends VoiceIntent {
  const MyScheduleIntent() : super(routePath: '/consult');
}

/// Opens the community screen → /community
final class OpenCommunityIntent extends VoiceIntent {
  const OpenCommunityIntent() : super(routePath: '/community');
}

/// Navigates to a named destination → /home
/// Routes to /home until the Accessibility Map feature (Phase 3) is implemented.
/// [slot] holds the extracted destination string.
final class NavigateToIntent extends VoiceIntent {
  const NavigateToIntent({String? destination})
      : super(routePath: '/home', slot: destination);
}

/// Triggers the Emergency SOS flow → /sos
final class CallEmergencyIntent extends VoiceIntent {
  const CallEmergencyIntent() : super(routePath: '/sos');
}

/// Opens accessibility settings → /profile
final class AccessibilitySettingsIntent extends VoiceIntent {
  const AccessibilitySettingsIntent() : super(routePath: '/profile');
}

// =============================================================================
// VoiceResult — the outcome of parsing a raw STT phrase
// =============================================================================

/// Sealed result returned by [IntentParser.parse].
sealed class VoiceResult {
  const VoiceResult();
}

/// The phrase was unambiguously matched to a [VoiceIntent].
final class ResolvedIntent extends VoiceResult {
  final VoiceIntent intent;
  const ResolvedIntent(this.intent);
}

/// The phrase is plausible but ambiguous — ask the user to confirm.
final class NeedsConfirmation extends VoiceResult {
  /// The original (normalised) phrase.
  final String phrase;

  /// A human-readable hint describing the first plausible intent.
  final String hint;

  const NeedsConfirmation({required this.phrase, required this.hint});
}

/// The phrase did not match any known intent.
final class UnknownPhrase extends VoiceResult {
  /// The original (normalised) phrase that could not be matched.
  final String phrase;
  const UnknownPhrase(this.phrase);
}
