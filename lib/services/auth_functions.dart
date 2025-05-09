import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '319340216446-qc63ck6c8a139e7c91q1128d6bgpk56c.apps.googleusercontent.com',
  );

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Create Firestore document
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'createdAt': DateTime.now(),
        'email': credential.user!.email,
        'firstName': credential.user!.displayName ?? '',
        'isEmailVerified': true,
        'lastName': credential.user!.displayName ?? '',
        'role': 'user',
        'uid': credential.user!.uid,
        'photoUrl': credential.user!.photoURL ?? '',
        'updatedAt': DateTime.now(),
      });

      return credential.user;
    } catch (e) {
      throw Exception("Register failed: $e");
    }
  }

  // Register with Google
  Future<User?> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // Create Firestore document
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'createdAt': DateTime.now(),
        'email': user.email,
        'firstName': user.displayName ?? '',
        'isEmailVerified': true,
        'lastName': user.displayName ?? '',
        'role': 'user',
        'uid': user.uid,
        'photoUrl': user.photoURL ?? '',
        'updatedAt': DateTime.now(),
      });

      return user;
    } catch (e) {
      throw Exception("Google Sign-In failed: $e");
    }
  }

  // Login with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  // Login with Google
  Future<User?> loginWithGoogle() async {
    return await registerWithGoogle(); // same logic as register
  }

  // Logout
  Future<void> LogOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }

  // Check if email is verified
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (!userDoc.exists) throw Exception("User document not found.");
        return userDoc['isEmailVerified'] ?? false;
      } catch (e) {
        throw Exception("Verification check failed: $e");
      }
    }
    return false;
  }

  // Send email verification
  Future<void> sendEmailVerificationOtp(String email) async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw Exception("User not found or already verified.");
    }
  }

  // Verify email with link (otp is actually a link in Firebase)
  Future<bool> verifyEmailOtp(String email, String otpLink) async {
    try {
      final bool validLink = await _auth.isSignInWithEmailLink(otpLink);
      if (!validLink) throw Exception("Invalid verification link.");

      final UserCredential result = await _auth.signInWithEmailLink(email: email, emailLink: otpLink);
      return result.user != null;
    } catch (e) {
      throw Exception("OTP verification failed: $e");
    }
  }

  // Send password reset
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<String?> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    return userDoc['role'] as String?;
  }
}
