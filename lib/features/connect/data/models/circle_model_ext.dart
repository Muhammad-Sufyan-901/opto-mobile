// Extension methods on data-layer models to produce domain entities.
//
// Kept in a separate file so the freezed-generated code does not need to be
// regenerated when entity mapping logic changes.
import 'package:opto/features/connect/data/models/circle_model.dart';
import 'package:opto/features/connect/domain/entities/circle_entity.dart';

/// Maps [CircleModel] to the pure-Dart [CircleEntity] used in the domain
/// and presentation layers.
///
/// Joined / aggregated fields (memberCount, isMember) are NOT on the model
/// itself — they are passed in as optional arguments and assembled by the
/// data source after executing the enriched PostgREST query.
extension CircleModelX on CircleModel {
  CircleEntity toEntity({
    int memberCount = 0,
    bool isMember = false,
  }) {
    return CircleEntity(
      id: id,
      slug: slug,
      name: name,
      description: description,
      about: about,
      iconKey: iconKey,
      colorKey: colorKey,
      pinnedNote: pinnedNote,
      memberCount: memberCount,
      isMember: isMember,
    );
  }
}
