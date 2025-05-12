import 'dart:async';

class PaymentService {
  // In-memory storage for payments
  static final Map<String, Map<String, dynamic>> _payments = {};
  
  // Create a new payment
  Future<Map<String, dynamic>> createPayment({
    required String senderId,
    required String receiverId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
    String? paidAt,
    String status = 'pending',
  }) async {
    final now = DateTime.now().toIso8601String();
    final paymentId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final payment = {
      'transactionId': transactionId ?? paymentId,
      'senderId': senderId,
      'receiverId': receiverId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paid_at': paidAt,
      'status': status,
      'created_at': now,
      'updated_at': now,
    };

    _payments[paymentId] = payment;
    return payment;
  }

  // Get all payments
  Future<List<Map<String, dynamic>>> getAllPayments() async {
    return _payments.values.toList();
  }

  // Get payment by transaction ID
  Future<Map<String, dynamic>?> getPaymentByTransactionId(String transactionId) async {
    return _payments.values.firstWhere(
      (payment) => payment['transactionId'] == transactionId,
      orElse: () => null,
    );
  }

  // Get payments by sender ID
  Future<List<Map<String, dynamic>>> getPaymentsBySenderId(String senderId) async {
    return _payments.values.where((payment) => payment['senderId'] == senderId).toList();
  }

  // Get payments by receiver ID
  Future<List<Map<String, dynamic>>> getPaymentsByReceiverId(String receiverId) async {
    return _payments.values.where((payment) => payment['receiverId'] == receiverId).toList();
  }

  // Update payment
  Future<Map<String, dynamic>?> updatePayment({
    required String transactionId,
    double? amount,
    String? paymentMethod,
    String? paidAt,
    String? status,
  }) async {
    final payment = _payments.values.firstWhere(
      (p) => p['transactionId'] == transactionId,
      orElse: () => null,
    );

    if (payment == null) {
      return null;
    }
    
    if (amount != null) payment['amount'] = amount;
    if (paymentMethod != null) payment['paymentMethod'] = paymentMethod;
    if (paidAt != null) payment['paid_at'] = paidAt;
    if (status != null) payment['status'] = status;
    
    payment['updated_at'] = DateTime.now().toIso8601String();
    
    _payments[transactionId] = payment;
    return payment;
  }

  // Delete payment
  Future<bool> deletePayment(String transactionId) async {
    final payment = _payments.values.firstWhere(
      (p) => p['transactionId'] == transactionId,
      orElse: () => null,
    );

    if (payment == null) {
      return false;
    }
    
    _payments.remove(transactionId);
    return true;
  }

  // Search payments
  Future<List<Map<String, dynamic>>> searchPayments(String query) async {
    query = query.toLowerCase();
    return _payments.values.where((payment) {
      return payment['transactionId'].toString().toLowerCase().contains(query) ||
             payment['senderId'].toString().toLowerCase().contains(query) ||
             payment['receiverId'].toString().toLowerCase().contains(query);
    }).toList();
  }

  // Get payments by status
  Future<List<Map<String, dynamic>>> getPaymentsByStatus(String status) async {
    return _payments.values.where((payment) => payment['status'] == status).toList();
  }

  // Get payments by payment method
  Future<List<Map<String, dynamic>>> getPaymentsByPaymentMethod(String paymentMethod) async {
    return _payments.values.where((payment) => payment['paymentMethod'] == paymentMethod).toList();
  }

  // Get payments by date range
  Future<List<Map<String, dynamic>>> getPaymentsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return _payments.values.where((payment) {
      final paymentDate = DateTime.parse(payment['created_at']);
      return paymentDate.isAfter(startDate) && paymentDate.isBefore(endDate);
    }).toList();
  }

  // Update payment status
  Future<Map<String, dynamic>?> updatePaymentStatus(String transactionId, String status) async {
    return updatePayment(transactionId: transactionId, status: status);
  }

  // Mark payment as paid
  Future<Map<String, dynamic>?> markPaymentAsPaid(String transactionId) async {
    return updatePayment(
      transactionId: transactionId,
      status: 'completed',
      paidAt: DateTime.now().toIso8601String(),
    );
  }

  // Get total payments amount
  Future<double> getTotalPaymentsAmount({
    String? senderId,
    String? receiverId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var payments = _payments.values;
    
    if (senderId != null) {
      payments = payments.where((payment) => payment['senderId'] == senderId);
    }
    
    if (receiverId != null) {
      payments = payments.where((payment) => payment['receiverId'] == receiverId);
    }
    
    if (status != null) {
      payments = payments.where((payment) => payment['status'] == status);
    }
    
    if (startDate != null && endDate != null) {
      payments = payments.where((payment) {
        final paymentDate = DateTime.parse(payment['created_at']);
        return paymentDate.isAfter(startDate) && paymentDate.isBefore(endDate);
      });
    }
    
    return payments.fold(0.0, (sum, payment) => sum + (payment['amount'] as double));
  }

  // Get payment statistics
  Future<Map<String, dynamic>> getPaymentStatistics({
    String? senderId,
    String? receiverId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var payments = _payments.values;
    
    if (senderId != null) {
      payments = payments.where((payment) => payment['senderId'] == senderId);
    }
    
    if (receiverId != null) {
      payments = payments.where((payment) => payment['receiverId'] == receiverId);
    }
    
    if (startDate != null && endDate != null) {
      payments = payments.where((payment) {
        final paymentDate = DateTime.parse(payment['created_at']);
        return paymentDate.isAfter(startDate) && paymentDate.isBefore(endDate);
      });
    }

    final totalAmount = payments.fold(0.0, (sum, payment) => sum + (payment['amount'] as double));
    final completedPayments = payments.where((p) => p['status'] == 'completed').length;
    final pendingPayments = payments.where((p) => p['status'] == 'pending').length;
    final failedPayments = payments.where((p) => p['status'] == 'failed').length;

    return {
      'totalAmount': totalAmount,
      'totalTransactions': payments.length,
      'completedTransactions': completedPayments,
      'pendingTransactions': pendingPayments,
      'failedTransactions': failedPayments,
    };
  }
} 

// {
//   'transactionId': String,
//   'senderId': String,
//   'receiverId': String,
//   'amount': double,
//   'paymentMethod': String,
//   'paid_at': String?,
//   'status': String,
//   'created_at': String (ISO8601 timestamp),
//   'updated_at': String (ISO8601 timestamp)
// }

// final paymentService = PaymentService();

// // Create a payment
// await paymentService.createPayment(
//   senderId: 'user123',
//   receiverId: 'store123',
//   amount: 99.99,
//   paymentMethod: 'credit_card'
// );

// // Get all payments
// final payments = await paymentService.getAllPayments();

// // Update a payment
// await paymentService.updatePayment(
//   transactionId: 'txn123',
//   status: 'completed',
//   paidAt: DateTime.now().toIso8601String()
// );

// // Mark payment as paid
// await paymentService.markPaymentAsPaid('txn123');

// // Get payment statistics
// final stats = await paymentService.getPaymentStatistics(
//   receiverId: 'store123',
//   startDate: DateTime(2024, 1, 1),
//   endDate: DateTime(2024, 12, 31)
// );

// // Delete a payment
// await paymentService.deletePayment('txn123');