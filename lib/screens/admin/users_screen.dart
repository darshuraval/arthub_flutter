import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/section_header.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/custom_button.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _UserCard({required this.user, required this.onEdit, required this.onDelete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/user_logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['firstName'] != null && user['lastName'] != null
                      ? '${user['firstName']} ${user['lastName']}'
                      : user['email'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  user['email'] ?? 'No email',
                  style: const TextStyle(fontSize: 16, decoration: TextDecoration.underline),
                ),
                const SizedBox(height: 2),
                Text(
                  user['status'] != null ? user['status'][0].toUpperCase() + user['status'].substring(1) : 'Active',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D9B88),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D9B88),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  elevation: 0,
                ),
                child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UsersScreenState extends State<UsersScreen> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedRole = 'All';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final result = await _userService.getAllUsers();
      setState(() {
        _users = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading users: $e')),
        );
      }
    }
  }

  Future<void> _createUser() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _UserFormDialog(),
    );

    if (result != null) {
      try {
        await _userService.createUser(
          email: result['email']!,
          firstName: result['firstName']!,
          lastName: result['lastName']!,
          role: result['role']!,
          isEmailVerified: result['isEmailVerified'] == 'true',
          status: result['status']!,
        );
        _loadUsers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating user: $e')),
          );
        }
      }
    }
  }

  Future<void> _updateUser(Map<String, dynamic> user) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _UserFormDialog(user: user),
    );

    if (result != null) {
      try {
        await _userService.updateUser(
          email: user['email'],
          firstName: result['firstName'],
          lastName: result['lastName'],
          role: result['role'],
          status: result['status'],
          isEmailVerified: result['isEmailVerified'] == 'true',
        );
        _loadUsers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating user: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteUser(String email) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: const Text('Are you sure you want to delete this user?'),
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

    if (confirm == true) {
      try {
        await _userService.deleteUser(email);
        _loadUsers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting user: $e')),
          );
        }
      }
    }
  }

  Future<void> _showFilterDialog() async {
    String tempRole = _selectedRole;
    String tempStatus = _selectedStatus;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Users'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: tempRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Roles')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'user', child: Text('User')),
                ],
                onChanged: (value) {
                  tempRole = value!;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tempStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Status')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) {
                  tempStatus = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  _selectedRole = tempRole;
                  _selectedStatus = tempStatus;
                });
                await _applyFilter();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyFilter() async {
    setState(() => _isLoading = true);
    try {
      List<Map<String, dynamic>> users = [];
      if (_selectedRole != 'All' && _selectedStatus != 'All') {
        users = await _userService.getUsersByStatus(_selectedStatus);
        users = users.where((u) => u['role'] == _selectedRole).toList();
      } else if (_selectedRole != 'All') {
        users = await _userService.getUsersByRole(_selectedRole);
      } else if (_selectedStatus != 'All') {
        users = await _userService.getUsersByStatus(_selectedStatus);
      } else {
        final result = await _userService.getAllUsers();
        users = result;
      }
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error applying filter: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Users',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _showFilterDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6F2F0),
                          foregroundColor: const Color(0xFF2D9B88),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        ),
                        child: const Text('Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _createUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D9B88),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        ),
                        child: const Text('Add User', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: filteredUsers
                          .map((user) => _UserCard(
                                user: user,
                                onEdit: () => _updateUser(user),
                                onDelete: () => _deleteUser(user['email']),
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserFormDialog extends StatefulWidget {
  final Map<String, dynamic>? user;

  const _UserFormDialog({this.user});

  @override
  State<_UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<_UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _selectedRole = 'user';
  String _selectedStatus = 'active';
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _emailController.text = widget.user!['email'] ?? '';
      _firstNameController.text = widget.user!['firstName'] ?? '';
      _lastNameController.text = widget.user!['lastName'] ?? '';
      _selectedRole = widget.user!['role'] ?? 'user';
      _selectedStatus = widget.user!['status'] ?? 'active';
      _isEmailVerified = widget.user!['isEmailVerified'] ?? false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit User' : 'Create User'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: !isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              if (!isEditing) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'user', child: Text('User')),
                ],
                onChanged: (value) {
                  setState(() => _selectedRole = value!);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
              ),
              if (isEditing) ...[
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Email Verified'),
                  value: _isEmailVerified,
                  onChanged: (value) {
                    setState(() => _isEmailVerified = value);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'email': _emailController.text,
                'password': _passwordController.text,
                'firstName': _firstNameController.text,
                'lastName': _lastNameController.text,
                'role': _selectedRole,
                'status': _selectedStatus,
                'isEmailVerified': _isEmailVerified.toString(),
              });
            }
          },
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
} 