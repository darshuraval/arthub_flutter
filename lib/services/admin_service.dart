import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Check if current user is an admin
  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    return userDoc.exists && userDoc.data()?['isAdmin'] == true;
  }

  // Get all users with pagination
  Future<({List<Map<String, dynamic>> data, DocumentSnapshot? lastDoc})> getAllUsers({int limit = 20, DocumentSnapshot? lastDocument}) async {
    Query query = _firestore.collection('users').limit(limit);
    
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    
    final querySnapshot = await query.get();
    final users = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'uid': doc.id,
      };
    }).toList();

    return (
      data: users,
      lastDoc: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
    );
  }

  // Get user details by UID
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'uid': doc.id,
      };
    }
    return null;
  }

  // Update user role
  Future<void> updateUserRole(String uid, bool isAdmin) async {
    await _firestore.collection('users').doc(uid).update({
      'isAdmin': isAdmin,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete user account and data
  Future<void> deleteUserAccount(String uid) async {
    // Delete user from Firebase Auth
    await _authService.deleteUser(uid);
    
    // Delete user data from Firestore
    await _firestore.collection('users').doc(uid).delete();
    
    // Delete user's cart
    await _firestoreService.clearCart(uid);
    
    // Delete user's wishlist
    await _firestoreService.clearWishlist(uid);
    
    // Delete user's orders
    final orders = await _firestoreService.getOrders(uid);
    for (var order in orders) {
      await _firestoreService.deleteOrder(uid, order['orderId']);
    }
  }

  // Get all art products with pagination
  Future<({List<Map<String, dynamic>> data, DocumentSnapshot? lastDoc})> getAllArtProducts({int limit = 20, DocumentSnapshot? lastDocument}) async {
    Query query = _firestore.collection('art_products').limit(limit);
    
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    
    final querySnapshot = await query.get();
    final products = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'id': doc.id,
      };
    }).toList();

    return (
      data: products,
      lastDoc: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
    );
  }

  // Get all orders with pagination
  Future<({List<Map<String, dynamic>> data, DocumentSnapshot? lastDoc})> getAllOrders({int limit = 20, DocumentSnapshot? lastDocument}) async {
    Query query = _firestore.collectionGroup('orders').limit(limit);
    
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    
    final querySnapshot = await query.get();
    final orders = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        ...data,
        'id': doc.id,
        'userId': doc.reference.parent.parent?.id,
      };
    }).toList();

    return (
      data: orders,
      lastDoc: querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
    );
  }

  // Update order status
  Future<void> updateOrderStatus(String userId, String orderId, String status) async {
    await _firestoreService.updateOrderStatus(userId, orderId, status);
  }

  // Get system statistics
  Future<Map<String, dynamic>> getSystemStats() async {
    final usersCount = await _firestore.collection('users').count().get();
    final productsCount = await _firestore.collection('art_products').count().get();
    final ordersCount = await _firestore.collectionGroup('orders').count().get();
    
    return {
      'totalUsers': usersCount.count,
      'totalProducts': productsCount.count,
      'totalOrders': ordersCount.count,
    };
  }

  // Delete art product
  Future<void> deleteArtProduct(String productId) async {
    try {
      await _firestore.collection('art_products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete art product: $e');
    }
  }
} 