import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- USERS ----------------
  /// Creates a new user document in the 'users' collection.
  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data);
  }

  /// Gets a user document by UID from the 'users' collection.
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  /// Updates a user document in the 'users' collection.
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  /// Deletes a user document from the 'users' collection.
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  /// Gets all users from the 'users' collection.
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // ---------------- ART PRODUCTS ----------------
  /// Creates a new art product document in the 'art_products' collection.
  Future<void> createArtProduct(String productId, Map<String, dynamic> data) async {
    await _firestore.collection('art_products').doc(productId).set(data);
  }

  /// Gets an art product by ID.
  Future<DocumentSnapshot<Map<String, dynamic>>> getArtProductById(String productId) async {
    return await _firestore.collection('art_products').doc(productId).get();
  }

  /// Updates an art product document.
  Future<void> updateArtProduct(String productId, Map<String, dynamic> data) async {
    await _firestore.collection('art_products').doc(productId).update(data);
  }

  /// Deletes an art product document.
  Future<void> deleteArtProduct(String productId) async {
    await _firestore.collection('art_products').doc(productId).delete();
  }

  /// Gets all art products.
  Future<List<Map<String, dynamic>>> getAllArtProducts() async {
    final querySnapshot = await _firestore.collection('art_products').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // ---------------- PAYMENTS ----------------
  /// Creates a new payment document in the 'payments' collection.
  Future<void> createPayment(String paymentId, Map<String, dynamic> data) async {
    await _firestore.collection('payments').doc(paymentId).set(data);
  }

  /// Gets a payment by ID.
  Future<DocumentSnapshot<Map<String, dynamic>>> getPaymentById(String paymentId) async {
    return await _firestore.collection('payments').doc(paymentId).get();
  }

  /// Updates a payment document.
  Future<void> updatePayment(String paymentId, Map<String, dynamic> data) async {
    await _firestore.collection('payments').doc(paymentId).update(data);
  }

  /// Deletes a payment document.
  Future<void> deletePayment(String paymentId) async {
    await _firestore.collection('payments').doc(paymentId).delete();
  }

  /// Gets all payments.
  Future<List<Map<String, dynamic>>> getAllPayments() async {
    final querySnapshot = await _firestore.collection('payments').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // ---------------- CART ----------------
  /// Adds/updates a cart item for a user in the 'cart' collection (by userId).
  Future<void> setCartItem(String userId, String itemId, Map<String, dynamic> data) async {
    await _firestore.collection('cart').doc(userId).collection('items').doc(itemId).set(data);
  }

  /// Gets all cart items for a user.
  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final querySnapshot = await _firestore.collection('cart').doc(userId).collection('items').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Removes a cart item for a user.
  Future<void> removeCartItem(String userId, String itemId) async {
    await _firestore.collection('cart').doc(userId).collection('items').doc(itemId).delete();
  }

  /// Clears all cart items for a user.
  Future<void> clearCart(String userId) async {
    final batch = _firestore.batch();
    final items = await _firestore.collection('cart').doc(userId).collection('items').get();
    for (var doc in items.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ---------------- WISHLIST ----------------
  /// Adds/updates a wishlist item for a user in the 'wishlist' collection (by userId).
  Future<void> setWishlistItem(String userId, String itemId, Map<String, dynamic> data) async {
    await _firestore.collection('wishlist').doc(userId).collection('items').doc(itemId).set(data);
  }

  /// Gets all wishlist items for a user.
  Future<List<Map<String, dynamic>>> getWishlistItems(String userId) async {
    final querySnapshot = await _firestore.collection('wishlist').doc(userId).collection('items').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Removes a wishlist item for a user.
  Future<void> removeWishlistItem(String userId, String itemId) async {
    await _firestore.collection('wishlist').doc(userId).collection('items').doc(itemId).delete();
  }

  /// Clears all wishlist items for a user.
  Future<void> clearWishlist(String userId) async {
    final batch = _firestore.batch();
    final items = await _firestore.collection('wishlist').doc(userId).collection('items').get();
    for (var doc in items.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ---------------- ORDER HISTORY ----------------
  /// Adds a new order to the user's order history in the 'order_history' collection (by userId).
  Future<void> addOrder(String userId, String orderId, Map<String, dynamic> data) async {
    await _firestore.collection('order_history').doc(userId).collection('orders').doc(orderId).set(data);
  }

  /// Gets all orders for a user.
  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    final querySnapshot = await _firestore.collection('order_history').doc(userId).collection('orders').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Gets a specific order for a user.
  Future<DocumentSnapshot<Map<String, dynamic>>> getOrderById(String userId, String orderId) async {
    return await _firestore.collection('order_history').doc(userId).collection('orders').doc(orderId).get();
  }

  /// Deletes an order from a user's order history.
  Future<void> deleteOrder(String userId, String orderId) async {
    await _firestore.collection('order_history').doc(userId).collection('orders').doc(orderId).delete();
  }

  /// Updates the status of an order in the 'order_history' collection.
  Future<void> updateOrderStatus(String userId, String orderId, String status) async {
    await _firestore
        .collection('order_history')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }
} 