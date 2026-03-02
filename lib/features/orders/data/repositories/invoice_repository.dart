import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/invoice.dart';

class InvoiceRepository {
  final SupabaseClient _client;

  InvoiceRepository(this._client);

  /// Get all invoices for a given order
  Future<Either<Failure, List<Invoice>>> getInvoicesForOrder(
      String orderId) async {
    try {
      final data = await _client
          .from('invoices')
          .select(
              'id, type, invoice_number, order_id, total_amount, credit_note_scope, issued_at')
          .eq('order_id', orderId)
          .order('issued_at', ascending: true);

      return Right(
        (data as List).map((e) {
          // These list items don't have line_items, provide defaults
          final json = Map<String, dynamic>.from(e);
          json['subtotal'] ??= 0;
          json['tax_rate'] ??= 0;
          json['tax_amount'] ??= 0;
          return Invoice.fromJson(json);
        }).toList(),
      );
    } catch (e) {
      debugPrint('InvoiceRepository.getInvoicesForOrder error: $e');
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get single invoice by ID with full details
  Future<Either<Failure, Invoice>> getInvoiceById(String invoiceId) async {
    try {
      final data = await _client
          .from('invoices')
          .select(
              '*, orders!invoices_order_id_fkey(order_number, status, user_id)')
          .eq('id', invoiceId)
          .single();

      return Right(Invoice.fromJson(data));
    } catch (e) {
      debugPrint('InvoiceRepository.getInvoiceById error: $e');
      return Left(ServerFailure(ErrorMapper.mapSupabaseError(e)));
    }
  }

  /// Get the reference invoice number for a credit note
  Future<String?> getReferenceInvoiceNumber(String referenceInvoiceId) async {
    try {
      final data = await _client
          .from('invoices')
          .select('invoice_number')
          .eq('id', referenceInvoiceId)
          .single();
      return data['invoice_number'] as String?;
    } catch (e) {
      debugPrint('InvoiceRepository.getReferenceInvoiceNumber error: $e');
      return null;
    }
  }
}
