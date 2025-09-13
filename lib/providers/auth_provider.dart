import 'package:flutter/material.dart';
import 'package:ignitia/models/user_model.dart';

/// Authentication provider for managing user login state
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  /// Sign in with email and password
  Future<bool> signInWithEmail(String name, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      _currentUser = UserModel(
        id: 'user_123',
        email: email,
        name: name,
        profileImage: 'https://i.pinimg.com/564x/f3/32/19/f332192b2090f437ca9f49c1002287b6.jpg',
        selectedLanguage: 'English',
        selectedSector: 'Technology',
        careerGoal: 'Software Engineer',
        yearLevel: '3rd Year',
        isPaidUser: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate Google sign-in
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: 'google_user_123',
        email: 'john.doe@gmail.com',
        name: 'John Doe',
        profileImage: 'https://i.pinimg.com/564x/f3/32/19/f332192b2090f437ca9f49c1002287b6.jpg',
        selectedLanguage: 'English',
        selectedSector: 'Technology',
        careerGoal: 'Software Engineer',
        yearLevel: '3rd Year',
        isPaidUser: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Google sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign up with email and password
  Future<bool> signUp(String name, String email, String password, String confirmPassword) async {
    _setLoading(true);
    _clearError();

    if (password != confirmPassword) {
      _setError('Passwords do not match');
      _setLoading(false);
      return false;
    }

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: 'new_user_123',
        email: email,
        name: name,
        selectedLanguage: 'English',
        selectedSector: '',
        careerGoal: '',
        yearLevel: '1st Year',
        isPaidUser: false,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Continue as guest
  Future<bool> continueAsGuest() async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = UserModel(
        id: 'guest_user',
        email: 'guest@pathpilot.com',
        name: 'Guest User',
        selectedLanguage: 'English',
        selectedSector: '',
        careerGoal: '',
        yearLevel: '1st Year',
        isPaidUser: false,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Guest login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? email,
    String? profileImage,
    String? selectedLanguage,
    String? selectedSector,
    String? careerGoal,
    String? yearLevel,
  }) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        profileImage: profileImage ?? _currentUser!.profileImage,
        selectedLanguage: selectedLanguage ?? _currentUser!.selectedLanguage,
        selectedSector: selectedSector ?? _currentUser!.selectedSector,
        careerGoal: careerGoal ?? _currentUser!.careerGoal,
        yearLevel: yearLevel ?? _currentUser!.yearLevel,
      );

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  /// Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
