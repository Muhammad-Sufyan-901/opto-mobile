// Extension methods on CareReminderModel to produce domain entities.
import 'package:opto/features/prosthetic_hub/data/models/care_reminder_model.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_reminder_entity.dart';

extension CareReminderModelX on CareReminderModel {
  CareReminderEntity toEntity() => CareReminderEntity(
        id: id,
        userId: userId,
        label: label,
        scheduleCron: scheduleCron,
        notifyCaregiver: notifyCaregiver,
        isActive: isActive,
      );
}
