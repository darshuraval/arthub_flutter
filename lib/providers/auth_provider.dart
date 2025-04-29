import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final AdminService _adminService = AdminService();
  User? _user;
  bool _isAdmin = false;
  bool _isLoading = true;

  User? get user => _user;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _user = _authService.getCurrentUser();
    if (_user != null) {
      _isAdmin = await _adminService.isAdmin();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithEmail(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.loginWithEmail(email, password);
      if (_user != null) {
        _isAdmin = await _adminService.isAdmin();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authService.signInWithGoogle();
      if (_user != null) {
        _isAdmin = await _adminService.isAdmin();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _isAdmin = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reloadUser() async {
    if (_user != null) {
      await _authService.reloadCurrentUser();
      _user = _authService.getCurrentUser();
      _isAdmin = await _adminService.isAdmin();
      notifyListeners();
    }
  }
} 