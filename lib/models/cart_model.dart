import 'package:arthub_flutter/models/product_model.dart';

class CartItem {
  final String id;
  final ProductModel product;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice => product.discountedPrice * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  CartItem copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class CartModel {
  final String userId;
  final List<CartItem> items;
  final DateTime lastUpdated;

  CartModel({
    required this.userId,
    required this.items,
    required this.lastUpdated,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get shippingFee => 10.0; // Fixed shipping fee for now
  double get tax => subtotal * 0.1; // 10% tax
  double get total => subtotal + shippingFee + tax;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  CartModel copyWith({
    String? userId,
    List<CartItem>? items,
    DateTime? lastUpdated,
  }) {
    return CartModel(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
} 