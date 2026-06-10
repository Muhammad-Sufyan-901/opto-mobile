// Cubit for the Care Reminders screen.
//
// Client layer: persists rows to `care_reminders` only.
// Server-side notification dispatch (schedule_cron) is NOT triggered here.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_reminder_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/reminders_repository.dart';
import 'reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit(this._repository) : super(const RemindersInitial());

  final RemindersRepository _repository;

  List<CareReminderEntity> _current = [];

  Future<void> loadReminders() async {
    emit(const RemindersLoading());
    try {
      final list = await _repository.getMyReminders();
      _current = list;
      emit(RemindersLoaded(list));
    } on Failure catch (f) {
      emit(RemindersError(f.message));
    } catch (e) {
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> upsertReminder({
    String? id,
    required String label,
    required String scheduleCron,
    bool notifyCaregiver = false,
  }) async {
    try {
      final saved = await _repository.upsertReminder(
        id: id,
        label: label,
        scheduleCron: scheduleCron,
        notifyCaregiver: notifyCaregiver,
      );
      // Replace or insert in the local list.
      final idx = _current.indexWhere((r) => r.id == saved.id);
      if (idx >= 0) {
        _current = [..._current]..[idx] = saved;
      } else {
        _current = [saved, ..._current];
      }
      emit(RemindersOperationSuccess(
        reminders: _current,
        message: id == null ? 'Reminder saved.' : 'Reminder updated.',
      ));
    } on Failure catch (f) {
      emit(RemindersLoaded(_current));
      emit(RemindersError(f.message));
    } catch (e) {
      emit(RemindersLoaded(_current));
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> toggleActive(String reminderId) async {
    try {
      final updated = await _repository.toggleActive(reminderId);
      final idx = _current.indexWhere((r) => r.id == updated.id);
      if (idx >= 0) {
        _current = [..._current]..[idx] = updated;
      }
      emit(RemindersOperationSuccess(
        reminders: _current,
        message: updated.isActive ? 'Reminder activated.' : 'Reminder paused.',
      ));
    } on Failure catch (f) {
      emit(RemindersLoaded(_current));
      emit(RemindersError(f.message));
    } catch (e) {
      emit(RemindersLoaded(_current));
      emit(RemindersError(e.toString()));
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _repository.deleteReminder(reminderId);
      _current = _current.where((r) => r.id != reminderId).toList();
      emit(RemindersOperationSuccess(
        reminders: _current,
        message: 'Reminder deleted.',
      ));
    } on Failure catch (f) {
      emit(RemindersLoaded(_current));
      emit(RemindersError(f.message));
    } catch (e) {
      emit(RemindersLoaded(_current));
      emit(RemindersError(e.toString()));
    }
  }
}
