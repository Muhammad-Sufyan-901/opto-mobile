// State for the Hub status card.
//
// Only holds the minimal data needed for the hub overview:
//   - latest order status label (or null if no orders)
//   - next active reminder label (or null if no reminders)
sealed class HubState {
  const HubState();
}

class HubInitial extends HubState {
  const HubInitial();
}

class HubLoading extends HubState {
  const HubLoading();
}

class HubLoaded extends HubState {
  const HubLoaded({
    this.latestOrderStatus,
    this.nextReminderLabel,
  });

  /// Human-readable status of the most-recent order (e.g. "In production").
  final String? latestOrderStatus;

  /// Label of the next active reminder (e.g. "Daily lens cleaning").
  final String? nextReminderLabel;
}

class HubError extends HubState {
  const HubError(this.message);
  final String message;
}
