import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../../core/services/email_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/order.dart';
import '../providers/invoice_provider.dart';
import '../providers/order_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del pedido'),
      ),
      body: orderAsync.when(
        data: (order) => _OrderDetailBody(order: order),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Error: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(orderDetailProvider(orderId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetailBody extends ConsumerWidget {
  final Order order;

  const _OrderDetailBody({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCancel = order.status == OrderStatus.paid;
    // Un pedido puede devolverse si está "entregado" (delivered) o es "parcialmente devuelto"
    final bool isDeliveredOrPartiallyReturned =
        order.status == OrderStatus.delivered ||
        order.status == 'partially_returned'; // Agregamos este estado también
        
    // Verificamos si aún está a tiempo
    final bool isWithinReturnWindow = order.deliveredAt != null
        ? DateTime.now().difference(order.deliveredAt!).inDays <=
            AppConstants.returnWindowDays
        : true; // O asumimos que es cierto si no sabemos cuándo se entregó para no bloquearlo indebidamente.

    // En la versión Astro se valida también si hay artículos retornables
    // const hasReturnableItems = items.some(i => !i.return_status || i.return_status === 'rejected');
    final hasReturnableItems = order.orderItems.any((item) =>
        item.returnStatus == null || item.returnStatus == 'rejected');

    final canReturn =
        isDeliveredOrPartiallyReturned && isWithinReturnWindow && hasReturnableItems;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(orderDetailProvider(order.id));
        // Opcional esperarlo
        try {
          await ref.read(orderDetailProvider(order.id).future);
        } catch (_) {}
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Order header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.orderNumber,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _StatusChip(status: order.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (order.createdAt != null)
                    Text(
                      'Realizado el ${AppUtils.formatDate(order.createdAt!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status timeline
          Text(
            'Estado',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _StatusTimeline(order: order),
          const SizedBox(height: 16),

          // Order items
          Text(
            'Productos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...order.orderItems.map((item) => _OrderItemTile(item: item)),

          // Coupon info
          if (order.couponId != null) ...[
            const SizedBox(height: 12),
            Card(
              color: AppColors.primaryLight.withAlpha(40),
              child: ListTile(
                leading: const Icon(Icons.local_offer, color: AppColors.primary),
                title: Text('Cupón aplicado'),
                trailing: Text(
                  '-${AppUtils.formatPrice(order.discountAmount)}',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],

          // Total
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppUtils.formatPrice(order.totalAmount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Invoices / Facturas
          _InvoicesSection(orderId: order.id),
          const SizedBox(height: 16),

          // Shipping address
          if (order.shippingAddress != null) ...[
            Text(
              'Dirección de envío',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.shippingAddress!['fullName'] != null)
                      Text(
                        order.shippingAddress!['fullName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    Text(order.shippingAddress!['street'] ?? ''),
                    Text(
                      '${order.shippingAddress!['postalCode'] ?? ''} ${order.shippingAddress!['city'] ?? ''}',
                    ),
                    if (order.shippingAddress!['phone'] != null)
                      Text('Tel: ${order.shippingAddress!['phone']}'),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action buttons
          if (canCancel)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _cancelOrder(context, ref),
                icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                label: const Text(
                  'Cancelar pedido',
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),

          if (canReturn) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _requestReturn(context, ref),
                icon: const Icon(Icons.assignment_return),
                label: const Text('Solicitar devolución'),
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    ),
    );
  }

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar pedido'),
        content: const Text(
          '¿Estás seguro de que quieres cancelar este pedido? '
          'Se procesará el reembolso automáticamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repo = ref.read(orderRepositoryProvider);
      final result = await repo.cancelOrder(order.id);
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
          ref.invalidate(orderDetailProvider(order.id));
          ref.invalidate(myOrdersProvider);
          // Send cancellation email (non-blocking)
          EmailService.resolveCustomerEmail(
            ref.read(supabaseClientProvider),
            guestEmail: order.guestEmail,
            userId: order.userId,
          ).then((email) {
            if (email.isNotEmpty) {
              EmailService.sendCancellationNotification(
                email: email,
                customerName: order.customerName ?? 'Cliente',
                orderNumber: order.orderNumber,
                totalCents: order.totalAmount,
              );
            }
          });
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pedido cancelado correctamente'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
      );
    }
  }

  Future<void> _requestReturn(BuildContext context, WidgetRef ref) async {
    final reasonCtrl = TextEditingController();

    final returnableItems = order.orderItems.where((item) =>
        item.returnStatus == null || item.returnStatus == 'rejected').toList();

    debugPrint('[Return] Returnable items: ${returnableItems.length}');
    for (final item in returnableItems) {
      debugPrint('[Return]   item.id=${item.id}, returnStatus=${item.returnStatus}');
    }

    if (returnableItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay productos disponibles para devolver.')),
      );
      return;
    }

    final selectedItems = <String>{};

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Solicitar devolución'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selecciona los productos a devolver:'),
                    const SizedBox(height: 8),
                    ...returnableItems.map((item) {
                      final isSelected = selectedItems.contains(item.id);
                      final productName = item.product?['name'] ?? 'Producto';
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedItems.add(item.id);
                            } else {
                              selectedItems.remove(item.id);
                            }
                          });
                        },
                        title: Text(productName),
                        subtitle: Text('Cantidad: ${item.quantity}'),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                    const SizedBox(height: 16),
                    const Text('Indica el motivo de la devolución:'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: reasonCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Motivo...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Dirección de devolución:\n'
                      '${AppConstants.returnAddress['street']}\n'
                      '${AppConstants.returnAddress['postalCode']} ${AppConstants.returnAddress['city']}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: selectedItems.isEmpty ? null : () => Navigator.pop(ctx, true),
                child: const Text('Solicitar'),
              ),
            ],
          );
        },
      ),
    );

    debugPrint('[Return] Dialog result: confirmed=$confirmed, context.mounted=${context.mounted}');
    debugPrint('[Return] Selected items: $selectedItems');
    debugPrint('[Return] Reason: "${reasonCtrl.text.trim()}"');

    if (confirmed == true && context.mounted) {
      if (reasonCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, indica un motivo'), backgroundColor: AppColors.error),
        );
        return;
      }
      try {
        final repo = ref.read(orderRepositoryProvider);
        final result = await repo.requestReturn(
          orderId: order.id,
          reason: reasonCtrl.text.trim(),
          itemIds: selectedItems.toList(),
        );
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
            ref.invalidate(orderDetailProvider(order.id));
            ref.invalidate(myOrdersProvider);
            // Send return-initiated email (non-blocking)
            EmailService.resolveCustomerEmail(
              ref.read(supabaseClientProvider),
              guestEmail: order.guestEmail,
              userId: order.userId,
            ).then((email) {
              if (email.isNotEmpty) {
                EmailService.sendReturnInitiated(
                  orderId: order.id,
                  orderNumber: order.orderNumber,
                  customerEmail: email,
                  customerName: order.customerName ?? 'Cliente',
                  returnReason: reasonCtrl.text.trim(),
                );
              }
            });
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Devolución solicitada correctamente'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
    reasonCtrl.dispose();
  }
}

// ── Status Timeline ─────────────────────────────────────

class _StatusTimeline extends StatelessWidget {
  final Order order;

  const _StatusTimeline({required this.order});

  @override
  Widget build(BuildContext context) {
    final steps = _getTimelineSteps();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < steps.length; i++) ...[
              _TimelineStep(
                label: steps[i]['label'] as String,
                date: steps[i]['date'] as DateTime?,
                isCompleted: steps[i]['completed'] as bool,
                isLast: i == steps.length - 1,
                icon: steps[i]['icon'] as IconData,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTimelineSteps() {
    final status = order.status;
    final isCancelled = status == OrderStatus.cancelled;
    final isReturn = status == OrderStatus.returnRequested ||
        status == OrderStatus.returned ||
        status == OrderStatus.partiallyReturned ||
        status == OrderStatus.refunded ||
        status == OrderStatus.partiallyRefunded;

    final steps = <Map<String, dynamic>>[
      {
        'label': 'Pedido realizado',
        'date': order.createdAt,
        'completed': true,
        'icon': Icons.receipt,
      },
      {
        'label': 'Pago confirmado',
        'date': order.status != OrderStatus.awaitingPayment
            ? order.createdAt
            : null,
        'completed': status != OrderStatus.awaitingPayment,
        'icon': Icons.payment,
      },
      {
        'label': 'Enviado',
        'date': null,
        'completed': [
          OrderStatus.shipped,
          OrderStatus.delivered,
          OrderStatus.returnRequested,
          OrderStatus.returned,
          OrderStatus.partiallyReturned,
          OrderStatus.refunded,
          OrderStatus.partiallyRefunded,
        ].contains(status),
        'icon': Icons.local_shipping,
      },
      {
        'label': 'Entregado',
        'date': order.deliveredAt,
        'completed': [
          OrderStatus.delivered,
          OrderStatus.returnRequested,
          OrderStatus.returned,
          OrderStatus.partiallyReturned,
          OrderStatus.refunded,
          OrderStatus.partiallyRefunded,
        ].contains(status),
        'icon': Icons.check_circle,
      },
    ];

    if (isCancelled) {
      steps.add({
        'label': 'Cancelado',
        'date': null,
        'completed': true,
        'icon': Icons.cancel,
      });
    }

    if (isReturn) {
      steps.add({
        'label': 'Devolución solicitada',
        'date': order.returnInitiatedAt,
        'completed': true,
        'icon': Icons.assignment_return,
      });
      if ([OrderStatus.returned, OrderStatus.partiallyReturned,
           OrderStatus.refunded, OrderStatus.partiallyRefunded].contains(status)) {
        steps.add({
          'label': status == OrderStatus.partiallyReturned
              ? 'Parcialmente devuelto'
              : 'Devuelto',
          'date': null,
          'completed': true,
          'icon': Icons.inventory,
        });
      }
      if ([OrderStatus.refunded, OrderStatus.partiallyRefunded].contains(status)) {
        steps.add({
          'label': status == OrderStatus.partiallyRefunded
              ? 'Parcialmente reembolsado'
              : 'Reembolsado',
          'date': null,
          'completed': true,
          'icon': Icons.currency_exchange,
        });
      }
    }

    return steps;
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final DateTime? date;
  final bool isCompleted;
  final bool isLast;
  final IconData icon;

  const _TimelineStep({
    required this.label,
    this.date,
    required this.isCompleted,
    required this.isLast,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primary : AppColors.surfaceVariant,
              ),
              child: Icon(
                icon,
                size: 16,
                color: isCompleted ? Colors.white : AppColors.textTertiary,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: isCompleted ? AppColors.primary : AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight:
                        isCompleted ? FontWeight.w600 : FontWeight.normal,
                    color: isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
                if (date != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      AppUtils.formatDate(date!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                if (!isLast) const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Order Item Tile ─────────────────────────────────────

class _OrderItemTile extends StatelessWidget {
  final OrderItem item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildProductImage(item, 56),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product?['name'] as String? ?? 'Producto',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: item.returnStatus != null && item.returnStatus != 'rejected'
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cantidad: ${item.quantity}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (item.returnStatus != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getReturnStatusColor(item.returnStatus!).withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getReturnStatusLabel(item.returnStatus!),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getReturnStatusColor(item.returnStatus!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              AppUtils.formatPrice(item.priceAtPurchase * item.quantity),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(OrderItem item, double size) {
    final images = item.product?['images'];
    String? imageUrl;
    if (images is List && images.isNotEmpty) {
      imageUrl = images.first as String?;
    }
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(size),
      );
    }
    return _imagePlaceholder(size);
  }

  Widget _imagePlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_outlined, color: AppColors.textTertiary),
    );
  }

  Color _getReturnStatusColor(String status) {
    switch (status) {
      case 'requested':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'processed':
      case 'refunded':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getReturnStatusLabel(String status) {
    switch (status) {
      case 'requested':
        return 'Devolución solicitada';
      case 'approved':
        return 'Devolución aprobada';
      case 'processed':
      case 'refunded':
        return 'Reembolsado';
      case 'rejected':
        return 'Devolución rechazada';
      default:
        return 'Estado: $status';
    }
  }
}

// ── Status Chip ─────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColor().withAlpha(30),
        borderRadius: BorderRadius.circular(20),
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

// ─────────────────────────────────────────────────────────
// Invoices section — shows invoice/credit note buttons for the order
// ─────────────────────────────────────────────────────────
class _InvoicesSection extends ConsumerWidget {
  final String orderId;

  const _InvoicesSection({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesForOrderProvider(orderId));

    return invoicesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (invoices) {
        if (invoices.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documentos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...invoices.map((inv) => _InvoiceTile(invoice: inv)),
          ],
        );
      },
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceTile({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final isCreditNote = invoice.type == 'credit_note';
    final icon = isCreditNote ? Icons.receipt_long : Icons.description_outlined;
    final label = isCreditNote
        ? 'Factura de abono${invoice.creditNoteScope == 'partial' ? ' (parcial)' : ''}'
        : 'Factura de venta';
    final color = isCreditNote ? AppColors.error : AppColors.black;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: color,
          ),
        ),
        subtitle: Text(
          invoice.invoiceNumber,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: AppColors.textTertiary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppUtils.formatPrice(invoice.totalAmount.abs()),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isCreditNote ? AppColors.error : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
        onTap: () => context.push('/factura/${invoice.id}'),
      ),
    );
  }
}
