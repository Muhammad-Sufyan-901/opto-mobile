// Orders Screen — Prosthetic Hub.
//
// Displays the current user's prosthetic orders in a list, newest first.
//
// Accessibility:
//   - Announces screen and load results via live regions.
//   - Each order tile has a Semantics label with status + date.
//   - Tap targets ≥ 48dp.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/prosthetic_order_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/orders/orders_bloc.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/orders/orders_event.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/orders/orders_state.dart';

/// Screen — list of the current user's prosthetic orders.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(const LoadOrders());
  }

  String _statusLabel(OrderStatus s) => switch (s) {
        OrderStatus.draft => 'Draft',
        OrderStatus.submitted => 'Submitted',
        OrderStatus.inReview => 'In review',
        OrderStatus.inProduction => 'In production',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.completed => 'Completed',
        OrderStatus.cancelled => 'Cancelled',
      };

  Color _statusColor(OrderStatus s, ColorScheme cs) => switch (s) {
        OrderStatus.draft => cs.outline,
        OrderStatus.submitted => cs.primary,
        OrderStatus.inReview => cs.tertiary,
        OrderStatus.inProduction => cs.secondary,
        OrderStatus.shipped => cs.secondary,
        OrderStatus.completed => Colors.green,
        OrderStatus.cancelled => cs.error,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocConsumer<OrdersBloc, OrdersState>(
          listenWhen: (_, curr) =>
              curr is OrdersLoaded ||
              curr is OrderOperationSuccess ||
              curr is OrdersError,
          listener: (context, state) {
            if (state is OrdersLoaded) {
              announce(context, 'My orders.');
            } else if (state is OrderOperationSuccess) {
              announce(context, state.message);
            } else if (state is OrdersError) {
              announce(context, 'Error: ${state.message}');
            }
          },
          builder: (context, state) => CustomScrollView(
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
                title: const Text('My Orders'),
                actions: [
                  Semantics(
                    button: true,
                    label: 'New order',
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.goNamed(
                        AppRoutes.orderCreate.name,
                      ),
                      tooltip: 'New order',
                    ),
                  ),
                ],
              ),
              if (state is OrdersInitial || state is OrdersLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is OrdersError)
                SliverFillRemaining(
                  child: _ErrorView(
                    message: state.message,
                    onRetry: () =>
                        context.read<OrdersBloc>().add(const LoadOrders()),
                  ),
                )
              else if (state is OrdersLoaded && state.orders.isEmpty)
                const SliverFillRemaining(child: _EmptyView())
              else ...[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final orders = state is OrdersLoaded ? state.orders : [];
                      if (index >= orders.length) return null;
                      final order =
                          orders[index] as ProstheticOrderEntity;
                      return _OrderTile(
                        order: order,
                        statusLabel: _statusLabel(order.status),
                        statusColor: _statusColor(order.status, cs),
                        onTap: () => context.goNamed(
                          AppRoutes.orderDetail.name,
                          pathParameters: {'orderId': order.id},
                        ),
                      );
                    },
                    childCount: state is OrdersLoaded
                        ? state.orders.length
                        : 0,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ORDER TILE
// =============================================================================

class _OrderTile extends StatelessWidget {
  const _OrderTile({
    required this.order,
    required this.statusLabel,
    required this.statusColor,
    required this.onTap,
  });

  final ProstheticOrderEntity order;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onTap;

  String get _dateStr {
    if (order.createdAt == null) return '';
    return DateTime.tryParse(order.createdAt!)
            ?.toLocal()
            .toString()
            .split(' ')
            .first ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label:
          'Order, status $statusLabel${_dateStr.isNotEmpty ? ', placed $_dateStr' : ''}',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
                      style: tt.titleSmall,
                    ),
                    if (_dateStr.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        _dateStr,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  statusLabel,
                  style: tt.labelSmall?.copyWith(color: statusColor),
                ),
              ),
              const SizedBox(width: 8),
              ExcludeSemantics(
                child: Icon(
                  Icons.chevron_right,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HELPERS
// =============================================================================

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 72,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new order from the catalog.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

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
            Semantics(
              button: true,
              label: 'Retry loading orders',
              child: FilledButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
