import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_sale.freezed.dart';
part 'flash_sale.g.dart';

@freezed
abstract class FlashSale with _$FlashSale {
  const FlashSale._();

  const factory FlashSale({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'discount_percentage') required int discountPercentage,
    @JsonKey(name: 'starts_at') required DateTime startsAt,
    @JsonKey(name: 'ends_at') required DateTime endsAt,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FlashSale;

  /// Whether the flash sale is currently running
  bool get isLive {
    final now = DateTime.now();
    return isActive && now.isAfter(startsAt) && now.isBefore(endsAt);
  }

  /// Time remaining until end
  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(endsAt)) return Duration.zero;
    return endsAt.difference(now);
  }

  factory FlashSale.fromJson(Map<String, dynamic> json) =>
      _$FlashSaleFromJson(json);
}
