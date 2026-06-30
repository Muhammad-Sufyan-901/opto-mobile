// Screen: Checkout — Shipping Address + Payment Method + Order Summary
//
// Single scrollable screen combining:
//   1. Delivery address form (recipient name, phone, street, city, postal code)
//   2. Payment method selector (Virtual Account | Cash on Delivery)
//   3. Order summary (line items + totals)
//   4. Confirm & Place Order CTA
//
// Receives cart data via GoRouterState.extra (same plumbing as before):
//   - 'catalogState': OrderSuppliesCatalog
//   - 'cubit': OrderSuppliesCubit
//
// On OrderSuppliesConfirmed → navigates to OrderPaymentResultScreen with the
// OrderResult; stays on screen for retry on OrderSuppliesError.
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/currency_formatter.dart';
import 'package:opto/core/utils/input_validator.dart';
import 'package:opto/core/widgets/forms/app_form_field.dart';
import 'package:opto/core/widgets/inputs/app_input_field.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/checkout_details.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/supply_product.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/order_supplies_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Screen: Checkout (Prosthetic Hub — Order Supplies sub-flow).
///
/// Receives a `Map<String, dynamic>` via `GoRouterState.of(context).extra`
/// with keys:
///   - `'catalogState'`: [OrderSuppliesCatalog] — products + cart snapshot
///   - `'cubit'`: [OrderSuppliesCubit] — the live cubit from the catalog screen
class SupplyOrderSummaryScreen extends StatelessWidget {
  const SupplyOrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    if (extra is! Map<String, dynamic>) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    final catalogState = extra['catalogState'] as OrderSuppliesCatalog?;
    final cubit = extra['cubit'] as OrderSuppliesCubit?;
    if (catalogState == null || cubit == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    return BlocProvider<OrderSuppliesCubit>.value(
      value: cubit,
      child: _CheckoutView(catalogState: catalogState),
    );
  }
}

// =============================================================================
// PRIVATE: CHECKOUT VIEW
// =============================================================================

class _CheckoutView extends StatefulWidget {
  const _CheckoutView({required this.catalogState});
  final OrderSuppliesCatalog catalogState;

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  final _formKey = GlobalKey<FormState>();

  // Address controllers
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();

  PaymentMethod? _selectedPayment;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(
        context,
        'Checkout. '
        '$_totalItems item${_totalItems == 1 ? "" : "s"}. '
        'Total Rp ${formatRupiah(_totalPrice)}. '
        'Please fill in your delivery address and choose a payment method.',
      );
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  // ── Cart helpers ──────────────────────────────────────────────────────────

  List<_LineItem> get _lineItems {
    final items = <_LineItem>[];
    for (final entry in widget.catalogState.cart.entries) {
      final product = widget.catalogState.products
          .firstWhereOrNull((p) => p.id == entry.key);
      if (product == null) continue;
      items.add(_LineItem(product: product, qty: entry.value));
    }
    return items;
  }

  int get _totalItems =>
      widget.catalogState.cart.values.fold(0, (sum, qty) => sum + qty);

  int get _totalPrice {
    int total = 0;
    for (final entry in widget.catalogState.cart.entries) {
      final product = widget.catalogState.products
          .firstWhereOrNull((p) => p.id == entry.key);
      if (product == null) continue;
      total += product.priceIdr * entry.value;
    }
    return total;
  }

  // ── Confirm handler ───────────────────────────────────────────────────────

  void _onConfirm() {
    final bool formValid = _formKey.currentState!.validate();
    final bool paymentChosen = _selectedPayment != null;

    if (!paymentChosen) {
      HapticPatterns.warning();
      announce(context, 'Please select a payment method to continue.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method to continue.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (!formValid || !paymentChosen) return;

    final details = CheckoutDetails(
      recipientName: _nameCtrl.text.trim(),
      recipientPhone: _phoneCtrl.text.trim(),
      shippingAddress: _addressCtrl.text.trim(),
      shippingCity: _cityCtrl.text.trim(),
      shippingPostalCode: _postalCtrl.text.trim(),
      paymentMethod: _selectedPayment!,
    );

    context.read<OrderSuppliesCubit>().confirmOrder(details);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color green = ext?.green ?? cs.tertiary;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final lineItems = _lineItems;
    final totalPrice = _totalPrice;
    final String totalFormatted = 'Rp ${formatRupiah(totalPrice)}';

    return BlocListener<OrderSuppliesCubit, OrderSuppliesState>(
      listener: (context, state) {
        if (state is OrderSuppliesConfirmed) {
          HapticPatterns.success();
          announce(
            context,
            state.result.method == PaymentMethod.virtualAccount
                ? 'Order confirmed. Please complete your payment via Virtual Account.'
                : 'Order confirmed. You will pay cash on delivery.',
          );
          context.go(
            AppRoutes.prostheticOrderResult.path,
            extra: state.result,
          );
        } else if (state is OrderSuppliesError) {
          HapticPatterns.warning();
          announce(context, 'Order failed. ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Stay on screen for retry.
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              top: 16,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProstheticHeader(title: 'Checkout'),
                const SizedBox(height: AppDimensions.space24),

                // ── Scrollable body ──────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Section 1: Delivery Address ──────────────────
                          _SectionHeader(
                            title: 'Delivery Address',
                            icon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: AppDimensions.space16),

                          AppFormField(
                            label: 'Recipient Name',
                            isRequired: true,
                            child: AppInputField(
                              controller: _nameCtrl,
                              hintText: 'Full name',
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              isRequired: true,
                              validator: (v) => InputValidator.name(
                                v,
                                errorMessage: 'Please enter the recipient name',
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          AppFormField(
                            label: 'Phone Number',
                            isRequired: true,
                            child: AppInputField(
                              controller: _phoneCtrl,
                              hintText: '08xx-xxxx-xxxx',
                              prefixIcon: Icons.phone_outlined,
                              textInputAction: TextInputAction.next,
                              isRequired: true,
                              validator: (v) => InputValidator.phone(
                                v,
                                errorMessage:
                                    'Please enter a valid phone number',
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          AppFormField(
                            label: 'Street Address',
                            isRequired: true,
                            child: AppInputField(
                              controller: _addressCtrl,
                              hintText: 'House number, street, RT/RW',
                              prefixIcon: Icons.home_outlined,
                              textInputAction: TextInputAction.next,
                              isRequired: true,
                              validator: (v) => InputValidator.address(
                                v,
                                errorMessage:
                                    'Please enter a valid street address',
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          AppFormField(
                            label: 'City',
                            isRequired: true,
                            child: AppInputField(
                              controller: _cityCtrl,
                              hintText: 'City / Regency',
                              prefixIcon: Icons.location_city_outlined,
                              textInputAction: TextInputAction.next,
                              isRequired: true,
                              validator: (v) => InputValidator.required(
                                v,
                                fieldName: 'City',
                                errorMessage: 'Please enter your city',
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          AppFormField(
                            label: 'Postal Code',
                            isRequired: true,
                            child: AppInputField(
                              controller: _postalCtrl,
                              hintText: '5-digit postal code',
                              prefixIcon: Icons.markunread_mailbox_outlined,
                              textInputAction: TextInputAction.done,
                              isRequired: true,
                              validator: (v) {
                                final req = InputValidator.required(
                                  v,
                                  fieldName: 'Postal code',
                                  errorMessage: 'Please enter your postal code',
                                );
                                if (req != null) return req;
                                if (v != null && v.trim().length < 4) {
                                  return 'Please enter a valid postal code';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: AppDimensions.space24),

                          // ── Section 2: Payment Method ────────────────────
                          _SectionHeader(
                            title: 'Payment Method',
                            icon: Icons.payment_outlined,
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          _PaymentMethodOption(
                            method: PaymentMethod.virtualAccount,
                            isSelected:
                                _selectedPayment == PaymentMethod.virtualAccount,
                            onTap: () => setState(
                              () => _selectedPayment =
                                  PaymentMethod.virtualAccount,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space8),
                          _PaymentMethodOption(
                            method: PaymentMethod.cod,
                            isSelected: _selectedPayment == PaymentMethod.cod,
                            onTap: () =>
                                setState(() => _selectedPayment = PaymentMethod.cod),
                          ),

                          const SizedBox(height: AppDimensions.space24),

                          // ── Section 3: Order Summary ─────────────────────
                          _SectionHeader(
                            title: 'Order Summary',
                            icon: Icons.receipt_long_outlined,
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          for (final item in lineItems) ...[
                            _OrderLineItem(item: item),
                            const SizedBox(height: AppDimensions.space12),
                          ],

                          const SizedBox(height: AppDimensions.space8),

                          // Summary block (subtotal / delivery / total)
                          Semantics(
                            label:
                                'Order total: $totalFormatted. Delivery free.',
                            child: Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.cardPaddingLarge,
                              ),
                              decoration: BoxDecoration(
                                color: blueTint,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusCard + 4,
                                ),
                                border: Border.all(color: line, width: 1.5),
                              ),
                              child: ExcludeSemantics(
                                child: Column(
                                  children: [
                                    _SumRow(
                                      label: 'Subtotal',
                                      value: totalFormatted,
                                    ),
                                    const SizedBox(height: 10),
                                    _SumRow(
                                      label: 'Delivery',
                                      value: 'Free',
                                      valueColor: green,
                                    ),
                                    const SizedBox(height: 4),
                                    Divider(color: line, thickness: 1.5),
                                    const SizedBox(height: 4),
                                    _SumRow(
                                      label: 'Total',
                                      value: totalFormatted,
                                      bold: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.space24),

                          // Consent notice
                          Text(
                            'By confirming, you consent to this order. '
                            'The summary above will be read aloud for your review.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: AppDimensions.space24),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Confirm button (pinned bottom) ───────────────────────────
                BlocBuilder<OrderSuppliesCubit, OrderSuppliesState>(
                  builder: (context, state) {
                    final bool isLoading = state is OrderSuppliesSubmitting;
                    return Semantics(
                      button: true,
                      label: 'Confirm and place order',
                      child: SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: FilledButton.icon(
                          onPressed: isLoading ? null : _onConfirm,
                          icon: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: cs.onPrimary,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline, size: 20),
                          label: const Text('Confirm & Place Order'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(
                              double.infinity,
                              AppDimensions.buttonHeight,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE DATA CLASS
// =============================================================================

class _LineItem {
  const _LineItem({required this.product, required this.qty});
  final SupplyProduct product;
  final int qty;
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Visually distinct section header with an icon and title.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Semantics(
      header: true,
      child: Row(
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Selectable payment method row styled after the design system's OptionRow:
/// icon chip + title + description + blue border when selected.
class _PaymentMethodOption extends StatelessWidget {
  const _PaymentMethodOption({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final (IconData icon, String title, String description) = switch (method) {
      PaymentMethod.virtualAccount => (
          Icons.account_balance_outlined,
          'Virtual Account (Bank Transfer)',
          'Transfer to BCA virtual account. VA number provided after order.',
        ),
      PaymentMethod.cod => (
          Icons.delivery_dining_outlined,
          'Cash on Delivery',
          'Pay in cash when your order arrives at your door.',
        ),
    };

    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: '${isSelected ? "Selected, " : ""}$title. $description',
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: isSelected ? blueTint : cs.surface,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusCard),
              border: Border.all(
                color: isSelected ? cs.primary : line,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  // Icon chip
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primary.withValues(alpha: 0.12)
                          : cs.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title + description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? cs.primary : cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Trailing check
                  const SizedBox(width: 8),
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    size: 22,
                    color: isSelected ? cs.primary : line,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single order line row inside a tinted card.
class _OrderLineItem extends StatelessWidget {
  const _OrderLineItem({required this.item});
  final _LineItem item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    final int subtotal = item.product.priceIdr * item.qty;
    final String subtotalFormatted = 'Rp ${formatRupiah(subtotal)}';

    return Semantics(
      label:
          '${item.product.name}, quantity ${item.qty}, subtotal $subtotalFormatted',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '× ${item.qty}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: ink2),
                    ),
                  ],
                ),
              ),
            ),
            ExcludeSemantics(
              child: Text(
                subtotalFormatted,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single summary row (label + value).
class _SumRow extends StatelessWidget {
  const _SumRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final base = bold
        ? Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w800,
            )
        : Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: base),
        Text(
          value,
          style: base.copyWith(
            color: valueColor ?? base.color,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
