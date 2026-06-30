/// Analysis modes available in the Vision AI ("Aura") screen.
///
/// Maps 1:1 to the four mode chips in the UI
/// (design_system.md §12.2 — "Read text / Identify / Describe scene / Colors").
enum VisionMode {
  /// On-device ML Kit OCR — reads text, Rupiah amounts, and signs.
  /// Works fully offline.
  readText,

  /// On-device ML Kit object detection — labels items in the frame.
  /// Works fully offline.
  identify,

  /// Cloud scene description via the `scene-describe` Edge Function
  /// (Google Gemini 2.5 Flash-Lite). Requires internet; graceful fallback
  /// when offline announces degraded mode and uses on-device object
  /// labels as a substitute. Cloud calls are gated to development builds
  /// on the free plan (see [VisionAiConfig.cloudSceneAllowed]).
  describeScene,

  /// On-device dominant-color analysis using pixel sampling.
  /// Works fully offline.
  colors;

  /// Bilingual (EN/ID) display label shown in the mode chip row.
  String get label => switch (this) {
        VisionMode.readText => 'Read text',
        VisionMode.identify => 'Identify',
        VisionMode.describeScene => 'Describe scene',
        VisionMode.colors => 'Colors',
      };

  /// Screen-reader label for the chip — includes mode context.
  String get semanticsLabel => switch (this) {
        VisionMode.readText => 'Read text mode',
        VisionMode.identify => 'Identify objects mode',
        VisionMode.describeScene => 'Describe scene mode',
        VisionMode.colors => 'Detect colors mode',
      };
}
