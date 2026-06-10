// Domain contract for care reminder operations.
//
// NOTE: This layer only persists rows to `care_reminders`. Notification
// dispatch via `schedule_cron` is the responsibility of the
// `send-notification` Edge Function (Phase 3E/4).
import 'package:opto/features/prosthetic_hub/domain/entities/care_reminder_entity.dart';

/// Repository contract for the `care_reminders` table.
abstract class RemindersRepository {
  /// Returns all reminders for the current user.
  Future<List<CareReminderEntity>> getMyReminders();

  /// Creates or updates a reminder row.
  ///
  /// If [id] is null, inserts a new row. Otherwise updates the existing row.
  Future<CareReminderEntity> upsertReminder({
    String? id,
    required String label,
    required String scheduleCron,
    bool notifyCaregiver,
  });

  /// Toggles the [is_active] flag for [reminderId].
  Future<CareReminderEntity> toggleActive(String reminderId);

  /// Deletes a reminder row.
  Future<void> deleteReminder(String reminderId);
}
