// Pure-Dart domain entity for a prosthetic order.
import 'package:opto/core/constants/prosthetic_enums.dart';

/// Immutable domain representation of a row in the `prosthetic_orders` table.
class ProstheticOrderEntity {
  const ProstheticOrderEntity({
    required this.id,
    required this.userId,
    required this.productId,
    this.anthropometricId,
    required this.status,
    required this.consentGiven,
    required this.totalIdr,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String productId;

  /// Set only for custom-fit orders that reference anthropometric data.
  final String? anthropometricId;

  final OrderStatus status;

  /// True once the user has confirmed consent via the read-aloud flow.
  final bool consentGiven;

  /// Total cost in IDR (Indonesian Rupiah).
  final int totalIdr;

  final String? createdAt;

  ProstheticOrderEntity copyWith({
    String? id,
    String? userId,
    String? productId,
    String? anthropometricId,
    OrderStatus? status,
    bool? consentGiven,
    int? totalIdr,
    String? createdAt,
  }) =>
      ProstheticOrderEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        productId: productId ?? this.productId,
        anthropometricId: anthropometricId ?? this.anthropometricId,
        status: status ?? this.status,
        consentGiven: consentGiven ?? this.consentGiven,
        totalIdr: totalIdr ?? this.totalIdr,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProstheticOrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
