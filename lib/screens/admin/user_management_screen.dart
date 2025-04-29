import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../services/admin_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final AdminService _adminService = AdminService();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!_hasMore) return;

    setState(() => _isLoading = true);
    try {
      final result = await _adminService.getAllUsers(lastDocument: _lastDocument);
      if (result.data.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = result.lastDoc;
        _users.addAll(result.data);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(String uid) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _adminService.deleteUserAccount(uid);
        setState(() {
          _users.removeWhere((user) => user['uid'] == uid);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete user: $e')),
          );
        }
      }
    }
  }

  Future<void> _toggleAdminStatus(String uid, bool currentStatus) async {
    try {
      await _adminService.updateUserRole(uid, !currentStatus);
      setState(() {
        final userIndex = _users.indexWhere((user) => user['uid'] == uid);
        if (userIndex != -1) {
          _users[userIndex]['isAdmin'] = !currentStatus;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ${!currentStatus ? 'promoted to' : 'demoted from'} admin'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user role: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: _isLoading && _users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _users.clear();
                _lastDocument = null;
                _hasMore = true;
                await _loadUsers();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _users.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _users.length) {
                    _loadUsers();
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = _users[index];
                  return Card(
                    child: ListTile(
                      title: Text(user['email'] ?? 'No email'),
                      subtitle: Text('UID: ${user['uid']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user['isAdmin'] == true
                                  ? Icons.admin_panel_settings
                                  : Icons.person,
                              color: user['isAdmin'] == true
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () => _toggleAdminStatus(
                              user['uid'],
                              user['isAdmin'] == true,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user['uid']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
} 