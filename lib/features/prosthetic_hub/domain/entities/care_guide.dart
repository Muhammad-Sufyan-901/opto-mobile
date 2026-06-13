// Domain entity for a prosthetic care guide.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.

/// Categories of prosthetic care guide available in the Opto Prosthetic Hub.
enum CareGuideCategory {
  /// How to insert the ocular prosthesis.
  insert,

  /// How to remove the ocular prosthesis.
  remove,

  /// Daily cleaning routine for the prosthesis.
  clean,

  /// Lubrication guidance for comfort.
  lubricate,

  /// How to use the storage case when not wearing the prosthesis.
  caseUse,
}

/// A single numbered step within a [CareGuide].
///
/// [title] is the short action label shown in the step heading.
/// [body] is the detailed instruction text.
/// [tip] is an optional safety / important-note callout (displayed in a tinted
/// tip box below the body text when non-null).
class CareGuideStep {
  const CareGuideStep({
    required this.title,
    required this.body,
    this.tip,
  });

  /// Short action label (e.g. "Wash your hands").
  final String title;

  /// Full instruction text displayed below the heading.
  final String body;

  /// Optional safety / note callout. When non-null, a tip box is shown.
  final String? tip;

  // ---------------------------------------------------------------------------
  // Equality & hashCode
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareGuideStep &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          body == other.body &&
          tip == other.tip;

  @override
  int get hashCode => Object.hash(title, body, tip);
}

/// Immutable domain representation of a prosthetic care guide.
///
/// [transcript] is the full step-by-step guide text kept for audio narration
/// and as a fallback when [steps] is empty.
/// [steps] is the structured breakdown used to render the numbered step-by-step
/// detail layout introduced in the M3 redesign.
class CareGuide {
  const CareGuide({
    required this.id,
    required this.title,
    required this.category,
    required this.transcript,
    required this.hasAudio,
    required this.durationLabel,
    required this.sortOrder,
    this.steps = const [],
  });

  /// Primary key (string UUID or slug).
  final String id;

  /// Display title shown on the card and detail screen header.
  final String title;

  /// Which care step this guide covers.
  final CareGuideCategory category;

  /// Full step-by-step guide text kept for audio narration and fallback render.
  final String transcript;

  /// Whether a pre-recorded audio version of the guide is available.
  final bool hasAudio;

  /// Human-readable estimated listening / reading time (e.g. "~2 min").
  final String durationLabel;

  /// Controls display order in the list (ascending).
  final int sortOrder;

  /// Structured steps used by the M3 numbered detail layout.
  /// Populated by the repository; defaults to empty.
  final List<CareGuideStep> steps;

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  CareGuide copyWith({
    String? id,
    String? title,
    CareGuideCategory? category,
    String? transcript,
    bool? hasAudio,
    String? durationLabel,
    int? sortOrder,
    List<CareGuideStep>? steps,
  }) {
    return CareGuide(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      transcript: transcript ?? this.transcript,
      hasAudio: hasAudio ?? this.hasAudio,
      durationLabel: durationLabel ?? this.durationLabel,
      sortOrder: sortOrder ?? this.sortOrder,
      steps: steps ?? this.steps,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality & hashCode
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareGuide &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          category == other.category &&
          transcript == other.transcript &&
          hasAudio == other.hasAudio &&
          durationLabel == other.durationLabel &&
          sortOrder == other.sortOrder &&
          steps == other.steps;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        category,
        transcript,
        hasAudio,
        durationLabel,
        sortOrder,
        Object.hashAll(steps),
      );
}

/// Human-readable display label for each [CareGuideCategory].
extension CareGuideCategoryLabel on CareGuideCategory {
  String get displayLabel => switch (this) {
        CareGuideCategory.insert => 'Inserting',
        CareGuideCategory.remove => 'Removing',
        CareGuideCategory.clean => 'Cleaning',
        CareGuideCategory.lubricate => 'Lubricating',
        CareGuideCategory.caseUse => 'Case Use',
      };
}
