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

/// Immutable domain representation of a prosthetic care guide.
///
/// [transcript] is the full step-by-step guide text surfaced in the detail
/// screen and read aloud by the audio player when [hasAudio] is true.
class CareGuide {
  const CareGuide({
    required this.id,
    required this.title,
    required this.category,
    required this.transcript,
    required this.hasAudio,
    required this.durationLabel,
    required this.sortOrder,
  });

  /// Primary key (string UUID or slug).
  final String id;

  /// Display title shown on the card and detail screen header.
  final String title;

  /// Which care step this guide covers.
  final CareGuideCategory category;

  /// Full step-by-step guide text displayed in the detail screen.
  final String transcript;

  /// Whether a pre-recorded audio version of the guide is available.
  final bool hasAudio;

  /// Human-readable estimated listening / reading time (e.g. "~2 min").
  final String durationLabel;

  /// Controls display order in the list (ascending).
  final int sortOrder;

  // ---------------------------------------------------------------------------
  // copyWith
  // No nullable fields — simple null-coalescing pattern is sufficient.
  // ---------------------------------------------------------------------------

  CareGuide copyWith({
    String? id,
    String? title,
    CareGuideCategory? category,
    String? transcript,
    bool? hasAudio,
    String? durationLabel,
    int? sortOrder,
  }) {
    return CareGuide(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      transcript: transcript ?? this.transcript,
      hasAudio: hasAudio ?? this.hasAudio,
      durationLabel: durationLabel ?? this.durationLabel,
      sortOrder: sortOrder ?? this.sortOrder,
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
          sortOrder == other.sortOrder;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        category,
        transcript,
        hasAudio,
        durationLabel,
        sortOrder,
      );
}
