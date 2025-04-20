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
  final String? errorMessage;
  final String cardType;
  final String cardNumber;
  final String expiryDate;
  final String? cvv;
  final String cardholderName;
  final bool isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentModel({
    required this.id,
    this.orderId,
    this.userId,
    this.amount,
    this.status,
    this.paymentMethod,
    this.timestamp,
    this.transactionId,
    this.paymentDetails,
    this.errorMessage,
    required this.cardType,
    required this.cardNumber,
    required this.expiryDate,
    this.cvv,
    required this.cardholderName,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  String get lastFourDigits => cardNumber.substring(cardNumber.length - 4);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'status': status?.toString(),
      'paymentMethod': paymentMethod?.toString(),
      'timestamp': timestamp?.toIso8601String(),
      'transactionId': transactionId,
      'paymentDetails': paymentDetails,
      'errorMessage': errorMessage,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardholderName': cardholderName,
      'isDefault': isDefault,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      orderId: json['orderId'],
      userId: json['userId'],
      amount: json['amount']?.toDouble(),
      status: json['status'] != null
          ? PaymentStatus.values.firstWhere(
              (e) => e.toString() == json['status'],
              orElse: () => PaymentStatus.pending,
            )
          : null,
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.toString() == json['paymentMethod'],
              orElse: () => PaymentMethod.creditCard,
            )
          : null,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      transactionId: json['transactionId'],
      paymentDetails: json['paymentDetails'],
      errorMessage: json['errorMessage'],
      cardType: json['cardType'] as String,
      cardNumber: json['cardNumber'] as String,
      expiryDate: json['expiryDate'] as String,
      cvv: json['cvv'] as String?,
      cardholderName: json['cardholderName'] as String,
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

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
    String? errorMessage,
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
      errorMessage: errorMessage ?? this.errorMessage,
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
} 