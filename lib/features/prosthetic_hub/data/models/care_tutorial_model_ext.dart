// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/prosthetic_hub/data/models/care_tutorial_model.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_tutorial_entity.dart';

/// Maps [CareTutorialModel] to the pure-Dart [CareTutorialEntity]
/// used in the domain and presentation layers.
extension CareTutorialModelX on CareTutorialModel {
  CareTutorialEntity toEntity() => CareTutorialEntity(
        id: id,
        title: title,
        category: category,
        videoPath: videoPath,
        audioNarrationPath: audioNarrationPath,
        transcript: transcript,
        sortOrder: sortOrder,
      );
}
