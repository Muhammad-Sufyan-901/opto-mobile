// Domain entity capturing shipping address and payment choice for an order.
//
// Pure-Dart — no Supabase / serialisation dependencies.

/// Payment method chosen at checkout.
enum PaymentMethod { virtualAccount, cod }

/// Human-readable label for each [PaymentMethod].
extension PaymentMethodLabel on PaymentMethod {
  String get displayLabel => switch (this) {
        PaymentMethod.virtualAccount => 'Virtual Account (Bank Transfer)',
        PaymentMethod.cod => 'Cash on Delivery',
      };

  /// Short bank / method name for display (e.g. on confirmation screen).
  String get shortLabel => switch (this) {
        PaymentMethod.virtualAccount => 'Virtual Account',
        PaymentMethod.cod => 'COD',
      };

  /// Postgres enum string for persistence.
  String get dbValue => switch (this) {
        PaymentMethod.virtualAccount => 'virtual_account',
        PaymentMethod.cod => 'cod',
      };
}

/// Immutable value object holding shipping and payment details collected at
/// checkout. Passed from [SupplyOrderSummaryScreen] → [OrderSuppliesCubit]
/// → [SuppliesRepository.placeOrder].
class CheckoutDetails {
  const CheckoutDetails({
    required this.recipientName,
    required this.recipientPhone,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingPostalCode,
    required this.paymentMethod,
  });

  /// Full name of the delivery recipient.
  final String recipientName;

  /// Contact phone number for the delivery.
  final String recipientPhone;

  /// Street address (house number, street name, RT/RW, etc.).
  final String shippingAddress;

  /// City / regency.
  final String shippingCity;

  /// Postal code.
  final String shippingPostalCode;

  /// Payment method chosen by the user.
  final PaymentMethod paymentMethod;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutDetails &&
          runtimeType == other.runtimeType &&
          recipientName == other.recipientName &&
          recipientPhone == other.recipientPhone &&
          shippingAddress == other.shippingAddress &&
          shippingCity == other.shippingCity &&
          shippingPostalCode == other.shippingPostalCode &&
          paymentMethod == other.paymentMethod;

  @override
  int get hashCode => Object.hash(
        recipientName,
        recipientPhone,
        shippingAddress,
        shippingCity,
        shippingPostalCode,
        paymentMethod,
      );
}
