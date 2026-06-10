// Events for the Orders BLoC.
import 'package:opto/core/constants/prosthetic_enums.dart';

sealed class OrdersEvent {
  const OrdersEvent();
}

/// Load all orders for the current user.
class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

/// Load a single order by ID.
class LoadOrderDetail extends OrdersEvent {
  const LoadOrderDetail(this.orderId);
  final String orderId;
}

/// Create a new draft order.
class CreateOrder extends OrdersEvent {
  const CreateOrder({
    required this.productId,
    required this.totalIdr,
    this.anthropometricId,
    this.status = OrderStatus.draft,
  });

  final String productId;
  final int totalIdr;
  final String? anthropometricId;
  final OrderStatus status;
}

/// Mark consent as given for [orderId].
class ConfirmConsent extends OrdersEvent {
  const ConfirmConsent(this.orderId);
  final String orderId;
}

/// Submit a draft order.
class SubmitOrder extends OrdersEvent {
  const SubmitOrder(this.orderId);
  final String orderId;
}

/// Cancel an order.
class CancelOrder extends OrdersEvent {
  const CancelOrder(this.orderId);
  final String orderId;
}
