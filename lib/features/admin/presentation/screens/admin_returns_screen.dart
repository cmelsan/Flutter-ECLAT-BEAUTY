import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/constants/app_utils.dart';
import '../../../../core/services/email_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/admin_provider.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';
import '../../../offers/presentation/providers/offers_provider.dart';
import '../../../orders/presentation/providers/invoice_provider.dart';

class AdminReturnsScreen extends ConsumerWidget {
  const AdminReturnsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returnsAsync = ref.watch(adminReturnsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Devoluciones')),
      body: returnsAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_return, size: 64, color: AppColors.textTertiary),
                  SizedBox(height: 16),
                  Text('No hay solicitudes de devolución'),
                ],
              ),
            );
          }

          // Separate by stage
          final pending = orders.where((o) => o['status'] == 'return_requested').toList();
          final awaitingRefund = orders.where((o) =>
              o['status'] == 'returned' || o['status'] == 'partially_returned').toList();
          final refunded = orders.where((o) =>
              o['status'] == 'refunded' || o['status'] == 'partially_refunded').toList();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(adminReturnsProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Stats row
                _StatsRow(
                  total: orders.length,
                  pending: pending.length,
                  awaitingRefund: awaitingRefund.length,
                  refunded: refunded.length,
                ),
                const SizedBox(height: 24),

                // Pending returns
                if (pending.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Pendientes de revisión',
                    count: pending.length,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  ...pending.map((order) => _ReturnOrderCard(
                    order: order,
                    stage: _ReturnStage.pendingReview,
                  )),
                  const SizedBox(height: 24),
                ],

                // Awaiting refund
                if (awaitingRefund.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Pendientes de reembolso',
                    count: awaitingRefund.length,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  ...awaitingRefund.map((order) => _ReturnOrderCard(
                    order: order,
                    stage: _ReturnStage.awaitingRefund,
                  )),
                  const SizedBox(height: 24),
                ],

                // Refunded
                if (refunded.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Reembolsados',
                    count: refunded.length,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  ...refunded.map((order) => _ReturnOrderCard(
                    order: order,
                    stage: _ReturnStage.completed,
                  )),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

// ── Stats Row ───────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int total, pending, awaitingRefund, refunded;

  const _StatsRow({
    required this.total,
    required this.pending,
    required this.awaitingRefund,
    required this.refunded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: 'Total', value: total, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        _StatCard(label: 'Pendientes', value: pending, color: Colors.orange),
        const SizedBox(width: 6),
        _StatCard(label: 'Por\nreembolsar', value: awaitingRefund, color: Colors.blue),
        const SizedBox(width: 6),
        _StatCard(label: 'Reembol-\nsados', value: refunded, color: Colors.green),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Text('$value', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 9, color: color), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ──────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SectionHeader({required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(10)),
          child: Text('$count', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// ── Return Stage Enum ───────────────────────────────────

enum _ReturnStage { pendingReview, awaitingRefund, completed }

// ── Return Order Card ───────────────────────────────────

class _ReturnOrderCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> order;
  final _ReturnStage stage;

  const _ReturnOrderCard({required this.order, required this.stage});

  @override
  ConsumerState<_ReturnOrderCard> createState() => _ReturnOrderCardState();
}

class _ReturnOrderCardState extends ConsumerState<_ReturnOrderCard> {
  bool _isLoading = false;

  Map<String, dynamic> get order => widget.order;
  List<dynamic> get items => (order['order_items'] as List?) ?? [];
  int get totalAmount => (order['total_amount'] as num?)?.toInt() ?? 0;

  List<dynamic> get returnedItems =>
      items.where((i) => i['return_status'] != null).toList();

  /// Calculate refund amount from items with return_status set.
  /// Falls back to order total_amount when no items have return_status
  /// (full-order returns where request_return didn't set item-level status).
  /// This matches the Astro web behavior:
  ///   refundAmountCents={refundAmount > 0 ? refundAmount : order.total_amount}
  int get refundAmountCents {
    int total = 0;
    for (final item in returnedItems) {
      if (['requested', 'approved', 'refunded'].contains(item['return_status'])) {
        total += ((item['price_at_purchase'] as num).toInt()) *
            ((item['quantity'] as num).toInt());
      }
    }
    // Fallback: if no items have return_status, use order total (full return)
    if (total == 0 && items.isNotEmpty) {
      return totalAmount;
    }
    return total;
  }

  /// Whether this is a partial return (only some items returned, not all).
  /// If no items have return_status set, treat as full return.
  bool get isPartialReturn {
    if (returnedItems.isEmpty) return false; // No item-level status → full return
    return returnedItems.length < items.length;
  }

  @override
  Widget build(BuildContext context) {
    final orderNumber = order['order_number'] ?? 'N/A';
    final status = order['status'] ?? '';
    final returnReason = order['return_reason'] ?? 'Sin motivo';
    final totalAmount = (order['total_amount'] as num?)?.toInt() ?? 0;
    final updatedAt = order['updated_at'] != null
        ? DateTime.tryParse(order['updated_at'])
        : null;

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
                Text('Pedido #$orderNumber',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                _OrderStatusChip(status: status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Total: ${AppUtils.formatPrice(totalAmount)}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            if (updatedAt != null)
              Text(
                'Actualizado: ${DateFormat('dd/MM/yyyy HH:mm').format(updatedAt)}',
                style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),

            const SizedBox(height: 8),
            Text('Motivo: $returnReason',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),

            // Items list with return status badges
            const Divider(height: 20),
            const Text('Productos:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 4),
            ...items.map((item) => _ReturnItemRow(item: item)),

            // Action buttons based on stage
            if (widget.stage == _ReturnStage.pendingReview) ...[
              const Divider(height: 24),
              _PendingReviewActions(
                isLoading: _isLoading,
                refundEstimate: refundAmountCents,
                onApproveWithStock: () => _processReturn('returned', restoreStock: true),
                onApproveNoStock: () => _processReturn('returned', restoreStock: false),
                onReject: () => _processReturn('delivered', restoreStock: false),
              ),
            ],

            if (widget.stage == _ReturnStage.awaitingRefund) ...[
              const Divider(height: 24),
              _AwaitingRefundActions(
                isLoading: _isLoading,
                refundAmountCents: refundAmountCents,
                totalAmountCents: totalAmount,
                isPartial: isPartialReturn,
                stripePaymentIntentId: order['stripe_payment_intent_id'] as String?,
                onProcessRefund: (amount) => _processRefund(refundAmount: amount),
              ),
            ],

            if (widget.stage == _ReturnStage.completed) ...[
              const Divider(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text('Reembolso completado',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _ReturnInvoicesRow(orderId: order['id'] as String),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _processReturn(String newStatus, {bool restoreStock = false}) async {
    final action = newStatus == 'delivered'
        ? 'rechazar la devolución (volver a "Entregado")'
        : restoreStock
            ? 'aprobar la devolución y restaurar stock'
            : 'aprobar la devolución sin restaurar stock';

    final notesCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(newStatus == 'delivered' ? 'Rechazar devolución' : 'Aprobar devolución'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Estás seguro de que quieres $action?'),
            const SizedBox(height: 16),
            TextField(
              controller: notesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                border: OutlineInputBorder(),
                hintText: 'Notas del administrador...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: newStatus == 'delivered' ? AppColors.error : AppColors.success,
            ),
            child: Text(newStatus == 'delivered' ? 'Rechazar' : 'Aprobar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);

    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.processReturn(
      orderId: order['id'],
      newStatus: newStatus,
      restoreStock: restoreStock,
      notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,
    );

    notesCtrl.dispose();

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${failure.message}'), backgroundColor: AppColors.error),
      ),
      (data) {
        final msg = newStatus == 'delivered'
            ? 'Devolución rechazada'
            : 'Devolución aprobada${restoreStock ? ' (stock restaurado)' : ''}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.success),
        );
        // Send return-approved email if approved (non-blocking)
        if (newStatus != 'delivered') {
          final name = (order['customer_name'] ?? 'Cliente') as String;
          final orderNumber = (order['order_number'] ?? order['id']) as String;
          EmailService.resolveCustomerEmail(
            ref.read(supabaseClientProvider),
            guestEmail: order['guest_email'] as String?,
            userId: order['user_id'] as String?,
          ).then((email) {
            if (email.isNotEmpty) {
              EmailService.sendReturnApproved(
                email: email,
                customerName: name,
                returnNumber: orderNumber,
              );
            }
          });
        }
        ref.invalidate(adminReturnsProvider);
        // Invalidate catalog cache so product stock shows correctly after restoration
        if (restoreStock) {
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(enrichedFeaturedProductsProvider);
          ref.invalidate(offersProvider);
        }
      },
    );
  }

  Future<void> _processRefund({double? refundAmount}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Procesar reembolso'),
        content: Text(
          refundAmount != null
              ? '¿Procesar reembolso parcial de ${refundAmount.toStringAsFixed(2)} € vía Stripe?'
              : '¿Procesar reembolso total vía Stripe?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Procesar reembolso'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);

    final repo = ref.read(adminRepositoryProvider);
    final result = await repo.processRefund(
      orderId: order['id'],
      refundAmount: refundAmount,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${failure.message}'), backgroundColor: AppColors.error),
      ),
      (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reembolso procesado correctamente'), backgroundColor: AppColors.success),
        );
        // Send refund-processed email (non-blocking)
        final name = (order['customer_name'] ?? 'Cliente') as String;
        final orderNumber = (order['order_number'] ?? order['id']) as String;
        final totalAmount = (order['total_amount'] as num?)?.toInt() ?? 0;
        final refundCents = refundAmount != null
            ? (refundAmount * 100).round()
            : totalAmount;
        EmailService.resolveCustomerEmail(
          ref.read(supabaseClientProvider),
          guestEmail: order['guest_email'] as String?,
          userId: order['user_id'] as String?,
        ).then((email) {
          if (email.isNotEmpty) {
            EmailService.sendRefundProcessed(
              email: email,
              customerName: name,
              orderNumber: orderNumber,
              refundAmountCents: refundCents,
            );
          }
        });
        ref.invalidate(adminReturnsProvider);
        // Refresh catalog cache after refund (stock may have been restored at approval stage)
        ref.invalidate(featuredProductsProvider);
        ref.invalidate(enrichedFeaturedProductsProvider);
        ref.invalidate(offersProvider);
      },
    );
  }
}

// ── Return Item Row ─────────────────────────────────────

class _ReturnItemRow extends StatelessWidget {
  final dynamic item;

  const _ReturnItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final productName = item['product']?['name'] ?? 'Producto';
    final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
    final price = (item['price_at_purchase'] as num?)?.toInt() ?? 0;
    final returnStatus = item['return_status'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: const TextStyle(fontSize: 13)),
                Text('x$quantity · ${AppUtils.formatPrice(price * quantity)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (returnStatus != null) _ItemReturnBadge(status: returnStatus),
        ],
      ),
    );
  }
}

class _ItemReturnBadge extends StatelessWidget {
  final String status;

  const _ItemReturnBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'requested':
        color = Colors.orange;
        label = 'Solicitado';
      case 'approved':
        color = Colors.blue;
        label = 'Aprobado';
      case 'rejected':
        color = Colors.red;
        label = 'Rechazado';
      case 'refunded':
        color = Colors.green;
        label = 'Reembolsado';
      default:
        color = AppColors.textDisabled;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

// ── Pending Review Actions ──────────────────────────────

class _PendingReviewActions extends StatelessWidget {
  final bool isLoading;
  final int refundEstimate;
  final VoidCallback onApproveWithStock;
  final VoidCallback onApproveNoStock;
  final VoidCallback onReject;

  const _PendingReviewActions({
    required this.isLoading,
    required this.refundEstimate,
    required this.onApproveWithStock,
    required this.onApproveNoStock,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (refundEstimate > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Reembolso estimado: ${AppUtils.formatPrice(refundEstimate)}',
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close, size: 14),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text('Rechazar', style: TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ElevatedButton(
                onPressed: onApproveNoStock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 14),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text('Aprobar', style: TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ElevatedButton(
                onPressed: onApproveWithStock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory, size: 14),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text('Aprobar+Stock', style: TextStyle(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Awaiting Refund Actions ─────────────────────────────

class _AwaitingRefundActions extends StatelessWidget {
  final bool isLoading;
  final int refundAmountCents;
  final int totalAmountCents;
  final bool isPartial;
  final String? stripePaymentIntentId;
  final void Function(double? amount) onProcessRefund;

  const _AwaitingRefundActions({
    required this.isLoading,
    required this.refundAmountCents,
    required this.totalAmountCents,
    required this.isPartial,
    required this.stripePaymentIntentId,
    required this.onProcessRefund,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
    }

    // Si no hay stripe_payment_intent_id (pedidos anteriores al fix), no se puede reembolsar via Stripe
    if (stripePaymentIntentId == null || stripePaymentIntentId!.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withAlpha(80)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Text('Reembolso manual requerido',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 6),
            Text(
              'Este pedido no tiene ID de pago de Stripe guardado (pedido antiguo). '
              'Procesa el reembolso manualmente desde el panel de Stripe.',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
          ],
        ),
      );
    }

    // For partial returns, send exact amount; for full returns, send null (Stripe refunds full charge)
    final refundEuros = isPartial ? refundAmountCents / 100.0 : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isPartial) ...[
          Text(
            'Reembolso parcial: ${AppUtils.formatPrice(refundAmountCents)} de ${AppUtils.formatPrice(totalAmountCents)}',
            style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => onProcessRefund(refundEuros),
            icon: const Icon(Icons.payment),
            label: Text(isPartial ? 'Procesar reembolso parcial' : 'Procesar reembolso total'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Order Status Chip ───────────────────────────────────

class _OrderStatusChip extends StatelessWidget {
  final String status;

  const _OrderStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'return_requested':
        color = Colors.orange;
        label = 'Devolución solicitada';
      case 'returned':
        color = Colors.blue;
        label = 'Devuelto';
      case 'partially_returned':
        color = Colors.blue;
        label = 'Parcialmente devuelto';
      case 'refunded':
        color = Colors.green;
        label = 'Reembolsado';
      case 'partially_refunded':
        color = Colors.green;
        label = 'Parcialmente reembolsado';
      default:
        color = AppColors.textDisabled;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Invoice buttons for completed returns
// ─────────────────────────────────────────────────────────
class _ReturnInvoicesRow extends ConsumerWidget {
  final String orderId;

  const _ReturnInvoicesRow({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesForOrderProvider(orderId));

    return invoicesAsync.when(
      loading: () => const SizedBox(
        height: 32,
        child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (invoices) {
        if (invoices.isEmpty) return const SizedBox.shrink();

        return Wrap(
          spacing: 8,
          runSpacing: 6,
          children: invoices.map((inv) {
            final isCreditNote = inv.type == 'credit_note';
            return OutlinedButton.icon(
              onPressed: () => context.push('/factura/${inv.id}'),
              icon: Icon(
                isCreditNote ? Icons.receipt_long : Icons.description_outlined,
                size: 16,
                color: isCreditNote ? AppColors.error : AppColors.black,
              ),
              label: Text(
                isCreditNote
                    ? 'Ver abono ${inv.invoiceNumber}'
                    : 'Ver factura ${inv.invoiceNumber}',
                style: TextStyle(
                  fontSize: 11,
                  color: isCreditNote ? AppColors.error : AppColors.textPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isCreditNote ? AppColors.error.withValues(alpha: 0.5) : AppColors.divider,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                minimumSize: Size.zero,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
