import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  // In-memory storage for orders
  static final Map<String, Map<String, dynamic>> _orders = {};
  
  // Create a new order
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder({
    required String productId,
    required double amount,
    required String buyerId,
    required String sellerId,
    required String storeId,
    required String paymentMethod,
    required String transactionId,
    double? discount,
    String? addressId,
    String status = 'pending',
    String? couponId,
  }) async {
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final orderData = {
      'orderId': orderId,
      'productId': productId,
      'amount': amount,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'storeId': storeId,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'discount': discount ?? 0.0,
      'addressId': addressId,
      'status': status,
      'couponId': couponId,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    await _firestore.collection('orders').doc(orderId).set(orderData);
  }

  // Get all orders
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final querySnapshot = await _firestore.collection('orders').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get order by ID
  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    return doc.exists ? doc.data() : null;
  }

  // Get orders by buyer ID
  Future<List<Map<String, dynamic>>> getOrdersByBuyerId(String buyerId) async {
    final querySnapshot = await _firestore.collection('orders').where('buyerId', isEqualTo: buyerId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get orders by seller ID
  Future<List<Map<String, dynamic>>> getOrdersBySellerId(String sellerId) async {
    final querySnapshot = await _firestore.collection('orders').where('sellerId', isEqualTo: sellerId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get orders by transaction ID
  Future<List<Map<String, dynamic>>> getOrdersByTransactionId(String transactionId) async {
    final querySnapshot = await _firestore.collection('orders').where('transactionId', isEqualTo: transactionId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get orders by store ID
  Future<List<Map<String, dynamic>>> getOrdersByStoreId(String storeId) async {
    final querySnapshot = await _firestore.collection('orders').where('storeId', isEqualTo: storeId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update order
  Future<Map<String, dynamic>?> updateOrder({
    required String orderId,
    String? productId,
    double? amount,
    String? buyerId,
    String? sellerId,
    String? storeId,
    String? paymentMethod,
    String? transactionId,
    double? discount,
    String? paidAt,
    String? addressId,
    String? status,
  }) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) return null;
    final order = doc.data()!;
    if (productId != null) order['productId'] = productId;
    if (amount != null) order['amount'] = amount;
    if (buyerId != null) order['buyerId'] = buyerId;
    if (sellerId != null) order['sellerId'] = sellerId;
    if (storeId != null) order['storeId'] = storeId;
    if (paymentMethod != null) order['paymentMethod'] = paymentMethod;
    if (transactionId != null) order['transactionId'] = transactionId;
    if (discount != null) order['discount'] = discount;
    if (paidAt != null) order['paid_at'] = paidAt;
    if (addressId != null) order['addressId'] = addressId;
    if (status != null) order['status'] = status;
    order['updated_at'] = DateTime.now().toIso8601String();
    await doc.reference.update(order);
    return order;
  }

  // Delete order
  Future<bool> deleteOrder(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) return false;
    await doc.reference.delete();
    return true;
  }

  // Search orders
  Future<List<Map<String, dynamic>>> searchOrders(String query) async {
    query = query.toLowerCase();
    final querySnapshot = await _firestore.collection('orders').where('orderId', isEqualTo: query).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get orders by status
  Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    final querySnapshot = await _firestore.collection('orders').where('status', isEqualTo: status).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get orders by payment method
  Future<List<Map<String, dynamic>>> getOrdersByPaymentMethod(String paymentMethod) async {
    final querySnapshot = await _firestore.collection('orders').where('paymentMethod', isEqualTo: paymentMethod).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get orders by date range
  Future<List<Map<String, dynamic>>> getOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final querySnapshot = await _firestore.collection('orders').where('created_at', isGreaterThanOrEqualTo: startDate.toIso8601String()).where('created_at', isLessThanOrEqualTo: endDate.toIso8601String()).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update order status
  Future<Map<String, dynamic>?> updateOrderStatus(String orderId, String status) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) return null;
    final order = doc.data()!;
    order['status'] = status;
    order['updated_at'] = DateTime.now().toIso8601String();
    await doc.reference.update(order);
    return order;
  }

  // Update payment details
  Future<Map<String, dynamic>?> updatePaymentDetails({
    required String orderId,
    required String transactionId,
    required String paymentMethod,
    required String paidAt,
  }) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (!doc.exists) return null;
    final order = doc.data()!;
    order['transactionId'] = transactionId;
    order['paymentMethod'] = paymentMethod;
    order['paid_at'] = paidAt;
    order['status'] = 'paid';
    order['updated_at'] = DateTime.now().toIso8601String();
    await doc.reference.update(order);
    return order;
  }

  // Get total sales amount
  Future<double> getTotalSalesAmount({
    String? storeId,
    String? sellerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final querySnapshot = await _firestore.collection('orders').get();
    var filtered = querySnapshot.docs;
    if (storeId != null) {
      filtered = filtered.where((order) => order.data()['storeId'] == storeId).toList();
    }
    if (sellerId != null) {
      filtered = filtered.where((order) => order.data()['sellerId'] == sellerId).toList();
    }
    if (startDate != null && endDate != null) {
      filtered = filtered.where((order) {
        final orderDate = DateTime.parse(order.data()['created_at']);
        return orderDate.isAfter(startDate) && orderDate.isBefore(endDate);
      }).toList();
    }
    final amounts = filtered.map((order) {
  final value = order.data()['amount'];
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return 0.0;
}).toList();
double total = 0.0;
for (final amt in amounts) {
  total += amt;
}
return total;
  }

  // Get latest order ID
  Future<String?> getLatestOrderId() async {
    final querySnapshot = await _firestore.collection('orders').orderBy('created_at', descending: true).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }
} 

// {
//   'orderId': String,
//   'transactionId': String?,
//   'productId': String,
//   'amount': double,
//   'discount': double?,
//   'buyerId': String,
//   'sellerId': String,
//   'storeId': String,
//   'paymentMethod': String,
//   'addressId': String,
//   'paid_at': String?,
//   'status': String,
//   'couponId': String?,
//   'couponCode': String?,
//   'couponType': String?,
//   'userId': String?,
//   'created_at': String (ISO8601 timestamp),
//   'updated_at': String (ISO8601 timestamp)
// }

// final orderService = OrderService();

// // Create an order
// await orderService.createOrder(
//   productId: 'product123',
//   amount: 99.99,
//   buyerId: 'buyer123',
//   sellerId: 'seller123',
//   storeId: 'store123',
//   paymentMethod: 'credit_card',
//   addressId: 'address123',
//   discount: 10.0
// );

// // Get all orders
// final orders = await orderService.getAllOrders();

// // Update an order
// await orderService.updateOrder(
//   orderId: 'order123',
//   status: 'shipped',
//   addressId: 'address123',
//   paidAt: DateTime.now().toIso8601String()
// );

// // Update payment details
// await orderService.updatePaymentDetails(
//   orderId: 'order123',
//   transactionId: 'txn123',
//   paymentMethod: 'credit_card',
//   paidAt: DateTime.now().toIso8601String()
// );

// // Get total sales
// final totalSales = await orderService.getTotalSalesAmount(
//   storeId: 'store123',
//   startDate: DateTime(2024, 1, 1),
//   endDate: DateTime(2024, 12, 31)
// );

// // Delete an order
// await orderService.deleteOrder('order123');
// 