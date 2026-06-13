// Domain entity for a single daily prosthetic care log entry.

enum CareTask {
  cleaned,
  lubricated,
  inspected,
  removedBeforeSleep,
}

enum ComfortLevel { poor, fair, good }

extension CareTaskLabel on CareTask {
  String get displayLabel => switch (this) {
        CareTask.cleaned => 'Cleaned prosthesis',
        CareTask.lubricated => 'Applied lubricant',
        CareTask.inspected => 'Inspected for damage',
        CareTask.removedBeforeSleep => 'Removed before sleep',
      };
}

extension ComfortLevelLabel on ComfortLevel {
  String get displayLabel => switch (this) {
        ComfortLevel.poor => 'Poor',
        ComfortLevel.fair => 'Fair',
        ComfortLevel.good => 'Good',
      };
}

class CareLog {
  const CareLog({
    required this.date,
    this.completedTasks = const {},
    this.comfortLevel,
    this.notes = '',
  });

  final DateTime date;
  final Set<CareTask> completedTasks;
  final ComfortLevel? comfortLevel;
  final String notes;
}
