import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    required String email,
    @JsonKey(name: 'is_admin') @Default(false) bool isAdmin,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppUser;

  /// Display name: full name or email prefix
  String get displayName =>
      fullName?.isNotEmpty == true ? fullName! : email.split('@').first;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

@freezed
abstract class UserAddress with _$UserAddress {
  const factory UserAddress({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'address_data') required Map<String, dynamic> addressData,
    @JsonKey(name: 'address_type') @Default('shipping') String addressType,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);
}

/// Helper to parse address_data JSONB
class AddressData {
  final String street;
  final String city;
  final String postalCode;
  final String province;
  final String country;
  final String? phone;
  final String? name;

  const AddressData({
    required this.street,
    required this.city,
    required this.postalCode,
    this.province = '',
    this.country = 'ES',
    this.phone,
    this.name,
  });

  factory AddressData.fromMap(Map<String, dynamic> map) {
    return AddressData(
      street: map['street'] as String? ?? '',
      city: map['city'] as String? ?? '',
      postalCode: map['postalCode'] as String? ?? map['postal_code'] as String? ?? '',
      province: map['province'] as String? ?? '',
      country: map['country'] as String? ?? 'ES',
      phone: map['phone'] as String?,
      name: map['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'street': street,
        'city': city,
        'postalCode': postalCode,
        'province': province,
        'country': country,
        if (phone != null) 'phone': phone,
        if (name != null) 'name': name,
      };

  String get formatted => '$street, $postalCode $city, $province';
}
