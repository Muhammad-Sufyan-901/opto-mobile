// States for the Orders BLoC.
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_order_entity.dart';

sealed class OrdersState {
  const OrdersState();
}

/// Not yet loaded.
class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

/// Loading the order list.
class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

/// Order list loaded.
class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.orders);
  final List<ProstheticOrderEntity> orders;
}

/// Loading a single order.
class OrderDetailLoading extends OrdersState {
  const OrderDetailLoading();
}

/// Single order loaded.
class OrderDetailLoaded extends OrdersState {
  const OrderDetailLoaded(this.order);
  final ProstheticOrderEntity order;
}

/// An operation completed successfully (create / submit / cancel / consent).
class OrderOperationSuccess extends OrdersState {
  const OrderOperationSuccess({required this.order, required this.message});
  final ProstheticOrderEntity order;
  final String message;
}

/// An error occurred.
class OrdersError extends OrdersState {
  const OrdersError(this.message);
  final String message;
}
