// BLoC for prosthetic orders.
//
// Handles list loading, single-order detail, creation, consent confirmation,
// submission, and cancellation.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/orders_repository.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this._repository) : super(const OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<LoadOrderDetail>(_onLoadOrderDetail);
    on<CreateOrder>(_onCreateOrder);
    on<ConfirmConsent>(_onConfirmConsent);
    on<SubmitOrder>(_onSubmitOrder);
    on<CancelOrder>(_onCancelOrder);
  }

  final OrdersRepository _repository;

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    try {
      final orders = await _repository.getMyOrders();
      emit(OrdersLoaded(orders));
    } on Failure catch (f) {
      emit(OrdersError(f.message));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onLoadOrderDetail(
    LoadOrderDetail event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrderDetailLoading());
    try {
      final order = await _repository.getOrderById(event.orderId);
      emit(OrderDetailLoaded(order));
    } on Failure catch (f) {
      emit(OrdersError(f.message));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    try {
      final order = await _repository.createOrder(
        productId: event.productId,
        totalIdr: event.totalIdr,
        anthropometricId: event.anthropometricId,
        status: event.status,
      );
      emit(OrderOperationSuccess(
        order: order,
        message: 'Draft order created.',
      ));
    } on Failure catch (f) {
      emit(OrdersError(f.message));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onConfirmConsent(
    ConfirmConsent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final order = await _repository.confirmConsent(event.orderId);
      emit(OrderOperationSuccess(
        order: order,
        message: 'Consent confirmed.',
      ));
    } on Failure catch (f) {
      emit(OrdersError(f.message));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onSubmitOrder(
    SubmitOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final order = await _repository.submitOrder(event.orderId);
      emit(OrderOperationSuccess(
        order: order,
        message: 'Order submitted successfully.',
      ));
    } on Failure catch (f) {
      emit(OrdersError(f.message));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final order = await _repository.cancelOrder(event.orderId);
      emit(OrderOperationSuccess(
        order: order,
        message: 'Order cancelled.',
      ));
    } on Failure catch (f) {
      emit(OrdersError(f.message));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}
