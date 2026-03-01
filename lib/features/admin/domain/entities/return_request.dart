// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_request.freezed.dart';
part 'return_request.g.dart';

@freezed
class ReturnRequest with _$ReturnRequest {
  const factory ReturnRequest({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'return_status') String? returnStatus,
    @JsonKey(name: 'return_reason') String? returnReason,
    @JsonKey(name: 'return_requested_at') DateTime? returnRequestedAt,
    @JsonKey(name: 'return_processed_at') DateTime? returnProcessedAt,
    // Add joined fields for UI if they come from Supabase query
    Map<String, dynamic>? order,
    Map<String, dynamic>? product,
  }) = _ReturnRequest;

  factory ReturnRequest.fromJson(Map<String, dynamic> json) => _$ReturnRequestFromJson(json);
}
