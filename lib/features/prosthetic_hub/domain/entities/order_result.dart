// Domain entity returned after a successful order placement.
//
// Drives the [OrderPaymentResultScreen] — carries everything the result screen
// needs to display without depending on the cubit directly.

import 'package:opto/features/prosthetic_hub/domain/entities/checkout_details.dart';

/// Result of a successful order submission.
///
/// [method] determines which confirmation UI to show:
/// - [PaymentMethod.virtualAccount] → VA number + transfer instructions.
/// - [PaymentMethod.cod] → simple "order placed" confirmation.
class OrderResult {
  const OrderResult({
    required this.method,
    required this.totalIdr,
    this.virtualAccountNo,
    this.bankName,
  });

  /// Payment method used.
  final PaymentMethod method;

  /// Grand total in IDR (all line items combined).
  final int totalIdr;

  /// Generated virtual account number; non-null only when
  /// [method] == [PaymentMethod.virtualAccount].
  final String? virtualAccountNo;

  /// Bank name for the VA (e.g. 'BCA'); non-null only for VA orders.
  final String? bankName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderResult &&
          runtimeType == other.runtimeType &&
          method == other.method &&
          totalIdr == other.totalIdr &&
          virtualAccountNo == other.virtualAccountNo &&
          bankName == other.bankName;

  @override
  int get hashCode =>
      Object.hash(method, totalIdr, virtualAccountNo, bankName);
}
