import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_log.dart';

class CareLogFormState {
  const CareLogFormState({
    this.checkedTasks = const {},
    this.comfortLevel,
    this.notes = '',
    this.isSaved = false,
  });

  final Set<CareTask> checkedTasks;
  final ComfortLevel? comfortLevel;
  final String notes;
  final bool isSaved;

  CareLogFormState copyWith({
    Set<CareTask>? checkedTasks,
    ComfortLevel? comfortLevel,
    String? notes,
    bool? isSaved,
    bool clearComfort = false,
  }) {
    return CareLogFormState(
      checkedTasks: checkedTasks ?? this.checkedTasks,
      comfortLevel:
          clearComfort ? null : (comfortLevel ?? this.comfortLevel),
      notes: notes ?? this.notes,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class CareLogCubit extends Cubit<CareLogFormState> {
  CareLogCubit() : super(const CareLogFormState());

  void toggleTask(CareTask task) {
    final updated = Set<CareTask>.from(state.checkedTasks);
    if (updated.contains(task)) {
      updated.remove(task);
    } else {
      updated.add(task);
    }
    emit(state.copyWith(checkedTasks: updated));
  }

  void setComfort(ComfortLevel level) {
    emit(state.copyWith(comfortLevel: level));
  }

  void updateNotes(String value) {
    emit(state.copyWith(notes: value));
  }

  void save() {
    emit(state.copyWith(isSaved: true));
  }
}
