// Pure-Dart domain entity for a care reminder.
//
// NOTE: `scheduleCron` is stored for display. The actual notification dispatch
// is a server-side responsibility (Edge Function). Client layer only
// creates/updates rows; it does NOT schedule local or remote notifications here.
/// Immutable domain representation of a row in the `care_reminders` table.
class CareReminderEntity {
  const CareReminderEntity({
    required this.id,
    required this.userId,
    required this.label,
    required this.scheduleCron,
    required this.notifyCaregiver,
    required this.isActive,
  });

  final String id;
  final String userId;
  final String label;

  /// Cron expression (e.g. "0 8 * * *"). Dispatched by the Edge Function.
  final String scheduleCron;

  final bool notifyCaregiver;
  final bool isActive;

  CareReminderEntity copyWith({
    String? id,
    String? userId,
    String? label,
    String? scheduleCron,
    bool? notifyCaregiver,
    bool? isActive,
  }) =>
      CareReminderEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        label: label ?? this.label,
        scheduleCron: scheduleCron ?? this.scheduleCron,
        notifyCaregiver: notifyCaregiver ?? this.notifyCaregiver,
        isActive: isActive ?? this.isActive,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareReminderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
