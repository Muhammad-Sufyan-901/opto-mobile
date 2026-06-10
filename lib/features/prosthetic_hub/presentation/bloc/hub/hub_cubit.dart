// Cubit for the Prosthetic Hub screen status card.
//
// Loads the minimal data needed for the hub overview:
//   - Latest order (most recently created) → its status label
//   - Next active reminder → its label
//
// Uses existing repositories (no new Supabase queries needed beyond what
// OrdersRepository + RemindersRepository already expose).
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/orders_repository.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/reminders_repository.dart';
import 'hub_state.dart';

class HubCubit extends Cubit<HubState> {
  HubCubit({
    required OrdersRepository ordersRepository,
    required RemindersRepository remindersRepository,
  })  : _orders = ordersRepository,
        _reminders = remindersRepository,
        super(const HubInitial());

  final OrdersRepository _orders;
  final RemindersRepository _reminders;

  Future<void> loadStatus() async {
    emit(const HubLoading());
    try {
      // Fetch in parallel — two independent reads.
      final ordersFuture = _orders.getMyOrders();
      final remindersFuture = _reminders.getMyReminders();
      final orders = await ordersFuture;
      final reminders = await remindersFuture;

      final latestStatus = orders.isNotEmpty
          ? _statusLabel(orders.first.status)
          : null;

      final nextReminder = reminders
          .where((r) => r.isActive)
          .map((r) => r.label)
          .firstOrNull;

      emit(HubLoaded(
        latestOrderStatus: latestStatus,
        nextReminderLabel: nextReminder,
      ));
    } on Failure catch (f) {
      emit(HubError(f.message));
    } catch (e) {
      emit(HubError(e.toString()));
    }
  }

  static String _statusLabel(OrderStatus s) => switch (s) {
        OrderStatus.draft => 'Draft',
        OrderStatus.submitted => 'Submitted',
        OrderStatus.inReview => 'In review',
        OrderStatus.inProduction => 'In production',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.completed => 'Completed',
        OrderStatus.cancelled => 'Cancelled',
      };
}
