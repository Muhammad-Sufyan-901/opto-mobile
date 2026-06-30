// Screen: Order Payment Result
//
// Shown after a successful order confirmation. Driven by [OrderResult] received
// via GoRouterState.extra.
//
// Two UIs:
//   • Virtual Account  — shows generated VA number, bank, amount, transfer steps.
//   • Cash on Delivery — shows simple "order placed, pay on delivery" confirmation.
//
// Accessibility: auto-announces full instructions on mount; VA number wrapped
// in a live region; "Copy" button with semantic label; ≥48dp targets; 300% reflow.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/currency_formatter.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/checkout_details.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/order_result.dart';

/// Result screen shown after a successful order placement.
///
/// Receives an [OrderResult] via `GoRouterState.of(context).extra`.
/// If the extra is not an [OrderResult], pops back immediately.
class OrderPaymentResultScreen extends StatelessWidget {
  const OrderPaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    if (extra is! OrderResult) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    return _ResultView(result: extra);
  }
}

// =============================================================================
// PRIVATE: RESULT VIEW
// =============================================================================

class _ResultView extends StatefulWidget {
  const _ResultView({required this.result});
  final OrderResult result;

  @override
  State<_ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<_ResultView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _announceResult();
    });
  }

  void _announceResult() {
    final r = widget.result;
    if (r.method == PaymentMethod.virtualAccount) {
      announce(
        context,
        'Order confirmed. '
        'Please complete your payment via ${r.bankName ?? "Bank"} Virtual Account. '
        'Virtual account number: ${_spellOutVa(r.virtualAccountNo ?? "")}. '
        'Amount: Rp ${formatRupiah(r.totalIdr)}. '
        'Transfer before the deadline to confirm your order.',
      );
    } else {
      announce(
        context,
        'Order confirmed. Pay cash on delivery when your order arrives. '
        'Amount: Rp ${formatRupiah(r.totalIdr)}.',
      );
    }
  }

  /// Inserts a space between every 4 digits so TTS reads individual digits.
  String _spellOutVa(String va) =>
      va.replaceAllMapped(RegExp(r'.{1,4}'), (m) => '${m.group(0)} ').trim();

  void _copyVa(BuildContext ctx, String va) {
    Clipboard.setData(ClipboardData(text: va));
    HapticPatterns.success();
    announce(ctx, 'Virtual account number copied to clipboard.');
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text('VA number copied to clipboard.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color green = ext?.green ?? cs.tertiary;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final r = widget.result;
    final bool isVa = r.method == PaymentMethod.virtualAccount;
    final String totalFormatted = 'Rp ${formatRupiah(r.totalIdr)}';

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Status icon + title ──────────────────────────────────────
              Semantics(
                header: true,
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isVa
                            ? blueTint
                            : green.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isVa
                            ? Icons.account_balance_outlined
                            : Icons.check_circle_outline,
                        size: 36,
                        color: isVa ? cs.primary : green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isVa ? 'Complete Your Payment' : 'Order Confirmed!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isVa
                          ? 'Transfer to the virtual account below to confirm your order.'
                          : 'Your order has been placed. Pay cash when it arrives.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isVa) ...[
                        // ── VA details card ────────────────────────────────
                        _InfoCard(
                          borderColor: line,
                          backgroundColor: blueTint,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bank name
                              Text(
                                '${r.bankName ?? "Bank"} Virtual Account',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // VA number + copy button
                              Row(
                                children: [
                                  Expanded(
                                    child: Semantics(
                                      liveRegion: true,
                                      label:
                                          'Virtual account number: ${_spellOutVa(r.virtualAccountNo ?? "")}',
                                      child: ExcludeSemantics(
                                        child: Text(
                                          r.virtualAccountNo ?? '—',
                                          style: theme.textTheme.headlineMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: cs.primary,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Semantics(
                                    button: true,
                                    label: 'Copy virtual account number',
                                    child: IconButton(
                                      onPressed: () =>
                                          _copyVa(context, r.virtualAccountNo ?? ''),
                                      icon: const Icon(Icons.copy_outlined),
                                      color: cs.primary,
                                      iconSize: 22,
                                      tooltip: 'Copy VA number',
                                      constraints: const BoxConstraints(
                                        minWidth: 48,
                                        minHeight: 48,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Divider(color: line, height: 24),

                              // Amount
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total amount',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    totalFormatted,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Transfer instructions ──────────────────────────
                        _InfoCard(
                          borderColor: line,
                          backgroundColor: cs.surface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How to pay',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ..._vaSteps(r.bankName ?? 'Bank').indexed.map(
                                    ((int, String) step) =>
                                        _StepRow(number: step.$1 + 1, text: step.$2),
                                  ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // ── COD summary card ───────────────────────────────
                        _InfoCard(
                          borderColor: line,
                          backgroundColor: green.withValues(alpha: 0.08),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment method',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    'Cash on Delivery',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount to pay',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    totalFormatted,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 16, color: cs.onSurfaceVariant),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Please prepare the exact amount when the courier arrives.',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: AppDimensions.space24),
                    ],
                  ),
                ),
              ),

              // ── Back to hub CTA ──────────────────────────────────────────
              Semantics(
                button: true,
                label: 'Back to Prosthetic Hub',
                child: SizedBox(
                  height: AppDimensions.buttonHeight,
                  child: FilledButton.icon(
                    onPressed: () =>
                        context.go(AppRoutes.prostheticHub.path),
                    icon: const Icon(Icons.home_outlined, size: 20),
                    label: const Text('Back to Hub'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _vaSteps(String bank) => [
        'Open your mobile banking or ATM ($bank).',
        'Select "Transfer" → "Virtual Account".',
        'Enter the virtual account number shown above.',
        'Confirm the amount matches Rp ${formatRupiah(widget.result.totalIdr)}.',
        'Complete the transfer and save your receipt.',
        'Your order will be processed once payment is received.',
      ];
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Styled card container for VA details / COD summary.
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.child,
    required this.borderColor,
    required this.backgroundColor,
  });

  final Widget child;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(AppDimensions.radiusCard + 4),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: child,
    );
  }
}

/// A numbered step row for the transfer instructions.
class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        label: 'Step $number: $text',
        child: ExcludeSemantics(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
