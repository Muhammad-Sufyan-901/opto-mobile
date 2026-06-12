// Cubit for the Care Guides list screen.
//
// Loads guides from [CareGuidesRepository] and exposes a [CareGuidesState]
// stream for [CareGuidesScreen] to react to.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/care_guides_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/care_guides_state.dart';

export 'care_guides_state.dart';

/// Cubit that drives the Care Guides list.
///
/// Call [load] once after construction (typically inside `BlocProvider.create`)
/// to trigger the data fetch.
class CareGuidesCubit extends Cubit<CareGuidesState> {
  CareGuidesCubit(this._repo) : super(const CareGuidesState.initial());

  final CareGuidesRepository _repo;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Fetches all care guides and emits [CareGuidesLoaded] on success.
  ///
  /// Emits [CareGuidesLoading] first, then either [CareGuidesLoaded] or
  /// [CareGuidesError]. The [isClosed] guard ensures we never emit after the
  /// cubit has been disposed (e.g. user popped the screen before the async
  /// operation completed).
  Future<void> load() async {
    emit(const CareGuidesState.loading());
    try {
      final guides = await _repo.getCareGuides();
      if (!isClosed) emit(CareGuidesState.loaded(guides));
    } on Exception catch (e) {
      if (!isClosed) {
        emit(CareGuidesState.error(e.toString().replaceAll('Exception: ', '')));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const CareGuidesState.error('Something went wrong. Please try again.'));
      }
    }
  }
}
