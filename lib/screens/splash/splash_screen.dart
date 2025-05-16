import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
import 'package:arthub_flutter/screens/onboarding/onboarding_screen.dart';
import 'package:arthub_flutter/screens/admin/admin_main_screen.dart';
import 'package:arthub_flutter/screens/user/user_main_screen.dart';
import 'package:arthub_flutter/services/shared_preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final isFirstTime = await SharedPreferencesService.isFirstTime();
    if (isFirstTime) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
      return;
    }

    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (mounted) {
          if (userDoc.exists && userDoc.data()!['role'] == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminMainScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserMainScreen()),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D9B88),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
} 