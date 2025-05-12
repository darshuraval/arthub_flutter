import 'dart:async';

class UserService {
  // In-memory storage for users
  static final Map<String, Map<String, dynamic>> _users = {};
  
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
    final now = DateTime.now().toIso8601String();
    
    final user = {
      'email': email,
      'password': password, // In a real app, this should be hashed
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'status': status,
      'created_at': now,
      'updated_at': now,
    };

    _users[email] = user;
    return user;
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return _users.values.toList();
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    return _users[email];
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
    if (!_users.containsKey(email)) {
      return null;
    }

    final user = _users[email]!;
    
    if (firstName != null) user['firstName'] = firstName;
    if (lastName != null) user['lastName'] = lastName;
    if (role != null) user['role'] = role;
    if (isEmailVerified != null) user['isEmailVerified'] = isEmailVerified;
    if (status != null) user['status'] = status;
    if (password != null) user['password'] = password;
    
    user['updated_at'] = DateTime.now().toIso8601String();
    
    _users[email] = user;
    return user;
  }

  // Delete user
  Future<bool> deleteUser(String email) async {
    if (!_users.containsKey(email)) {
      return false;
    }
    
    _users.remove(email);
    return true;
  }

  // Search users
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    query = query.toLowerCase();
    return _users.values.where((user) {
      return user['email'].toString().toLowerCase().contains(query) ||
             user['firstName'].toString().toLowerCase().contains(query) ||
             user['lastName'].toString().toLowerCase().contains(query);
    }).toList();
  }

  // Get users by role
  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    return _users.values.where((user) => user['role'] == role).toList();
  }

  // Get users by status
  Future<List<Map<String, dynamic>>> getUsersByStatus(String status) async {
    return _users.values.where((user) => user['status'] == status).toList();
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