// Freezed + json_serializable DTO for the `care_reminders` table.
//
// Mirrors the row shape in `database_schema.md` §Prosthetic.care_reminders.
//
// NOTE: `schedule_cron` is stored here for display purposes only.
// Actual cron dispatch is handled by the `send-notification` Edge Function
// (Phase 3E/4) — this client layer does NOT trigger it.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_reminder_model.freezed.dart';
part 'care_reminder_model.g.dart';

@freezed
abstract class CareReminderModel with _$CareReminderModel {
  const factory CareReminderModel({
    required String id,

    @JsonKey(name: 'user_id') required String userId,

    /// Human-readable label, e.g. "Daily lens cleaning".
    required String label,

    /// Cron expression, e.g. "0 8 * * *" (daily at 8 AM).
    @JsonKey(name: 'schedule_cron') required String scheduleCron,

    /// Whether the linked caregiver should also be notified.
    @JsonKey(name: 'notify_caregiver') @Default(false) bool notifyCaregiver,

    /// Whether this reminder is currently active.
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _CareReminderModel;

  factory CareReminderModel.fromJson(Map<String, dynamic> json) =>
      _$CareReminderModelFromJson(json);
}
