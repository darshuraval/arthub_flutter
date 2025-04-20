class AddressModel {
  final String id;
  final String userId;
  final String fullName;
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phoneNumber;
  final String addressType;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phoneNumber,
    required this.addressType,
    required this.isDefault,
    required this.createdAt,
    this.updatedAt,
  });

  AddressModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phoneNumber,
    String? addressType,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 