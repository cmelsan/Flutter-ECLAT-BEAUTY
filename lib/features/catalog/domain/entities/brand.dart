import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';
part 'brand.g.dart';

@freezed
abstract class Brand with _$Brand {
  const factory Brand({
    required String id,
    required String name,
    required String slug,
    @JsonKey(name: 'logo_url') String? logoUrl,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) =>
      _$BrandFromJson(json);
}
