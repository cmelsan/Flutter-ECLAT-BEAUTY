import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  final String invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(invoiceId));

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        title: const Text('Factura'),
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          invoiceAsync.whenOrNull(
                data: (invoice) => IconButton(
                  icon: const Icon(Icons.share_outlined),
                  tooltip: 'Compartir',
                  onPressed: () => _shareInvoice(context, invoice),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: invoiceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text('Error al cargar la factura',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(e.toString(),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        data: (invoice) => _InvoiceBody(invoice: invoice),
      ),
    );
  }

  void _shareInvoice(BuildContext context, Invoice invoice) {
    final isCreditNote = invoice.type == 'credit_note';
    final docType = isCreditNote ? 'Factura de abono' : 'Factura';
    final text = '$docType ${invoice.invoiceNumber}\n'
        'Total: ${AppUtils.formatPrice(invoice.totalAmount.abs())}\n'
        'Fecha: ${_formatDate(invoice.issuedAt)}\n'
        'Éclat Beauty';
    SharePlus.instance.share(ShareParams(text: text));
  }

  static String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('d MMM yyyy', 'es_ES').format(dt.toLocal());
  }
}

// ─────────────────────────────────────────────────────────
// Invoice body — replicates the Astro facturas/[id].astro layout
// ─────────────────────────────────────────────────────────
class _InvoiceBody extends ConsumerWidget {
  final Invoice invoice;

  const _InvoiceBody({required this.invoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCreditNote = invoice.type == 'credit_note';
    final lineItems = invoice.lineItems;
    final address = invoice.customerAddress ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──
            _buildHeader(context, isCreditNote),
            const SizedBox(height: 28),

            // ── Credit note banner ──
            if (isCreditNote) ...[
              _buildCreditBanner(ref),
              const SizedBox(height: 24),
            ],

            // ── Parties (Emisor / Cliente) ──
            _buildParties(context, address),
            const SizedBox(height: 24),

            // ── Order reference ──
            _buildOrderRef(context),
            const SizedBox(height: 16),

            // ── Line items table ──
            _buildLineItemsTable(context, lineItems, isCreditNote),

            // ── Totals ──
            _buildTotals(context, isCreditNote),

            // ── Notes ──
            if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
              const SizedBox(height: 28),
              _buildNotes(context),
            ],

            // ── Footer ──
            const SizedBox(height: 36),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // ── HEADER ──
  Widget _buildHeader(BuildContext context, bool isCreditNote) {
    final docTitle = isCreditNote
        ? 'Factura de abono${invoice.creditNoteScope == 'partial' ? ' (parcial)' : ''}'
        : 'Factura de venta';

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Brand
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ÉCLAT BEAUTY',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TIENDA ONLINE DE COSMÉTICA',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textTertiary,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Right: Doc meta
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  docTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(invoice.issuedAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(height: 3, color: AppColors.black),
      ],
    );
  }

  // ── CREDIT NOTE BANNER ──
  Widget _buildCreditBanner(WidgetRef ref) {
    final scope = invoice.creditNoteScope == 'partial'
        ? 'devolución parcial'
        : 'devolución total';

    // Get reference invoice number if available
    Widget refWidget = const SizedBox.shrink();
    if (invoice.referenceInvoiceId != null) {
      final refAsync =
          ref.watch(referenceInvoiceNumberProvider(invoice.referenceInvoiceId!));
      refWidget = refAsync.when(
        data: (refNum) => refNum != null
            ? Text(
                'Ref. factura original: $refNum',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              )
            : const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'FACTURA DE ABONO — $scope'.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
          refWidget,
        ],
      ),
    );
  }

  // ── PARTIES ──
  Widget _buildParties(BuildContext context, Map<String, dynamic> address) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Emisor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _partyLabel('EMISOR'),
                    const SizedBox(height: 6),
                    _partyName('Éclat Beauty S.L.'),
                    const SizedBox(height: 4),
                    _partyInfo('CIF: B-XXXXXXXX'),
                    _partyInfo('Calle Ejemplo, 1'),
                    _partyInfo('28001 Madrid, España'),
                    _partyInfo('hola@eclatbeauty.com'),
                  ],
                ),
              ),
            ),
            Container(width: 1, color: AppColors.divider),
            // Cliente
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _partyLabel('CLIENTE'),
                    const SizedBox(height: 6),
                    _partyName(invoice.customerName ?? 'Cliente'),
                    const SizedBox(height: 4),
                    if (invoice.customerEmail != null)
                      _partyInfo(invoice.customerEmail!),
                    if (invoice.customerNif != null)
                      _partyInfo('NIF/CIF: ${invoice.customerNif}'),
                    if (address['address'] != null)
                      _partyInfo(address['address']),
                    if (address['city'] != null)
                      _partyInfo(
                          '${address['city']}${address['province'] != null ? ', ${address['province']}' : ''}'),
                    if (address['postal_code'] != null)
                      _partyInfo(
                          '${address['postal_code']} ${address['country'] ?? 'España'}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _partyLabel(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          color: AppColors.textTertiary,
        ),
      );

  Widget _partyName(String text) => Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      );

  Widget _partyInfo(String text) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      );

  // ── ORDER REFERENCE ──
  Widget _buildOrderRef(BuildContext context) {
    final orderNumber =
        invoice.orders?['order_number'] ?? invoice.orderId.substring(0, 8);
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
        children: [
          const TextSpan(text: 'Pedido: '),
          TextSpan(
            text: '#$orderNumber',
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  // ── LINE ITEMS TABLE ──
  Widget _buildLineItemsTable(
      BuildContext context, List<InvoiceLineItem> items, bool isCreditNote) {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          child: Row(
            children: [
              Expanded(flex: 4, child: _thText('DESCRIPCIÓN')),
              Expanded(flex: 1, child: _thText('CANT.', align: TextAlign.center)),
              Expanded(flex: 2, child: _thText('P. UNITARIO', align: TextAlign.right)),
              Expanded(flex: 2, child: _thText('BASE IMP.', align: TextAlign.right)),
              Expanded(
                  flex: 2,
                  child: _thText('IVA ${invoice.taxRate.toStringAsFixed(0)}%',
                      align: TextAlign.right)),
              Expanded(flex: 2, child: _thText('TOTAL', align: TextAlign.right)),
            ],
          ),
        ),
        // Table rows
        ...items.map((item) => _buildLineItemRow(item, isCreditNote)),
      ],
    );
  }

  Widget _thText(String text, {TextAlign align = TextAlign.left}) => Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: Colors.white,
        ),
      );

  Widget _buildLineItemRow(InvoiceLineItem item, bool isCreditNote) {
    final gross = item.unitPriceGross.abs();
    final net = item.unitPriceNet.abs();
    final tax = gross - net;
    final qty = item.quantity;
    final total = item.lineTotal.abs();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(item.name,
                style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              AppUtils.formatPrice(gross),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              AppUtils.formatPrice(net * qty),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              AppUtils.formatPrice(tax * qty),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${isCreditNote ? '-' : ''}${AppUtils.formatPrice(total)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isCreditNote ? AppColors.error : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TOTALS ──
  Widget _buildTotals(BuildContext context, bool isCreditNote) {
    final prefix = isCreditNote ? '-' : '';
    return Column(
      children: [
        Container(height: 2, color: AppColors.black),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 280,
            child: Column(
              children: [
                _totalsRow(
                  'Base imponible',
                  '$prefix${AppUtils.formatPrice(invoice.subtotal.abs())}',
                ),
                if (invoice.discountAmount > 0)
                  _totalsRow(
                    'Descuento (cupón)',
                    '-${AppUtils.formatPrice(invoice.discountAmount)}',
                  ),
                _totalsRow(
                  'IVA (${invoice.taxRate.toStringAsFixed(0)}%)',
                  '$prefix${AppUtils.formatPrice(invoice.taxAmount.abs())}',
                ),
                // Grand total
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                  decoration: BoxDecoration(
                    color: isCreditNote
                        ? const Color(0xFFDC2626)
                        : AppColors.black,
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$prefix${AppUtils.formatPrice(invoice.totalAmount.abs())}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _totalsRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ── NOTES ──
  Widget _buildNotes(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(left: BorderSide(color: AppColors.black, width: 3)),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NOTAS',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            invoice.notes!,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── FOOTER ──
  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.divider),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Éclat Beauty S.L. — CIF: B-XXXXXXXX',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Generado el ${_formatDate(DateTime.now())}',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return DateFormat('d MMM yyyy', 'es_ES').format(dt.toLocal());
  }
}
