import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arthub_flutter/services/user_service.dart';
import 'package:arthub_flutter/screens/user/edit_profile_screen.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  User? _firebaseUser;
  Map<String, dynamic>? _userData;
  bool _isEditing = false;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firebaseUser = FirebaseAuth.instance.currentUser;
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    if (_firebaseUser == null) return;
    final user = await _userService.getUserByEmail(_firebaseUser!.email!);
    setState(() {
      _userData = user;
      _isLoading = false;
      if (user != null) {
        _firstNameController.text = user['firstName'] ?? '';
        _lastNameController.text = user['lastName'] ?? '';
        _emailController.text = user['email'] ?? '';
      }
    });
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // The UserService.updateUser does NOT support updating phone.
    // Only firstName and lastName will be updated in Firestore.
    await _userService.updateUser(
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    );
    setState(() {
      _isEditing = false;
    });
    await _fetchUserProfile();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('No profile data found.'))
              : Column(
                  children: [
                    Container(
                      height: 200,
                      color: const Color(0xFF21967A),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.teal[200],
                              child: Text(
                                (_firstNameController.text.isNotEmpty ? _firstNameController.text[0] : '?'),
                                style: const TextStyle(fontSize: 36, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_firstNameController.text} ${_lastNameController.text}',
                                  style: const TextStyle(fontSize: 24, color: Colors.white),
                                ),
                                Text(
                                  _emailController.text,
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text('Edit Profile'),
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileScreen(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                          // phone: _phoneController.text,
                                        ),
                                      ),
                                    );
                                    if (result != null && result is Map<String, dynamic>) {
                                      setState(() {
                                        _firstNameController.text = result['firstName'] ?? _firstNameController.text;
                                        _lastNameController.text = result['lastName'] ?? _lastNameController.text;
                                        _emailController.text = result['email'] ?? _emailController.text;
                                        // _phoneController.text = result['phone'] ?? _phoneController.text;
                                        if (_userData != null) {
                                          _userData!['firstName'] = _firstNameController.text;
                                          _userData!['lastName'] = _lastNameController.text;
                                          _userData!['email'] = _emailController.text;
                                          // _userData!['phone'] = _phoneController.text;
                                        }
                                      });
                                    }
                                  },
                                ),
                                ListTile(
                                  title: const Text('Language & Currency'),
                                  onTap: () => Navigator.pushNamed(context, '/language-currency'),
                                ),
                                ListTile(
                                  title: const Text('Feedback'),
                                  onTap: () => Navigator.pushNamed(context, '/feedback'),
                                ),
                                ListTile(
                                  title: const Text('Refer a Friend'),
                                  onTap: () => Navigator.pushNamed(context, '/refer-friend'),
                                ),
                                ListTile(
                                  title: const Text('Terms & Conditions'),
                                  onTap: () => Navigator.pushNamed(context, '/terms-conditions'),
                                ),
                                ListTile(
                                  title: const Text('Logout'),
                                  onTap: _logout,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                                validator: (v) => (v == null || v.isEmpty) ? 'First name required' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                                validator: (v) => (v == null || v.isEmpty) ? 'Last name required' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                enabled: false, // Email is not editable
                                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _updateProfile,
                                child: const Text('Save Changes'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}
