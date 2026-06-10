// Pure-Dart domain entity for a tutorial in the Prosthetic Hub care tutorials.
//
// No serialisation dependencies — use [CareTutorialModel.toEntity()] in
// the data layer to produce instances from Supabase rows.
import 'package:opto/core/constants/prosthetic_enums.dart';

/// Immutable domain representation of a row in the `care_tutorials` table.
class CareTutorialEntity {
  const CareTutorialEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.transcript,
    required this.sortOrder,
    this.videoPath,
    this.audioNarrationPath,
  });

  /// Primary key (UUID).
  final String id;

  /// Human-readable tutorial title.
  final String title;

  /// Care-task category — mirrors the `tutorial_category` Postgres enum.
  final TutorialCategory category;

  /// Supabase Storage path for the tutorial video (nullable).
  final String? videoPath;

  /// Supabase Storage path for the audio narration (nullable).
  final String? audioNarrationPath;

  /// Full text transcript — always present (WCAG equivalent alternative).
  final String transcript;

  /// Display order within a category (ascending).
  final int sortOrder;

  CareTutorialEntity copyWith({
    String? id,
    String? title,
    TutorialCategory? category,
    String? videoPath,
    String? audioNarrationPath,
    String? transcript,
    int? sortOrder,
  }) {
    return CareTutorialEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      videoPath: videoPath ?? this.videoPath,
      audioNarrationPath: audioNarrationPath ?? this.audioNarrationPath,
      transcript: transcript ?? this.transcript,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareTutorialEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          category == other.category &&
          videoPath == other.videoPath &&
          audioNarrationPath == other.audioNarrationPath &&
          transcript == other.transcript &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        category,
        videoPath,
        audioNarrationPath,
        transcript,
        sortOrder,
      );
}
