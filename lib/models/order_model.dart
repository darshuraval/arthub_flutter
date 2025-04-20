import 'package:flutter/material.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  partiallyRefunded
}

class PaymentModel {
  final String id;
  final String orderId;
  final String userId;
  final double amount;
  final PaymentStatus status;
  final String paymentMethod;
  final DateTime timestamp;
  final String? transactionId;
  final Map<String, dynamic>? paymentDetails;
  final String? refundReason;
  final double? refundAmount;
  final DateTime? refundDate;

  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.timestamp,
    this.transactionId,
    this.paymentDetails,
    this.refundReason,
    this.refundAmount,
    this.refundDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'userId': userId,
    'amount': amount,
    'status': status.toString(),
    'paymentMethod': paymentMethod,
    'timestamp': timestamp.toIso8601String(),
    'transactionId': transactionId,
    'paymentDetails': paymentDetails,
    'refundReason': refundReason,
    'refundAmount': refundAmount,
    'refundDate': refundDate?.toIso8601String(),
  };

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json['id'],
    orderId: json['orderId'],
    userId: json['userId'],
    amount: json['amount'].toDouble(),
    status: PaymentStatus.values.firstWhere(
      (status) => status.toString() == json['status'],
      orElse: () => PaymentStatus.pending,
    ),
    paymentMethod: json['paymentMethod'],
    timestamp: DateTime.parse(json['timestamp']),
    transactionId: json['transactionId'],
    paymentDetails: json['paymentDetails'],
    refundReason: json['refundReason'],
    refundAmount: json['refundAmount']?.toDouble(),
    refundDate: json['refundDate'] != null 
      ? DateTime.parse(json['refundDate'])
      : null,
  );
}

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String productId;
  final String productTitle;
  final String productImage;
  final double amount;
  final OrderStatus status;
  final DateTime orderDate;
  final PaymentModel payment;
  final Map<String, String> shippingAddress;
  final String? trackingNumber;
  final DateTime? estimatedDeliveryDate;
  final DateTime? deliveredDate;
  final String? cancellationReason;
  final Map<String, dynamic>? customizationDetails;
  final String? specialInstructions;
  final bool isGift;
  final String? giftMessage;
  final double? taxAmount;
  final double shippingFee;
  final double? discount;
  final String? promoCode;
  final Map<String, dynamic>? disputeDetails;

  const OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.amount,
    required this.status,
    required this.orderDate,
    required this.payment,
    required this.shippingAddress,
    this.trackingNumber,
    this.estimatedDeliveryDate,
    this.deliveredDate,
    this.cancellationReason,
    this.customizationDetails,
    this.specialInstructions,
    this.isGift = false,
    this.giftMessage,
    this.taxAmount,
    required this.shippingFee,
    this.discount,
    this.promoCode,
    this.disputeDetails,
  });

  double get totalAmount => amount + shippingFee + (taxAmount ?? 0) - (discount ?? 0);

  bool get canCancel => status == OrderStatus.pending || status == OrderStatus.confirmed;
  
  bool get canTrack => status == OrderStatus.shipped && trackingNumber != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'buyerId': buyerId,
    'sellerId': sellerId,
    'productId': productId,
    'productTitle': productTitle,
    'productImage': productImage,
    'amount': amount,
    'status': status.toString(),
    'orderDate': orderDate.toIso8601String(),
    'payment': payment.toJson(),
    'shippingAddress': shippingAddress,
    'trackingNumber': trackingNumber,
    'estimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
    'deliveredDate': deliveredDate?.toIso8601String(),
    'cancellationReason': cancellationReason,
    'customizationDetails': customizationDetails,
    'specialInstructions': specialInstructions,
    'isGift': isGift,
    'giftMessage': giftMessage,
    'taxAmount': taxAmount,
    'shippingFee': shippingFee,
    'discount': discount,
    'promoCode': promoCode,
    'disputeDetails': disputeDetails,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    buyerId: json['buyerId'],
    sellerId: json['sellerId'],
    productId: json['productId'],
    productTitle: json['productTitle'],
    productImage: json['productImage'],
    amount: json['amount'].toDouble(),
    status: OrderStatus.values.firstWhere(
      (status) => status.toString() == json['status'],
      orElse: () => OrderStatus.pending,
    ),
    orderDate: DateTime.parse(json['orderDate']),
    payment: PaymentModel.fromJson(json['payment']),
    shippingAddress: Map<String, String>.from(json['shippingAddress']),
    trackingNumber: json['trackingNumber'],
    estimatedDeliveryDate: json['estimatedDeliveryDate'] != null 
      ? DateTime.parse(json['estimatedDeliveryDate'])
      : null,
    deliveredDate: json['deliveredDate'] != null 
      ? DateTime.parse(json['deliveredDate'])
      : null,
    cancellationReason: json['cancellationReason'],
    customizationDetails: json['customizationDetails'],
    specialInstructions: json['specialInstructions'],
    isGift: json['isGift'] ?? false,
    giftMessage: json['giftMessage'],
    taxAmount: json['taxAmount']?.toDouble(),
    shippingFee: json['shippingFee'].toDouble(),
    discount: json['discount']?.toDouble(),
    promoCode: json['promoCode'],
    disputeDetails: json['disputeDetails'],
  );
} 