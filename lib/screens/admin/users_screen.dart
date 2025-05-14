import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> _authUsers = [];
  List<Map<String, dynamic>> _firestoreUsers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedRole = 'All';
  String _selectedStatus = 'All';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final result = await _userService.getAllUsers();
      setState(() {
        _authUsers = result.authUsers;
        _firestoreUsers = result.firestoreUsers;
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
          password: result['password']!,
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

  List<Map<String, dynamic>> _getFilteredUsers(List<Map<String, dynamic>> users) {
    return users.where((user) {
      final matchesSearch = _searchQuery.isEmpty ||
          user['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['firstName']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
          user['lastName']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) == true;

      final matchesRole = _selectedRole == 'All' || user['role'] == _selectedRole;
      final matchesStatus = _selectedStatus == 'All' || user['status'] == _selectedStatus;

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  Widget _buildUserList(List<Map<String, dynamic>> users, bool isAuthTab) {
    // Filter users based on source
    final filteredUsers = users.where((user) => 
      isAuthTab ? user['source'] == 'auth' : user['source'] == 'firestore'
    ).toList();
    
    final searchFilteredUsers = _getFilteredUsers(filteredUsers);
    
    if (searchFilteredUsers.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }

    return ListView.builder(
      itemCount: searchFilteredUsers.length,
      itemBuilder: (context, index) {
        final user = searchFilteredUsers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              (user['firstName']?[0] ?? user['email']?[0] ?? '?').toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            user['firstName'] != null && user['lastName'] != null
                ? '${user['firstName']} ${user['lastName']}'
                : user['email'],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user['email'] ?? 'No email'),
              if (user['role'] != null) Text('Role: ${user['role']}'),
              if (user['status'] != null) Text('Status: ${user['status']}'),
              if (user['isEmailVerified'] != null) 
                Text('Email Verified: ${user['isEmailVerified'] ? 'Yes' : 'No'}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _updateUser(user),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteUser(user['email']),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Users Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: _createUser,
                    icon: const Icon(Icons.add),
                    label: const Text('Add User'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Roles')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'user', child: Text('User')),
                ],
                onChanged: (value) {
                  setState(() => _selectedRole = value!);
                },
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Status')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Firestore Users'),
              Tab(text: 'Firebase Auth Users'),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      Card(child: _buildUserList(_firestoreUsers, false)),
                      Card(child: _buildUserList(_authUsers, true)),
                    ],
                  ),
          ),
        ],
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