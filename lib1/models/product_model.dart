import 'package:flutter/material.dart';

enum ProductStatus { available, sold, reserved }

class ProductModel {
  final String id;
  final String title;
  final String description;
  final String sellerId;
  final String sellerName;
  final List<String> images;
  final double originalPrice;
  final double? discountedPrice;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final ProductStatus status;
  final Map<String, String> details;
  final Map<String, String> additionalDetails;
  final int views;
  final int likes;
  final List<String> likedBy;
  final double? rating;
  final int reviewCount;
  final String? frameDetails;
  final Map<String, dynamic> dimensions;
  final String medium;
  final int? yearCreated;
  final bool isOriginal;
  final int? editionNumber;
  final int? totalEditions;
  final bool hasFrame;
  final bool hasCertificate;
  final String? certificateDetails;
  final List<String>? shippingCountries;
  final Map<String, double>? shippingFees;
  final bool isCustomizable;
  final List<Map<String, dynamic>>? customizationOptions;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sellerId,
    required this.sellerName,
    required this.images,
    required this.originalPrice,
    this.discountedPrice,
    required this.category,
    this.tags = const [],
    required this.createdAt,
    this.status = ProductStatus.available,
    required this.details,
    required this.additionalDetails,
    this.views = 0,
    this.likes = 0,
    this.likedBy = const [],
    this.rating,
    this.reviewCount = 0,
    this.frameDetails,
    required this.dimensions,
    required this.medium,
    this.yearCreated,
    required this.isOriginal,
    this.editionNumber,
    this.totalEditions,
    this.hasFrame = false,
    this.hasCertificate = false,
    this.certificateDetails,
    this.shippingCountries,
    this.shippingFees,
    this.isCustomizable = false,
    this.customizationOptions,
  });

  double get finalPrice => discountedPrice ?? originalPrice;
  
  String get discountPercentage {
    if (discountedPrice == null) return '0%';
    double discount = ((originalPrice - discountedPrice!) / originalPrice) * 100;
    return '${discount.round()}%';
  }

  bool get isDiscounted => discountedPrice != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'sellerId': sellerId,
    'sellerName': sellerName,
    'images': images,
    'originalPrice': originalPrice,
    'discountedPrice': discountedPrice,
    'category': category,
    'tags': tags,
    'createdAt': createdAt.toIso8601String(),
    'status': status.toString(),
    'details': details,
    'additionalDetails': additionalDetails,
    'views': views,
    'likes': likes,
    'likedBy': likedBy,
    'rating': rating,
    'reviewCount': reviewCount,
    'frameDetails': frameDetails,
    'dimensions': dimensions,
    'medium': medium,
    'yearCreated': yearCreated,
    'isOriginal': isOriginal,
    'editionNumber': editionNumber,
    'totalEditions': totalEditions,
    'hasFrame': hasFrame,
    'hasCertificate': hasCertificate,
    'certificateDetails': certificateDetails,
    'shippingCountries': shippingCountries,
    'shippingFees': shippingFees,
    'isCustomizable': isCustomizable,
    'customizationOptions': customizationOptions,
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    sellerId: json['sellerId'],
    sellerName: json['sellerName'],
    images: List<String>.from(json['images']),
    originalPrice: json['originalPrice'].toDouble(),
    discountedPrice: json['discountedPrice']?.toDouble(),
    category: json['category'],
    tags: List<String>.from(json['tags'] ?? []),
    createdAt: DateTime.parse(json['createdAt']),
    status: ProductStatus.values.firstWhere(
      (status) => status.toString() == json['status'],
      orElse: () => ProductStatus.available,
    ),
    details: Map<String, String>.from(json['details']),
    additionalDetails: Map<String, String>.from(json['additionalDetails']),
    views: json['views'] ?? 0,
    likes: json['likes'] ?? 0,
    likedBy: List<String>.from(json['likedBy'] ?? []),
    rating: json['rating']?.toDouble(),
    reviewCount: json['reviewCount'] ?? 0,
    frameDetails: json['frameDetails'],
    dimensions: Map<String, dynamic>.from(json['dimensions']),
    medium: json['medium'],
    yearCreated: json['yearCreated'],
    isOriginal: json['isOriginal'],
    editionNumber: json['editionNumber'],
    totalEditions: json['totalEditions'],
    hasFrame: json['hasFrame'] ?? false,
    hasCertificate: json['hasCertificate'] ?? false,
    certificateDetails: json['certificateDetails'],
    shippingCountries: json['shippingCountries'] != null 
      ? List<String>.from(json['shippingCountries'])
      : null,
    shippingFees: json['shippingFees'] != null 
      ? Map<String, double>.from(json['shippingFees'])
      : null,
    isCustomizable: json['isCustomizable'] ?? false,
    customizationOptions: json['customizationOptions'] != null 
      ? List<Map<String, dynamic>>.from(json['customizationOptions'])
      : null,
  );
} 