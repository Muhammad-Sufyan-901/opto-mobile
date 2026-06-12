// Cubit for the Specialist Directory screen.
//
// Loads the specialist list from [SpecialistRepository] and exposes a
// [SpecialistDirectoryState] stream for [SpecialistListScreen] to react to.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/specialist_repository.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/specialist_directory_state.dart';

export 'specialist_directory_state.dart';

/// Cubit that drives the Specialist Directory list.
///
/// Call [load] once after construction (typically inside `BlocProvider.create`)
/// to trigger the data fetch.
class SpecialistDirectoryCubit extends Cubit<SpecialistDirectoryState> {
  SpecialistDirectoryCubit(this._repo)
      : super(const SpecialistDirectoryState.initial());

  final SpecialistRepository _repo;

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  /// Fetches all specialists and emits [SpecialistDirectoryLoaded] on success.
  ///
  /// Emits [SpecialistDirectoryLoading] first, then either
  /// [SpecialistDirectoryLoaded] or [SpecialistDirectoryError].
  /// The [isClosed] guard prevents emitting after disposal.
  Future<void> load() async {
    emit(const SpecialistDirectoryState.loading());
    try {
      final recommended = await _repo.getRecommendedSpecialists();
      final all = await _repo.getAllSpecialists();
      if (!isClosed) {
        emit(SpecialistDirectoryState.loaded(
          recommended: recommended,
          all: all,
        ));
      }
    } on Exception catch (e) {
      if (!isClosed) {
        emit(SpecialistDirectoryState.error(
          e.toString().replaceAll('Exception: ', ''),
        ));
      }
    } catch (_) {
      if (!isClosed) {
        emit(const SpecialistDirectoryState.error(
          'Something went wrong. Please try again.',
        ));
      }
    }
  }
}
