import 'package:flutter/material.dart';
import '../../../shared/models/user_model.dart';

/// Provider for authentication-related state and operations
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  UserModel? _currentUser;
  final bool _mockAuthEnabled = true; // Add this line

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get currentUser => _currentUser;

  /// Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual authentication with Supabase
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      // Mock successful authentication
      _currentUser = UserModel(
        id: 'user-123',
        name: 'Test User',
        email: email,
        profileImageUrl: null,
        phoneNumber: null,
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to sign in: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Register with email and password
  Future<bool> registerWithEmailAndPassword(
    String email,
    String password,
    String fullName,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual registration with Supabase
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      // Mock successful registration
      _currentUser = UserModel(
        id: 'user-123',
        name: fullName,
        email: email,
        profileImageUrl: null,
        phoneNumber: null,
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to register: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);

    try {
      // TODO: Implement actual sign out with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      _currentUser = null;
      _isAuthenticated = false;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to sign out: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual password reset with Supabase
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to reset password: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Check if user is authenticated
  Future<bool> checkAuthStatus() async {
    _setLoading(true);

    try {
      // TODO: Implement actual auth check with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Mock check - will be replaced with actual implementation
      final bool hasSession = _mockAuthEnabled;

      // Set default values first
      _currentUser = null;
      _isAuthenticated = false;

      if (hasSession) {
        // Mock user data
        _currentUser = UserModel(
          id: 'user-123',
          name: 'Test User',
          email: 'test@example.com',
          profileImageUrl: null,
          phoneNumber: null,
          createdAt: DateTime.now(),
        );
        _isAuthenticated = true;
      }

      _setLoading(false);
      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      _setError('Failed to check auth status: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
