import 'package:flutter/material.dart';
import 'package:arthub_flutter/models/address_model.dart';
import 'package:arthub_flutter/models/payment_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  partiallyRefunded
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final AddressModel shippingAddress;
  final AddressModel billingAddress;
  final PaymentModel paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.billingAddress,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem(
                productId: item['productId'] as String,
                quantity: item['quantity'] as int,
                price: item['price'] as double,
              ))
          .toList(),
      totalAmount: json['totalAmount'] as double,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
      ),
      shippingAddress: AddressModel.fromJson(json['shippingAddress']),
      billingAddress: AddressModel.fromJson(json['billingAddress']),
      paymentMethod: PaymentModel.fromJson(json['paymentMethod']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items
          .map((item) => {
                'productId': item.productId,
                'quantity': item.quantity,
                'price': item.price,
              })
          .toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'shippingAddress': shippingAddress.toJson(),
      'billingAddress': billingAddress.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 