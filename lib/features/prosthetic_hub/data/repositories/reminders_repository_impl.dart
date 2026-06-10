// Repository implementation for care reminders.
//
// Client layer only. Notification dispatch is the Edge Function's responsibility.
import 'package:opto/features/prosthetic_hub/data/datasources/prosthetic_remote_data_source.dart';
import 'package:opto/features/prosthetic_hub/data/models/care_reminder_model_ext.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_reminder_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/reminders_repository.dart';

class RemindersRepositoryImpl implements RemindersRepository {
  RemindersRepositoryImpl(this._dataSource);

  final ProstheticRemoteDataSource _dataSource;

  @override
  Future<List<CareReminderEntity>> getMyReminders() async {
    final models = await _dataSource.getMyReminders();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CareReminderEntity> upsertReminder({
    String? id,
    required String label,
    required String scheduleCron,
    bool notifyCaregiver = false,
  }) async {
    final model = await _dataSource.upsertReminder(
      id: id,
      label: label,
      scheduleCron: scheduleCron,
      notifyCaregiver: notifyCaregiver,
    );
    return model.toEntity();
  }

  @override
  Future<CareReminderEntity> toggleActive(String reminderId) async {
    final model = await _dataSource.toggleActive(reminderId);
    return model.toEntity();
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    await _dataSource.deleteReminder(reminderId);
  }
}
