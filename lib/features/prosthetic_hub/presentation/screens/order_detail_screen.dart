// Order Detail Screen — Prosthetic Hub.
//
// Shows the full details of a single order and provides the consent read-aloud
// + submit flow for draft orders.
//
// Consent flow:
//   1. User taps "Review & Confirm Order" — terms are read aloud via announce().
//   2. User taps "I confirm" — dispatches [ConfirmConsent].
//   3. On success, "Submit Order" button becomes active.
//   4. User taps "Submit" — dispatches [SubmitOrder].
//
// Accessibility:
//   - Announces each BLoC state transition via live regions.
//   - Consent text is visible and read aloud (never hidden).
//   - Haptic feedback on submit and cancel.
//   - Tap targets ≥ 48dp.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/accessibility/haptic_patterns.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_order_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/orders/orders_bloc.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/orders/orders_event.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/orders/orders_state.dart';

/// Screen — detail view and consent/submit flow for a single order.
class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrderDetail(widget.orderId));
  }

  // ── consent read-aloud ────────────────────────────────────────────────────

  static const String _consentText =
      'By confirming this order, you agree that the prosthetic eye will be '
      'custom-fitted to your measurements. This order cannot be refunded once '
      'it enters production. All measurements are stored securely and used '
      'only for this order.';

  /// Read the consent text aloud, then confirm on user approval.
  Future<void> _startConsentFlow(
    BuildContext ctx,
    ProstheticOrderEntity order,
  ) async {
    // Read aloud via TTS accessibility channel.
    announce(ctx, _consentText);

    final confirmed = await showDialog<bool>(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: Semantics(
          header: true,
          child: const Text('Order Consent'),
        ),
        content: SingleChildScrollView(
          child: Semantics(
            liveRegion: true,
            child: Text(_consentText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Cancel'),
          ),
          Semantics(
            button: true,
            label: 'I confirm — accept consent and proceed',
            child: FilledButton(
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              child: const Text('I Confirm'),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && ctx.mounted) {
      ctx.read<OrdersBloc>().add(ConfirmConsent(order.id));
    }
  }

  Future<void> _confirmCancel(BuildContext ctx, String orderId) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Cancel order?'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text(
              'Yes, cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && ctx.mounted) {
      ctx.read<OrdersBloc>().add(CancelOrder(orderId));
    }
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  String _statusLabel(OrderStatus s) => switch (s) {
        OrderStatus.draft => 'Draft',
        OrderStatus.submitted => 'Submitted',
        OrderStatus.inReview => 'In Review',
        OrderStatus.inProduction => 'In Production',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.completed => 'Completed',
        OrderStatus.cancelled => 'Cancelled',
      };

  String _formatPrice(int totalIdr) {
    final formatted =
        totalIdr.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (m) => '${m[1]}.',
            );
    return 'Rp $formatted';
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocConsumer<OrdersBloc, OrdersState>(
          listenWhen: (_, curr) =>
              curr is OrderOperationSuccess || curr is OrdersError,
          listener: (context, state) {
            if (state is OrderOperationSuccess) {
              announce(context, state.message);
              if (state.order.status == OrderStatus.submitted) {
                HapticPatterns.success();
              } else if (state.order.status == OrderStatus.cancelled) {
                HapticPatterns.warning();
              }
              // Reload detail after mutation.
              context
                  .read<OrdersBloc>()
                  .add(LoadOrderDetail(state.order.id));
            } else if (state is OrdersError) {
              announce(context, 'Error: ${state.message}');
            }
          },
          builder: (context, state) {
            if (state is OrderDetailLoading || state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrdersError) {
              return _ErrorBody(
                message: state.message,
                onRetry: () => context
                    .read<OrdersBloc>()
                    .add(LoadOrderDetail(widget.orderId)),
                onBack: () => context.pop(),
              );
            }

            final order = switch (state) {
              OrderDetailLoaded(:final order) => order,
              OrderOperationSuccess(:final order) => order,
              _ => null,
            };

            if (order == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: cs.surface,
                  leading: Semantics(
                    button: true,
                    label: 'Back',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  title: const Text('Order Detail'),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _OrderBody(
                      order: order,
                      statusLabel: _statusLabel(order.status),
                      priceLabel: _formatPrice(order.totalIdr),
                      consentText: _consentText,
                      onReviewConsent: () =>
                          _startConsentFlow(context, order),
                      onSubmit: () => context
                          .read<OrdersBloc>()
                          .add(SubmitOrder(order.id)),
                      onCancel: () => _confirmCancel(context, order.id),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// ORDER BODY
// =============================================================================

class _OrderBody extends StatelessWidget {
  const _OrderBody({
    required this.order,
    required this.statusLabel,
    required this.priceLabel,
    required this.consentText,
    required this.onReviewConsent,
    required this.onSubmit,
    required this.onCancel,
  });

  final ProstheticOrderEntity order;
  final String statusLabel;
  final String priceLabel;
  final String consentText;
  final VoidCallback onReviewConsent;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  bool get _isDraft => order.status == OrderStatus.draft;
  bool get _canCancel =>
      order.status == OrderStatus.draft ||
      order.status == OrderStatus.submitted;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Status chip ─────────────────────────────────────────────────────
        Semantics(
          label: 'Order status: $statusLabel',
          child: Chip(label: Text(statusLabel)),
        ),
        const SizedBox(height: 16),

        // ── Details card ────────────────────────────────────────────────────
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  label: 'Order ID',
                  value: order.id.substring(0, 8).toUpperCase(),
                ),
                _DetailRow(label: 'Total', value: priceLabel),
                if (order.createdAt != null)
                  _DetailRow(
                    label: 'Placed',
                    value: order.createdAt!.split('T').first,
                  ),
                _DetailRow(
                  label: 'Consent',
                  value: order.consentGiven ? 'Given' : 'Pending',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Consent text (always visible — WCAG) ────────────────────────────
        if (_isDraft) ...[
          Text('Terms', style: tt.titleSmall),
          const SizedBox(height: 8),
          Semantics(
            liveRegion: false,
            label: consentText,
            child: Text(
              consentText,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 16),

          // ── Consent CTA ─────────────────────────────────────────────────
          if (!order.consentGiven)
            SizedBox(
              width: double.infinity,
              child: Semantics(
                button: true,
                label: 'Review and confirm order terms with read-aloud',
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.record_voice_over_outlined),
                  label: const Text('Review & Confirm Order'),
                  onPressed: onReviewConsent,
                ),
              ),
            ),

          // ── Submit CTA ──────────────────────────────────────────────────
          if (order.consentGiven) ...[
            SizedBox(
              width: double.infinity,
              child: Semantics(
                button: true,
                label: 'Submit order',
                child: FilledButton.icon(
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Submit Order'),
                  onPressed: onSubmit,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],

        // ── Cancel CTA ────────────────────────────────────────────────────
        if (_canCancel)
          SizedBox(
            width: double.infinity,
            child: Semantics(
              button: true,
              label: 'Cancel order',
              child: TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel Order',
                  style: TextStyle(color: cs.error),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Semantics(
        label: '$label: $value',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            Text(value, style: tt.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// HELPERS
// =============================================================================

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              label: 'Error: $message',
              child: Text(message, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  button: true,
                  label: 'Go back',
                  child: OutlinedButton(
                    onPressed: onBack,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Semantics(
                  button: true,
                  label: 'Retry loading order',
                  child: FilledButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
