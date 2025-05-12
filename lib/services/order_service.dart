import 'dart:async';

class OrderService {
  // In-memory storage for orders
  static final Map<String, Map<String, dynamic>> _orders = {};
  
  // Create a new order
  Future<Map<String, dynamic>> createOrder({
    required String productId,
    required double amount,
    required String buyerId,
    required String sellerId,
    required String storeId,
    required String paymentMethod,
    String? transactionId,
    double? discount,
    String? paidAt,
    String status = 'pending',
  }) async {
    final now = DateTime.now().toIso8601String();
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final order = {
      'orderId': orderId,
      'transactionId': transactionId,
      'productId': productId,
      'amount': amount,
      'discount': discount,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'storeId': storeId,
      'paymentMethod': paymentMethod,
      'paid_at': paidAt,
      'status': status,
      'created_at': now,
      'updated_at': now,
    };

    _orders[orderId] = order;
    return order;
  }

  // Get all orders
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    return _orders.values.toList();
  }

  // Get order by ID
  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    return _orders[orderId];
  }

  // Get orders by buyer ID
  Future<List<Map<String, dynamic>>> getOrdersByBuyerId(String buyerId) async {
    return _orders.values.where((order) => order['buyerId'] == buyerId).toList();
  }

  // Get orders by seller ID
  Future<List<Map<String, dynamic>>> getOrdersBySellerId(String sellerId) async {
    return _orders.values.where((order) => order['sellerId'] == sellerId).toList();
  }

  // Get orders by store ID
  Future<List<Map<String, dynamic>>> getOrdersByStoreId(String storeId) async {
    return _orders.values.where((order) => order['storeId'] == storeId).toList();
  }

  // Update order
  Future<Map<String, dynamic>?> updateOrder({
    required String orderId,
    String? transactionId,
    double? amount,
    double? discount,
    String? paymentMethod,
    String? paidAt,
    String? status,
  }) async {
    if (!_orders.containsKey(orderId)) {
      return null;
    }

    final order = _orders[orderId]!;
    
    if (transactionId != null) order['transactionId'] = transactionId;
    if (amount != null) order['amount'] = amount;
    if (discount != null) order['discount'] = discount;
    if (paymentMethod != null) order['paymentMethod'] = paymentMethod;
    if (paidAt != null) order['paid_at'] = paidAt;
    if (status != null) order['status'] = status;
    
    order['updated_at'] = DateTime.now().toIso8601String();
    
    _orders[orderId] = order;
    return order;
  }

  // Delete order
  Future<bool> deleteOrder(String orderId) async {
    if (!_orders.containsKey(orderId)) {
      return false;
    }
    
    _orders.remove(orderId);
    return true;
  }

  // Search orders
  Future<List<Map<String, dynamic>>> searchOrders(String query) async {
    query = query.toLowerCase();
    return _orders.values.where((order) {
      return order['orderId'].toString().toLowerCase().contains(query) ||
             order['transactionId']?.toString().toLowerCase().contains(query) ?? false;
    }).toList();
  }

  // Get orders by status
  Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    return _orders.values.where((order) => order['status'] == status).toList();
  }

  // Get orders by payment method
  Future<List<Map<String, dynamic>>> getOrdersByPaymentMethod(String paymentMethod) async {
    return _orders.values.where((order) => order['paymentMethod'] == paymentMethod).toList();
  }

  // Get orders by date range
  Future<List<Map<String, dynamic>>> getOrdersByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return _orders.values.where((order) {
      final orderDate = DateTime.parse(order['created_at']);
      return orderDate.isAfter(startDate) && orderDate.isBefore(endDate);
    }).toList();
  }

  // Update order status
  Future<Map<String, dynamic>?> updateOrderStatus(String orderId, String status) async {
    return updateOrder(orderId: orderId, status: status);
  }

  // Update payment details
  Future<Map<String, dynamic>?> updatePaymentDetails({
    required String orderId,
    required String transactionId,
    required String paymentMethod,
    required String paidAt,
  }) async {
    return updateOrder(
      orderId: orderId,
      transactionId: transactionId,
      paymentMethod: paymentMethod,
      paidAt: paidAt,
      status: 'paid',
    );
  }

  // Get total sales amount
  Future<double> getTotalSalesAmount({
    String? storeId,
    String? sellerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var orders = _orders.values;
    
    if (storeId != null) {
      orders = orders.where((order) => order['storeId'] == storeId);
    }
    
    if (sellerId != null) {
      orders = orders.where((order) => order['sellerId'] == sellerId);
    }
    
    if (startDate != null && endDate != null) {
      orders = orders.where((order) {
        final orderDate = DateTime.parse(order['created_at']);
        return orderDate.isAfter(startDate) && orderDate.isBefore(endDate);
      });
    }
    
    return orders.fold(0.0, (sum, order) => sum + (order['amount'] as double));
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
//   'paid_at': String?,
//   'status': String,
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
//   discount: 10.0
// );

// // Get all orders
// final orders = await orderService.getAllOrders();

// // Update an order
// await orderService.updateOrder(
//   orderId: 'order123',
//   status: 'shipped',
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