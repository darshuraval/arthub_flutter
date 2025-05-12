import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:arthub_flutter/screens/auth/register_screen.dart';
import 'package:arthub_flutter/screens/auth/forgot_password_screen.dart';
import 'package:arthub_flutter/screens/main_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_main_screen.dart';
import 'package:arthub_flutter/screens/user/user_main_screen.dart';
import 'package:arthub_flutter/widgets/auth_input_field.dart';
import 'package:arthub_flutter/widgets/custom_button.dart';
import 'package:arthub_flutter/services/auth_service.dart';
import 'package:arthub_flutter/widgets/error_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arthub_flutter/screens/auth/email_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '319340216446-qc63ck6c8a139e7c91q1128d6bgpk56c.apps.googleusercontent.com',
  );
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Get user document from Firestore
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      // Check both Firebase Auth email verification and Firestore isEmailVerified flag
      if (!userCredential.user!.emailVerified || !userDoc.exists || !userDoc.data()!['isEmailVerified']) {
        // Send verification email if not already verified
        await userCredential.user!.sendEmailVerification();
        
        // Navigate to email verification screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmailVerificationScreen(
            email: _emailController.text.trim(),
          )),
        );
        return;
      }

      // Check if user is admin
      if (userDoc.exists && userDoc.data()!['role'] == 'admin') {
        // Navigate to admin screen if user is admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminMainScreen()),
        );
      } else {
        // Navigate to regular main screen for non-admin users
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserMainScreen()),
        );
      }
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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': userCredential.user!.displayName?.split(' ').first ?? '',
          'lastName': userCredential.user!.displayName?.split(' ').last ?? '',
          'email': userCredential.user!.email,
          'createdAt': FieldValue.serverTimestamp(),
          'isEmailVerified': true,
          'role': 'user', // Default role for new users
        });
      }

      // Check if user is admin
      if (userDoc.exists && userDoc.data()!['role'] == 'admin') {
        // Navigate to admin screen if user is admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminMainScreen()),
        );
      } else {
        // Navigate to regular main screen for non-admin users
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserMainScreen()),
        );
      }
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
    // Check if user is already logged in and verified
    if(_auth.currentUser != null) {
      // Check both Firebase Auth and Firestore verification status
      _firestore.collection('users').doc(_auth.currentUser!.uid).get().then((userDoc) {
        if (!_auth.currentUser!.emailVerified || !userDoc.exists || !userDoc.data()!['isEmailVerified']) {
          // If not verified, redirect to verification screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmailVerificationScreen(
              email: _auth.currentUser!.email ?? '',
            )),
          );
        } else if (userDoc.exists && userDoc.data()!['role'] == 'admin') {
          // If admin, redirect to admin screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminMainScreen()),
          );
        } else {
          // If regular user, redirect to main screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserMainScreen()),
          );
        }
      });
    }

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
                const SizedBox(height: 100),
                const Text(
                  'Welcome to ArtHub',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Login to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 48),
                AuthInputField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 24),
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
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter your password' : null,
                ),
                const SizedBox(height: 36),
                CustomButton(
                  text: _isLoading ? 'Logging in...' : 'Login',
                  onPressed: !_isLoading ? _handleLogin : null,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: Image.asset(
                    'images/google_logo.png',
                    height: 24,
                  ),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: !_isLoading ? _handleGoogleSignIn : null,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: !_isLoading
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: !_isLoading
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
