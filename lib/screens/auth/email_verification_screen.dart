import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arthub_flutter/screens/user/user_main_screen.dart';
import 'package:arthub_flutter/screens/auth/login_screen.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isVerified = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    
    _checkEmailVerification();
    
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isVerified) {
        _checkEmailVerification();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleChangeEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signOut();
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkEmailVerification() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if ((userDoc.exists && userDoc.data()!['isEmailVerified'] == true) || user.emailVerified) {
          if (userDoc.exists && userDoc.data()!['isEmailVerified'] != true) {
            await _firestore.collection('users').doc(user.uid).update({
              'isEmailVerified': true,
            });
          }
          
          setState(() {
            _isVerified = true;
          });

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserMainScreen()),
              );
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verification email sent. Please check your inbox.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF389C88),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF389C88),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isVerified ? Icons.mark_email_read : Icons.mark_email_unread_outlined,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      _isVerified ? 'Email Verified!' : 'Verify Your Email',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _isVerified
                                ? 'Your email has been verified successfully.'
                                : 'We have sent a verification email to:',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (!_isVerified) ...[
                      _buildButton(
                        onPressed: _isLoading ? null : _resendVerificationEmail,
                        text: _isLoading ? 'Sending...' : 'Resend Verification Email',
                        icon: Icons.send,
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        onPressed: _isLoading ? null : _checkEmailVerification,
                        text: _isLoading ? 'Checking...' : 'I have verified my email',
                        icon: Icons.check_circle_outline,
                        isOutlined: true,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _isLoading ? null : _handleChangeEmail,
                        child: const Text(
                          'Use a different email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (_isLoading)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required String text,
    required IconData icon,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : Colors.white,
          foregroundColor: isOutlined ? Colors.white : const Color(0xFF389C88),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: isOutlined ? const BorderSide(color: Colors.white, width: 2) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}