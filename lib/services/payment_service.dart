import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  // Create a new payment
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      'paymentId': paymentId,
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
    await _firestore.collection('payments').doc(paymentId).set(payment);
    return payment;
  }

  // Get all payments
  Future<List<Map<String, dynamic>>> getAllPayments() async {
    final querySnapshot = await _firestore.collection('payments').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get payment by transaction ID
  Future<Map<String, dynamic>?> getPaymentByTransactionId(String transactionId) async {
    final querySnapshot = await _firestore.collection('payments').where('transactionId', isEqualTo: transactionId).limit(1).get();
    if (querySnapshot.docs.isEmpty) return null;
    final data = querySnapshot.docs.first.data();
    data['paymentId'] = querySnapshot.docs.first.id;
    return data;
  }

  // Get payments by sender ID
  Future<List<Map<String, dynamic>>> getPaymentsBySenderId(String senderId) async {
    final querySnapshot = await _firestore.collection('payments').where('senderId', isEqualTo: senderId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get payments by receiver ID
  Future<List<Map<String, dynamic>>> getPaymentsByReceiverId(String receiverId) async {
    final querySnapshot = await _firestore.collection('payments').where('receiverId', isEqualTo: receiverId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update payment
  Future<Map<String, dynamic>?> updatePayment({
    required String transactionId,
    double? amount,
    String? paymentMethod,
    String? paidAt,
    String? status,
  }) async {
    final payment = await getPaymentByTransactionId(transactionId);

    if (payment == null) {
      return null;
    }
    final paymentId = payment['paymentId'];
    if (amount != null) payment['amount'] = amount;
    if (paymentMethod != null) payment['paymentMethod'] = paymentMethod;
    if (paidAt != null) payment['paid_at'] = paidAt;
    if (status != null) payment['status'] = status;
    payment['updated_at'] = DateTime.now().toIso8601String();
    await _firestore.collection('payments').doc(paymentId).update(payment);
    return payment;
  }

  // Delete payment
  Future<bool> deletePayment(String transactionId) async {
    final payment = await getPaymentByTransactionId(transactionId);

    if (payment == null) {
      return false;
    }
    final paymentId = payment['paymentId'];
    await _firestore.collection('payments').doc(paymentId).delete();
    return true;
  }

  // Search payments
  Future<List<Map<String, dynamic>>> searchPayments(String query) async {
    query = query.toLowerCase();
    final querySnapshot = await _firestore.collection('payments').where('transactionId', isEqualTo: query).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get payments by status
  Future<List<Map<String, dynamic>>> getPaymentsByStatus(String status) async {
    final querySnapshot = await _firestore.collection('payments').where('status', isEqualTo: status).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get payments by payment method
  Future<List<Map<String, dynamic>>> getPaymentsByPaymentMethod(String paymentMethod) async {
    final querySnapshot = await _firestore.collection('payments').where('paymentMethod', isEqualTo: paymentMethod).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get payments by date range
  Future<List<Map<String, dynamic>>> getPaymentsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final querySnapshot = await _firestore.collection('payments').where('created_at', isGreaterThanOrEqualTo: startDate.toIso8601String(), isLessThanOrEqualTo: endDate.toIso8601String()).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
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
    Query query = _firestore.collection('payments');
    if (senderId != null) {
      query = query.where('senderId', isEqualTo: senderId);
    }
    if (receiverId != null) {
      query = query.where('receiverId', isEqualTo: receiverId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (startDate != null && endDate != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: startDate.toIso8601String(), isLessThanOrEqualTo: endDate.toIso8601String());
    }
    final querySnapshot = await query.get();
    final payments = querySnapshot.docs.map((doc) => doc.data()).toList();
    double total = 0.0;
    for (final p in payments) {
      final payment = p as Map<String, dynamic>;
      final amount = payment['amount'];
      if (amount is int) {
        total += amount.toDouble();
      } else if (amount is double) {
        total += amount;
      }
    }
    return total;
  }

  // Get payment statistics
  Future<Map<String, dynamic>> getPaymentStatistics({
    String? senderId,
    String? receiverId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query query = _firestore.collection('payments');
    if (senderId != null) {
      query = query.where('senderId', isEqualTo: senderId);
    }
    if (receiverId != null) {
      query = query.where('receiverId', isEqualTo: receiverId);
    }
    if (startDate != null && endDate != null) {
      query = query.where('created_at', isGreaterThanOrEqualTo: startDate.toIso8601String(), isLessThanOrEqualTo: endDate.toIso8601String());
    }
    final querySnapshot = await query.get();
    final payments = querySnapshot.docs.map((doc) => doc.data()).toList();
    double totalAmount = 0.0;
    int completedPayments = 0;
    int pendingPayments = 0;
    int failedPayments = 0;
    for (final p in payments) {
      final payment = p as Map<String, dynamic>;
      final amount = payment['amount'];
      if (amount is int) {
        totalAmount += amount.toDouble();
      } else if (amount is double) {
        totalAmount += amount;
      }
      final status = payment['status'];
      if (status == 'completed') completedPayments++;
      if (status == 'pending') pendingPayments++;
      if (status == 'failed') failedPayments++;
    }
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