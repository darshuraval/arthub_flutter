import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all users from Firestore only
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      final firestoreUsers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          ...data,
          'source': 'firestore',
        };
      }).toList();

      return firestoreUsers;
    } catch (e) {
      print('Error getting users: $e');
      throw Exception('Failed to get users: $e');
    }
  }

  // Create a new user in Firestore only
  Future<Map<String, dynamic>> createUser({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    bool isEmailVerified = false,
    String status = 'active',
  }) async {
    try {
      final userData = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'isEmailVerified': isEmailVerified,
        'status': status,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      };

      // Add new document with auto-generated ID
      final docRef = await _firestore.collection('users').add(userData);

      return {
        'uid': docRef.id,
        ...userData,
        'source': 'firestore',
      };
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by email from Firestore only
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      return {
        'uid': doc.id,
        ...doc.data(),
        'source': 'firestore',
      };
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Update user by email in Firestore only
  Future<Map<String, dynamic>?> updateUser({
    required String email,
    String? firstName,
    String? lastName,
    String? role,
    bool? isEmailVerified,
    String? status,
  }) async {
    try {
      final user = await getUserByEmail(email);
      if (user == null) return null;

      final uid = user['uid'];
      final updates = <String, dynamic>{
        'updated_at': FieldValue.serverTimestamp(),
      };

      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (role != null) updates['role'] = role;
      if (isEmailVerified != null) updates['isEmailVerified'] = isEmailVerified;
      if (status != null) updates['status'] = status;

      await _firestore.collection('users').doc(uid).update(updates);

      final updatedUser = await getUserByEmail(email);
      return updatedUser;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user by email from Firestore only
  Future<bool> deleteUser(String email) async {
    try {
      final user = await getUserByEmail(email);
      if (user == null) return false;

      final uid = user['uid'];
      await _firestore.collection('users').doc(uid).delete();

      return true;
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Search users in Firestore only
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      query = query.toLowerCase();
      final allUsers = await getAllUsers();

      final filteredUsers = allUsers.where((user) {
        return user['email'].toString().toLowerCase().contains(query) ||
            (user['firstName']?.toString().toLowerCase().contains(query) ?? false) ||
            (user['lastName']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();

      return filteredUsers;
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  // Get users by role from Firestore only
  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          ...data,
          'source': 'firestore',
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get users by role: $e');
    }
  }

  // Get users by status from Firestore only
  Future<List<Map<String, dynamic>>> getUsersByStatus(String status) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('status', isEqualTo: status)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          ...data,
          'source': 'firestore',
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get users by status: $e');
    }
  }

  // Update user status shortcut
  Future<Map<String, dynamic>?> updateUserStatus(String email, String status) async {
    return updateUser(email: email, status: status);
  }

  // Update email verification shortcut
  Future<Map<String, dynamic>?> updateEmailVerification(String email, bool isVerified) async {
    return updateUser(email: email, isEmailVerified: isVerified);
  }
}
