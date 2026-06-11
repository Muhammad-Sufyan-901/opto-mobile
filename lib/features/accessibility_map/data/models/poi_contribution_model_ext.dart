// Extension methods to convert [PoiContributionModel] → domain entity.
import 'package:opto/features/accessibility_map/data/models/poi_contribution_model.dart';
import 'package:opto/features/accessibility_map/domain/entities/poi_contribution_entity.dart';

/// Maps [PoiContributionModel] → [PoiContributionEntity].
extension PoiContributionModelX on PoiContributionModel {
  PoiContributionEntity toEntity() => PoiContributionEntity(
        id: id,
        poiId: poiId,
        userId: userId,
        change: change,
        status: status,
        createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      );
}
