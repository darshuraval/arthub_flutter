import 'package:flutter/material.dart';
import 'package:arthub_flutter/widgets/auth_input_field.dart';
import 'package:arthub_flutter/screens/auth/email_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureRePassword = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _rePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.sendEmailVerification();

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'isEmailVerified': false,
        'role': 'user',
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationScreen(
          email: _emailController.text.trim(),
        )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF389C88),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome to ArtHub',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Signup to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 36),
                AuthInputField(
                  controller: _firstNameController,
                  hintText: 'First Name',
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your first name' : null,
                ),
                const SizedBox(height: 20),
                AuthInputField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your last name' : null,
                ),
                const SizedBox(height: 20),
                AuthInputField(
                  controller: _emailController,
                  hintText: 'Email ID',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
                ),
                const SizedBox(height: 20),
                AuthInputField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                ),
                const SizedBox(height: 20),
                AuthInputField(
                  controller: _rePasswordController,
                  hintText: 'Re-enter Password',
                  obscureText: _obscureRePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureRePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureRePassword = !_obscureRePassword;
                      });
                    },
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please re-enter your password' : null,
                ),
                const SizedBox(height: 36),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isLoading ? 'Creating Account...' : 'Create',
                    style: const TextStyle(
                      color: Color(0xFF389C88),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Have an account? ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
