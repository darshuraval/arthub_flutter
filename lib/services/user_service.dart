import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all users from both Auth and Firestore
  Future<({List<Map<String, dynamic>> authUsers, List<Map<String, dynamic>> firestoreUsers})> getAllUsers() async {
    try {
      // Get Auth users from Firestore
      final authUsersSnapshot = await _firestore
          .collection('auth_users')
          .get();
      
      final authUsers = authUsersSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          ...data,
          'source': 'auth',
        };
      }).toList();

      // Get Firestore users
      final querySnapshot = await _firestore.collection('users').get();
      final firestoreUsers = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          ...data,
          'source': 'firestore',
        };
      }).toList();

      return (
        authUsers: authUsers,
        firestoreUsers: firestoreUsers,
      );
    } catch (e) {
      print('Error getting users: $e'); // Add logging
      throw Exception('Failed to get users: $e');
    }
  }

  // Create a new user
  Future<Map<String, dynamic>> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    bool isEmailVerified = false,
    String status = 'active',
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;

      // Create user document in Firestore
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

      // Store in both collections
      await Future.wait([
        _firestore.collection('users').doc(user.uid).set(userData),
        _firestore.collection('auth_users').doc(user.uid).set({
          'email': email,
          'isEmailVerified': isEmailVerified,
          'created_at': FieldValue.serverTimestamp(),
          'lastSignIn': FieldValue.serverTimestamp(),
        }),
      ]);

      return {
        'uid': user.uid,
        ...userData,
        'source': 'both',
      };
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by email
  Future<({Map<String, dynamic>? authUser, Map<String, dynamic>? firestoreUser})> getUserByEmail(String email) async {
    try {
      // Get Auth user from Firestore
      final authQuerySnapshot = await _firestore
          .collection('auth_users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      Map<String, dynamic>? authUser;
      if (authQuerySnapshot.docs.isNotEmpty) {
        final doc = authQuerySnapshot.docs.first;
        authUser = {
          'uid': doc.id,
          ...doc.data(),
          'source': 'auth',
        };
      }

      // Get Firestore user
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      Map<String, dynamic>? firestoreUser;
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        firestoreUser = {
          'uid': doc.id,
          ...doc.data(),
          'source': 'firestore',
        };
      }

      return (
        authUser: authUser,
        firestoreUser: firestoreUser,
      );
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Update user
  Future<Map<String, dynamic>?> updateUser({
    required String email,
    String? firstName,
    String? lastName,
    String? role,
    bool? isEmailVerified,
    String? status,
    String? password,
  }) async {
    try {
      final userData = await getUserByEmail(email);
      if (userData.firestoreUser == null) return null;

      final uid = userData.firestoreUser!['uid'];
      final updates = <String, dynamic>{
        'updated_at': FieldValue.serverTimestamp(),
      };

      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (role != null) updates['role'] = role;
      if (isEmailVerified != null) updates['isEmailVerified'] = isEmailVerified;
      if (status != null) updates['status'] = status;

      // Update both collections
      await Future.wait([
        _firestore.collection('users').doc(uid).update(updates),
        _firestore.collection('auth_users').doc(uid).update({
          'isEmailVerified': isEmailVerified,
          'updated_at': FieldValue.serverTimestamp(),
        }),
      ]);

      // Update password if provided
      if (password != null && userData.authUser != null) {
        final user = await _auth.fetchSignInMethodsForEmail(email);
        if (user.isNotEmpty) {
          await _auth.currentUser?.updatePassword(password);
        }
      }

      final updatedUser = await getUserByEmail(email);
      return updatedUser.firestoreUser;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<bool> deleteUser(String email) async {
    try {
      final userData = await getUserByEmail(email);
      if (userData.firestoreUser == null) return false;

      final uid = userData.firestoreUser!['uid'];
      
      // Delete from both collections
      await Future.wait([
        _firestore.collection('users').doc(uid).delete(),
        _firestore.collection('auth_users').doc(uid).delete(),
      ]);
      
      // Delete from Auth if exists
      if (userData.authUser != null) {
        final user = await _auth.fetchSignInMethodsForEmail(email);
        if (user.isNotEmpty) {
          await _auth.currentUser?.delete();
        }
      }

      return true;
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Search users
  Future<({List<Map<String, dynamic>> authUsers, List<Map<String, dynamic>> firestoreUsers})> searchUsers(String query) async {
    try {
      query = query.toLowerCase();
      final allUsers = await getAllUsers();
      
      final filteredAuthUsers = allUsers.authUsers.where((user) {
        return user['email'].toString().toLowerCase().contains(query);
      }).toList();

      final filteredFirestoreUsers = allUsers.firestoreUsers.where((user) {
        return user['email'].toString().toLowerCase().contains(query) ||
               user['firstName']?.toString().toLowerCase().contains(query) == true ||
               user['lastName']?.toString().toLowerCase().contains(query) == true;
      }).toList();

      return (
        authUsers: filteredAuthUsers,
        firestoreUsers: filteredFirestoreUsers,
      );
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  // Get users by role
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

  // Get users by status
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

  // Update user status
  Future<Map<String, dynamic>?> updateUserStatus(String email, String status) async {
    return updateUser(email: email, status: status);
  }

  // Update email verification status
  Future<Map<String, dynamic>?> updateEmailVerification(String email, bool isVerified) async {
    return updateUser(email: email, isEmailVerified: isVerified);
  }
}



// {
//   'email': String,
//   'password': String,
//   'firstName': String,
//   'lastName': String,
//   'role': String,
//   'isEmailVerified': bool,
//   'status': String,
//   'created_at': String (ISO8601 timestamp),
//   'updated_at': String (ISO8601 timestamp)
// }

// final userService = UserService();

// // Create a user
// await userService.createUser(
//   email: 'user@example.com',
//   password: 'password123',
//   firstName: 'John',
//   lastName: 'Doe',
//   role: 'admin'
// );

// // Get all users
// final users = await userService.getAllUsers();

// // Update a user
// await userService.updateUser(
//   email: 'user@example.com',
//   firstName: 'Johnny',
//   status: 'inactive'
// );

// // Delete a user
// await userService.deleteUser('user@example.com');