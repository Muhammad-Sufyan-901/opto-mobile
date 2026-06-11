// Cubit for the add-new-POI form screen.
//
// Submits a new `accessibility_pois` row. The caller supplies the device
// position (acquired by the screen using [LocationService]).
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/accessibility_map/domain/repositories/poi_repository.dart';
import 'add_poi_state.dart';

export 'add_poi_state.dart';

/// Cubit that drives the add-POI form screen.
///
/// Inject via the abstract [PoiRepository] contract.
class AddPoiCubit extends Cubit<AddPoiState> {
  AddPoiCubit(this._repo) : super(const AddPoiInitial());

  final PoiRepository _repo;

  /// Validates and submits a new POI.
  ///
  /// [attributes] keys should come from [PoiAttribute.jsonKey].
  /// [lat] and [lng] are the device's current position, not user input.
  Future<void> submit({
    required String name,
    required double lat,
    required double lng,
    required Map<String, bool> attributes,
  }) async {
    if (name.trim().isEmpty) {
      emit(const AddPoiError('Please enter a name for this place.'));
      return;
    }

    emit(const AddPoiSubmitting());
    try {
      final poi = await _repo.addPoi(
        name: name.trim(),
        lat: lat,
        lng: lng,
        attributes: attributes,
      );
      emit(AddPoiSuccess(
        poiId: poi.id,
        message: '${poi.name} has been added to the map. Thank you!',
      ));
    } on Failure catch (f) {
      emit(AddPoiError(_toMessage(f)));
    } catch (e) {
      emit(AddPoiError(e.toString()));
    }
  }

  void reset() => emit(const AddPoiInitial());

  // ── helpers ───────────────────────────────────────────────────────────────

  String _toMessage(Failure f) {
    return switch (f) {
      NetworkFailure() =>
        'No internet connection. Please check your network and try again.',
      AuthFailure() => 'Please sign in to add a new place.',
      _ => f.message,
    };
  }
}
