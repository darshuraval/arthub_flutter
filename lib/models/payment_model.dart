import 'package:arthub_flutter/models/order_model.dart';

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded
}

enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  bankTransfer,
  upi
}

class PaymentModel {
  final String id;
  final String? orderId;
  final String? userId;
  final double? amount;
  final PaymentStatus? status;
  final PaymentMethod? paymentMethod;
  final DateTime? timestamp;
  final String? transactionId;
  final Map<String, dynamic>? paymentDetails;
  final String? refundReason;
  final double? refundAmount;
  final DateTime? refundDate;
  final String cardType;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentModel({
    required this.id,
    this.orderId,
    this.userId,
    this.amount,
    this.status,
    this.paymentMethod,
    this.timestamp,
    this.transactionId,
    this.paymentDetails,
    this.refundReason,
    this.refundAmount,
    this.refundDate,
    required this.cardType,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardholderName,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String get lastFourDigits => cardNumber.substring(cardNumber.length - 4);

  PaymentModel copyWith({
    String? id,
    String? orderId,
    String? userId,
    double? amount,
    PaymentStatus? status,
    PaymentMethod? paymentMethod,
    DateTime? timestamp,
    String? transactionId,
    Map<String, dynamic>? paymentDetails,
    String? refundReason,
    double? refundAmount,
    DateTime? refundDate,
    String? cardType,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      timestamp: timestamp ?? this.timestamp,
      transactionId: transactionId ?? this.transactionId,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      refundReason: refundReason ?? this.refundReason,
      refundAmount: refundAmount ?? this.refundAmount,
      refundDate: refundDate ?? this.refundDate,
      cardType: cardType ?? this.cardType,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardholderName: cardholderName ?? this.cardholderName,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'userId': userId,
    'amount': amount,
    'status': status?.toString(),
    'paymentMethod': paymentMethod?.toString(),
    'timestamp': timestamp?.toIso8601String(),
    'transactionId': transactionId,
    'paymentDetails': paymentDetails,
    'refundReason': refundReason,
    'refundAmount': refundAmount,
    'refundDate': refundDate?.toIso8601String(),
    'cardType': cardType,
    'cardNumber': cardNumber,
    'expiryDate': expiryDate,
    'cvv': cvv,
    'cardholderName': cardholderName,
    'isDefault': isDefault,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json['id'],
    orderId: json['orderId'],
    userId: json['userId'],
    amount: json['amount']?.toDouble(),
    status: json['status'] != null 
      ? PaymentStatus.values.firstWhere(
          (status) => status.toString() == json['status'],
          orElse: () => PaymentStatus.pending,
        )
      : null,
    paymentMethod: json['paymentMethod'] != null
      ? PaymentMethod.values.firstWhere(
          (method) => method.toString() == json['paymentMethod'],
          orElse: () => PaymentMethod.creditCard,
        )
      : null,
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    transactionId: json['transactionId'],
    paymentDetails: json['paymentDetails'],
    refundReason: json['refundReason'],
    refundAmount: json['refundAmount']?.toDouble(),
    refundDate: json['refundDate'] != null 
      ? DateTime.parse(json['refundDate'])
      : null,
    cardType: json['cardType'],
    cardNumber: json['cardNumber'],
    expiryDate: json['expiryDate'],
    cvv: json['cvv'],
    cardholderName: json['cardholderName'],
    isDefault: json['isDefault'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
} 