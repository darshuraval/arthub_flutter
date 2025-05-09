/// AuthService: Handles all authentication and Firebase operations.
/// Now includes: error handling, secure OTP generation, useful utilities.
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // In-memory OTP store (for demo only; for production use Firestore or secure backend)
  static final Map<String, String> _otpStore = {};

  /// Helper: Generate a 6-digit random OTP
  String generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Registers a user with email and password, then sends email verification
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await sendEmailOTP(email);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    }
  }

  /// Checks if a user is already registered by email
  Future<bool> isUserRegistered(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check registration: $e');
    }
  }

  /// Sends Firebase email verification OTP
  Future<void> sendEmailOTP(String email) async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        // await user.sendEmailVerification();
        await sendCustomEmailOTP(email);
      } catch (e) {
        throw Exception('Failed to send email verification: $e');
      }
    }
  }

  /// Verifies if the user's email is verified
  Future<bool> verifyEmailOTP(String email, String otp) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.reload();
        return user.emailVerified;
      } catch (e) {
        throw Exception('Failed to verify email: $e');
      }
    }
    return false;
  }

  /// Login user with email and password
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  /// Check if user email is verified
  Future<bool> isEmailVerified(User user) async {
    try {
      await user.reload();
      return user.emailVerified;
    } catch (e) {
      throw Exception('Failed to reload user: $e');
    }
  }

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId: '319340216446-qc63ck6c8a139e7c91q1128d6bgpk56c.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      if (_auth.currentUser != null) {
        await _auth.signOut();
        await _googleSignIn.signOut();
      }
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Password reset failed: ${e.message}');
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Check if user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Reload current user
  Future<void> reloadCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.reload();
      } catch (e) {
        throw Exception('Failed to reload user: $e');
      }
    }
  }

  /// Send custom email OTP using SMTP
  Future<void> sendCustomEmailOTP(String email) async {
    final otp = generateOtp();
    _otpStore[email] = otp;

    // Load SMTP credentials from environment variables
    final smtpUsername = dotenv.env['SMTP_USERNAME'];
    final smtpPassword = dotenv.env['SMTP_PASSWORD'];

    if (smtpUsername == null || smtpPassword == null) {
      throw Exception('SMTP credentials are not set in environment variables.');
    }

    // SMTP server configuration
    final smtpServer = SmtpServer(
      'smtp.gmail.com', // SMTP server
      username: smtpUsername,
      password: smtpPassword,
      port: 587,
      ssl: false,
    );

    final message = Message()
      ..from = Address(smtpUsername, 'ArtHub')
      ..recipients.add(email)
      ..subject = 'Your ArtHub OTP Code'
      ..text = 'Your OTP code is: $otp';

    try {
      await send(message, smtpServer);
    } catch (e) {
      _otpStore.remove(email);
      throw Exception('Failed to send custom OTP: $e');
    }
  }

  /// Verify custom email OTP
  Future<bool> verifyCustomEmailOTP(String email, String otp) async {
    final storedOtp = _otpStore[email];
    if (storedOtp != null && storedOtp == otp) {
      _otpStore.remove(email);
      return true;
    }
    return false;
  }

  /// Delete user account
  Future<void> deleteUser(String uid) async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to delete user: ${e.message}');
    }
  }
}
