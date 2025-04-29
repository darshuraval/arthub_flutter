// register with email and password - registerWithEmailAndPassword(email, password) - returns user
// register with google - registerWithGoogle() - returns user

//login with email and password - loginWithEmailAndPassword(email, password) - returns user
//login with google - loginWithGoogle() - returns user
//logout - LogOut() - returns void
//check if user is logged in - isUserLoggedIn() - returns bool
//check if user is email verified - isEmailVerified() - returns bool
//send email verification otp - sendEmailVerificationOtp(email) - returns void
//verify email otp - verifyEmailOtp(email, otp) - returns bool
//check if user is email verified - isEmailVerified() - returns bool
//send password reset email - sendPasswordResetEmail(email) - returns void
//get current user - getCurrentUser() - returns user

import 'package:firebase_auth/firebase_auth.dart';

class AuthFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User?> registerWithGoogle() async {
    try {
      final credential = await _googleSignIn.signIn(
        clientId: '319340216446-qc63ck6c8a139e7c91q1128d6bgpk56c.apps.googleusercontent.com',
      );
      //create document in firestore with user id and email
      await FirebaseFirestore.instance.collection('users').doc(credential.user?.uid).set({
        'uid': credential.user?.uid,
        'email': credential.user?.email,
        'name': credential.user?.displayName,
        'photoUrl': credential.user?.photoUrl,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isEmailVerified': true,
        'role': 'user',
      });
      return credential.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> LogOut() async {
    await _auth.signOut();
  }

  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<bool> isEmailVerified() async {
    //check document in firestore with user id and email also show error if not found
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        return userDoc.exists && userDoc['isEmailVerified'];
      } catch (e) {
        throw Exception(e); 
      }
    }
    return false;
  }

  Future<void> sendEmailVerificationOtp(String email) async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<bool> verifyEmailOtp(String email, String otp) async {
    final credential = await _auth.signInWithEmailLink(email, otp);
    return credential.user != null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
}
