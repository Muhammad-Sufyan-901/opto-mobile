// Repository implementation for prosthetic orders.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/error/failures.dart';
import 'package:opto/features/prosthetic_hub/data/datasources/prosthetic_remote_data_source.dart';
import 'package:opto/features/prosthetic_hub/data/models/prosthetic_order_model_ext.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_order_entity.dart';
import 'package:opto/features/prosthetic_hub/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._dataSource);

  final ProstheticRemoteDataSource _dataSource;

  @override
  Future<List<ProstheticOrderEntity>> getMyOrders() async {
    final models = await _dataSource.getMyOrders();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ProstheticOrderEntity> getOrderById(String orderId) async {
    final model = await _dataSource.getOrderById(orderId);
    return model.toEntity();
  }

  @override
  Future<ProstheticOrderEntity> createOrder({
    required String productId,
    required int totalIdr,
    String? anthropometricId,
    OrderStatus status = OrderStatus.draft,
  }) async {
    final model = await _dataSource.insertOrder(
      productId: productId,
      totalIdr: totalIdr,
      anthropometricId: anthropometricId,
      status: status.dbValue,
    );
    return model.toEntity();
  }

  @override
  Future<ProstheticOrderEntity> confirmConsent(String orderId) async {
    final model = await _dataSource.updateOrderConsent(orderId);
    return model.toEntity();
  }

  @override
  Future<ProstheticOrderEntity> submitOrder(String orderId) async {
    // Guard: read the current order and verify consent before submitting.
    final current = await _dataSource.getOrderById(orderId);
    if (!current.consentGiven) {
      throw const ServerFailure(
        'Cannot submit order: consent has not been given.',
      );
    }
    final model = await _dataSource.updateOrderStatus(
      orderId,
      OrderStatus.submitted.dbValue,
    );
    return model.toEntity();
  }

  @override
  Future<ProstheticOrderEntity> cancelOrder(String orderId) async {
    final model = await _dataSource.updateOrderStatus(
      orderId,
      OrderStatus.cancelled.dbValue,
    );
    return model.toEntity();
  }
}
