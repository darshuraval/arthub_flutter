class AddressModel {
  final String id;
  final String userId;
  final String fullName;
  final String streetAddress;
  final String apartment;
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
    required this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phoneNumber,
    required this.addressType,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  AddressModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? streetAddress,
    String? apartment,
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
      apartment: apartment ?? this.apartment,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'streetAddress': streetAddress,
      'apartment': apartment,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'phoneNumber': phoneNumber,
      'addressType': addressType,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      userId: json['userId'],
      fullName: json['fullName'],
      streetAddress: json['streetAddress'],
      apartment: json['apartment'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      phoneNumber: json['phoneNumber'],
      addressType: json['addressType'],
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
} 