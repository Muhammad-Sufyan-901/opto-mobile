// Domain entity for a guided eye-care exercise.
//
// Pure-Dart representation used in use-cases and BLoC states —
// no Supabase / serialisation dependencies.
//
// Corresponds to the `eye_care_exercises` table in the Supabase database.

/// Immutable domain representation of a guided eye-care exercise.
///
/// [medicalDisclaimer] is REQUIRED and MUST be displayed on screen and read
/// aloud (via TTS) before or during exercise playback.  Never suppress it.
class EyeCareExerciseEntity {
  const EyeCareExerciseEntity({
    required this.id,
    required this.title,
    required this.audioGuidePath,
    required this.durationSeconds,
    required this.medicalDisclaimer,
  });

  /// Primary key (UUID).
  final String id;

  /// Human-readable exercise title (e.g. "Palming Relaxation").
  final String title;

  /// Storage path to the audio guidance file; resolve to a signed URL via
  /// the repository before playback.
  final String audioGuidePath;

  /// Total duration of the exercise in seconds.
  final int durationSeconds;

  /// Medical disclaimer text.  MUST be displayed and read aloud to the user
  /// before exercise playback — never omit or truncate.
  final String medicalDisclaimer;

  EyeCareExerciseEntity copyWith({
    String? id,
    String? title,
    String? audioGuidePath,
    int? durationSeconds,
    String? medicalDisclaimer,
  }) {
    return EyeCareExerciseEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      audioGuidePath: audioGuidePath ?? this.audioGuidePath,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      medicalDisclaimer: medicalDisclaimer ?? this.medicalDisclaimer,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EyeCareExerciseEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          audioGuidePath == other.audioGuidePath &&
          durationSeconds == other.durationSeconds &&
          medicalDisclaimer == other.medicalDisclaimer;

  @override
  int get hashCode =>
      Object.hash(id, title, audioGuidePath, durationSeconds, medicalDisclaimer);
}
