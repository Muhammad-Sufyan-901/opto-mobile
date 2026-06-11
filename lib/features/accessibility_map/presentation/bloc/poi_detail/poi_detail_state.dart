// State definitions for [PoiDetailCubit].
import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';

sealed class PoiDetailState {
  const PoiDetailState();
}

class PoiDetailInitial extends PoiDetailState {
  const PoiDetailInitial();
}

class PoiDetailLoading extends PoiDetailState {
  const PoiDetailLoading();
}

class PoiDetailLoaded extends PoiDetailState {
  const PoiDetailLoaded(this.poi);
  final AccessibilityPoiEntity poi;
}

/// Contribution (verify / suggest-edit) submitted successfully.
///
/// The POI state is still shown; this triggers a spoken announcement.
class PoiDetailContributionSuccess extends PoiDetailState {
  const PoiDetailContributionSuccess({
    required this.poi,
    required this.message,
  });
  final AccessibilityPoiEntity poi;
  final String message;
}

/// A contribution submission is in progress (show activity indicator).
class PoiDetailContributing extends PoiDetailState {
  const PoiDetailContributing(this.poi);
  final AccessibilityPoiEntity poi;
}

class PoiDetailError extends PoiDetailState {
  const PoiDetailError(this.message);
  final String message;
}
