import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../domain/entities/invoice.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(ref.watch(supabaseClientProvider));
});

/// Invoices for a specific order (list view in order detail)
final invoicesForOrderProvider =
    FutureProvider.family<List<Invoice>, String>((ref, orderId) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  final result = await repo.getInvoicesForOrder(orderId);
  return result.fold((f) => <Invoice>[], (invoices) => invoices);
});

/// Single invoice detail (full data with line items)
final invoiceDetailProvider =
    FutureProvider.family<Invoice, String>((ref, invoiceId) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  final result = await repo.getInvoiceById(invoiceId);
  return result.fold(
      (f) => throw Exception(f.message), (invoice) => invoice);
});

/// Reference invoice number for credit notes
final referenceInvoiceNumberProvider =
    FutureProvider.family<String?, String>((ref, referenceInvoiceId) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  return repo.getReferenceInvoiceNumber(referenceInvoiceId);
});
