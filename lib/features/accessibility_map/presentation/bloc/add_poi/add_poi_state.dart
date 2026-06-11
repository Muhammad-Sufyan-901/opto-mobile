// State definitions for [AddPoiCubit].

sealed class AddPoiState {
  const AddPoiState();
}

class AddPoiInitial extends AddPoiState {
  const AddPoiInitial();
}

class AddPoiSubmitting extends AddPoiState {
  const AddPoiSubmitting();
}

class AddPoiSuccess extends AddPoiState {
  const AddPoiSuccess({required this.poiId, required this.message});

  /// The newly created POI's UUID.
  final String poiId;
  final String message;
}

class AddPoiError extends AddPoiState {
  const AddPoiError(this.message);
  final String message;
}
