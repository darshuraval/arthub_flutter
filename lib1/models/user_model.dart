import 'package:flutter/material.dart';

enum UserRole { buyer, seller, both }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? bio;
  final UserRole role;
  final String? phoneNumber;
  final String? address;
  final DateTime joinedDate;
  final bool isVerified;
  final List<String> favoriteProducts;
  final List<String> following;
  final List<String> followers;

  // Seller specific fields
  final String? studioName;
  final String? artistBio;
  final List<String>? specializations;
  final bool? isVerifiedSeller;
  final double? rating;
  final int? totalSales;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.bio,
    required this.role,
    this.phoneNumber,
    this.address,
    required this.joinedDate,
    this.isVerified = false,
    this.favoriteProducts = const [],
    this.following = const [],
    this.followers = const [],
    this.studioName,
    this.artistBio,
    this.specializations,
    this.isVerifiedSeller,
    this.rating,
    this.totalSales,
  });

  bool get isSeller => role == UserRole.seller || role == UserRole.both;
  bool get isBuyer => role == UserRole.buyer || role == UserRole.both;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'profileImage': profileImage,
    'bio': bio,
    'role': role.toString(),
    'phoneNumber': phoneNumber,
    'address': address,
    'joinedDate': joinedDate.toIso8601String(),
    'isVerified': isVerified,
    'favoriteProducts': favoriteProducts,
    'following': following,
    'followers': followers,
    'studioName': studioName,
    'artistBio': artistBio,
    'specializations': specializations,
    'isVerifiedSeller': isVerifiedSeller,
    'rating': rating,
    'totalSales': totalSales,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    profileImage: json['profileImage'],
    bio: json['bio'],
    role: UserRole.values.firstWhere(
      (role) => role.toString() == json['role'],
      orElse: () => UserRole.buyer,
    ),
    phoneNumber: json['phoneNumber'],
    address: json['address'],
    joinedDate: DateTime.parse(json['joinedDate']),
    isVerified: json['isVerified'] ?? false,
    favoriteProducts: List<String>.from(json['favoriteProducts'] ?? []),
    following: List<String>.from(json['following'] ?? []),
    followers: List<String>.from(json['followers'] ?? []),
    studioName: json['studioName'],
    artistBio: json['artistBio'],
    specializations: json['specializations'] != null 
      ? List<String>.from(json['specializations'])
      : null,
    isVerifiedSeller: json['isVerifiedSeller'],
    rating: json['rating']?.toDouble(),
    totalSales: json['totalSales'],
  );
} 