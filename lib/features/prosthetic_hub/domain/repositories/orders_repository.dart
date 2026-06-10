// Domain contract for prosthetic order operations.
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_order_entity.dart';

/// Repository contract for the `prosthetic_orders` table.
///
/// Implementations must:
///   - Scope reads to auth.currentUser.id (owner).
///   - Never set [consentGiven] = true without an explicit read-aloud confirmation
///     flow (i.e. the user called [confirmConsent] after reviewing terms).
abstract class OrdersRepository {
  /// Returns all orders for the current user, newest first.
  Future<List<ProstheticOrderEntity>> getMyOrders();

  /// Returns a single order by [orderId].
  ///
  /// Throws [ServerFailure('Order not found')] if not found.
  Future<ProstheticOrderEntity> getOrderById(String orderId);

  /// Creates a draft order.
  ///
  /// [consentGiven] must be false at creation; use [confirmConsent] after
  /// the read-aloud consent flow.
  Future<ProstheticOrderEntity> createOrder({
    required String productId,
    required int totalIdr,
    String? anthropometricId,
    OrderStatus status,
  });

  /// Sets [consent_given = true] for [orderId] after explicit user confirmation.
  Future<ProstheticOrderEntity> confirmConsent(String orderId);

  /// Submits a draft order (sets status → `submitted`).
  ///
  /// Requires [consentGiven = true] before submission.
  Future<ProstheticOrderEntity> submitOrder(String orderId);

  /// Cancels an order in draft or submitted status.
  Future<ProstheticOrderEntity> cancelOrder(String orderId);
}
