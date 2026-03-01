import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../../core/services/email_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../providers/admin_provider.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(adminOrdersFilterProvider);
    final ordersAsync = ref.watch(adminOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: Column(
        children: [
          // Status filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todos',
                  selected: filter == null,
                  onSelected: () =>
                      ref.read(adminOrdersFilterProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                ...[
                  OrderStatus.awaitingPayment,
                  OrderStatus.paid,
                  OrderStatus.shipped,
                  OrderStatus.delivered,
                  OrderStatus.cancelled,
                  OrderStatus.returnRequested,
                  OrderStatus.returned,
                  OrderStatus.partiallyReturned,
                  OrderStatus.refunded,
                  OrderStatus.partiallyRefunded,
                ].map((status) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: OrderStatus.label(status),
                    selected: filter == status,
                    onSelected: () =>
                        ref.read(adminOrdersFilterProvider.notifier).state = status,
                  ),
                )),
              ],
            ),
          ),

          // Orders list
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return const Center(
                    child: Text('No hay pedidos'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _AdminOrderCard(order: order);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _AdminOrderCard extends ConsumerWidget {
  final Order order;

  const _AdminOrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderNumber,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _OrderStatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),

            // Customer info
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.customerName ?? 'Cliente',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (order.guestEmail != null && order.guestEmail!.isNotEmpty) ...
              [
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.guestEmail!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            const SizedBox(height: 4),

            // Date & total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppUtils.formatDate(order.createdAt ?? DateTime.now()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  AppUtils.formatPrice(order.totalAmount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${order.orderItems.length} producto(s)',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 12),

            // Status update actions
            if (_canUpdateStatus(order.status)) ...[
              const Divider(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _getAvailableActions(order.status).map((action) {
                  return OutlinedButton.icon(
                    onPressed: () => _updateStatus(context, ref, order, action),
                    icon: Icon(_getActionIcon(action), size: 16),
                    label: Text(OrderStatus.label(action)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _getStatusColor(action),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _canUpdateStatus(String status) {
    // Only allow transitions for paid and shipped.
    // Return-related transitions are handled from AdminReturnsScreen.
    return status == OrderStatus.paid || status == OrderStatus.shipped;
  }

  List<String> _getAvailableActions(String status) {
    switch (status) {
      case OrderStatus.paid:
        return [OrderStatus.shipped, OrderStatus.cancelled];
      case OrderStatus.shipped:
        return [OrderStatus.delivered];
      default:
        return [];
    }
  }

  IconData _getActionIcon(String status) {
    switch (status) {
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.returned:
        return Icons.assignment_return;
      case OrderStatus.refunded:
        return Icons.currency_exchange;
      default:
        return Icons.update;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case OrderStatus.shipped:
        return AppColors.statusShipped;
      case OrderStatus.delivered:
        return AppColors.statusDelivered;
      case OrderStatus.cancelled:
        return AppColors.statusCancelled;
      case OrderStatus.returned:
        return AppColors.statusReturn;
      case OrderStatus.refunded:
        return AppColors.statusRefunded;
      default:
        return AppColors.textSecondary;
    }
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    Order order,
    String newStatus,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar cambio'),
        content: Text(
          '¿Cambiar estado a "${OrderStatus.label(newStatus)}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final adminRepo = ref.read(adminRepositoryProvider);

      late final Either result;
      switch (newStatus) {
        case OrderStatus.shipped:
          result = await adminRepo.markShipped(order.id);
          break;
        case OrderStatus.delivered:
          result = await adminRepo.markDelivered(order.id);
          break;
        case OrderStatus.cancelled:
          result = await adminRepo.adminCancelOrder(order.id);
          break;
        default:
          return;
      }

      result.fold(
        (failure) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${failure.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        (_) {
          ref.invalidate(adminOrdersProvider);
          // Send email notification (non-blocking)
          final name = order.customerName ?? 'Cliente';
          EmailService.resolveCustomerEmail(
            ref.read(supabaseClientProvider),
            guestEmail: order.guestEmail,
            userId: order.userId,
          ).then((email) {
            if (email.isNotEmpty) {
              switch (newStatus) {
                case OrderStatus.shipped:
                  EmailService.sendShippingNotification(
                    email: email,
                    customerName: name,
                  );
                  break;
                case OrderStatus.delivered:
                  EmailService.sendDeliveryConfirmation(
                    email: email,
                    customerName: name,
                  );
                  break;
                case OrderStatus.cancelled:
                  EmailService.sendCancellationNotification(
                    email: email,
                    customerName: name,
                    orderNumber: order.orderNumber,
                    totalCents: order.totalAmount,
                  );
                  break;
              }
            }
          });
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Estado actualizado a ${OrderStatus.label(newStatus)}'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
      );
    }
  }
}

class _OrderStatusChip extends StatelessWidget {
  final String status;

  const _OrderStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        OrderStatus.label(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getColor(),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case OrderStatus.awaitingPayment:
        return AppColors.statusPending;
      case OrderStatus.paid:
        return AppColors.statusPaid;
      case OrderStatus.shipped:
        return AppColors.statusShipped;
      case OrderStatus.delivered:
        return AppColors.statusDelivered;
      case OrderStatus.cancelled:
        return AppColors.statusCancelled;
      case OrderStatus.returnRequested:
        return AppColors.statusReturn;
      case OrderStatus.returned:
      case OrderStatus.partiallyReturned:
        return AppColors.statusReturn;
      case OrderStatus.refunded:
      case OrderStatus.partiallyRefunded:
        return AppColors.statusRefunded;
      default:
        return AppColors.textSecondary;
    }
  }
}
