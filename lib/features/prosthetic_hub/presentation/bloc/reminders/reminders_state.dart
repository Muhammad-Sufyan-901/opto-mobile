// State definitions for the Reminders cubit.
import 'package:opto/features/prosthetic_hub/domain/entities/care_reminder_entity.dart';

sealed class RemindersState {
  const RemindersState();
}

class RemindersInitial extends RemindersState {
  const RemindersInitial();
}

class RemindersLoading extends RemindersState {
  const RemindersLoading();
}

class RemindersLoaded extends RemindersState {
  const RemindersLoaded(this.reminders);
  final List<CareReminderEntity> reminders;
}

/// A save/toggle/delete operation completed.
class RemindersOperationSuccess extends RemindersState {
  const RemindersOperationSuccess({
    required this.reminders,
    required this.message,
  });
  final List<CareReminderEntity> reminders;
  final String message;
}

class RemindersError extends RemindersState {
  const RemindersError(this.message);
  final String message;
}
