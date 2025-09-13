import 'package:flutter/material.dart';
import 'package:ignitia/models/user_model.dart';

/// User provider for managing user data and preferences
class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize user data
  void initializeUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Update user preferences
  Future<bool> updatePreferences({
    String? language,
    String? sector,
    String? careerGoal,
    String? yearLevel,
    bool? isPaidUser,
  }) async {
    if (_user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _user = _user!.copyWith(
        selectedLanguage: language ?? _user!.selectedLanguage,
        selectedSector: sector ?? _user!.selectedSector,
        careerGoal: careerGoal ?? _user!.careerGoal,
        yearLevel: yearLevel ?? _user!.yearLevel,
        isPaidUser: isPaidUser ?? _user!.isPaidUser,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update preferences: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile information
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? profileImage,
  }) async {
    if (_user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _user = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        profileImage: profileImage ?? _user!.profileImage,
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

  /// Get available languages
  List<String> getAvailableLanguages() {
    return [
      'English',
      'Spanish',
      'French',
      'German',
      'Italian',
      'Portuguese',
      'Chinese',
      'Japanese',
      'Korean',
      'Hindi',
    ];
  }

  /// Get available sectors
  List<String> getAvailableSectors() {
    return [
      'Technology',
      'Healthcare',
      'Finance',
      'Education',
      'Marketing',
      'Design',
      'Engineering',
      'Business',
      'Arts',
      'Science',
      'Law',
      'Media',
    ];
  }

  /// Get career goals based on sector
  List<String> getCareerGoals(String sector) {
    switch (sector.toLowerCase()) {
      case 'technology':
        return [
          'Software Engineer',
          'Data Scientist',
          'Cybersecurity Analyst',
          'DevOps Engineer',
          'Product Manager',
          'UX/UI Designer',
          'Mobile Developer',
          'Web Developer',
          'AI/ML Engineer',
          'Cloud Architect',
        ];
      case 'healthcare':
        return [
          'Doctor',
          'Nurse',
          'Pharmacist',
          'Physical Therapist',
          'Medical Researcher',
          'Healthcare Administrator',
          'Medical Technologist',
          'Public Health Specialist',
        ];
      case 'finance':
        return [
          'Financial Analyst',
          'Investment Banker',
          'Accountant',
          'Financial Advisor',
          'Risk Manager',
          'Portfolio Manager',
          'Insurance Agent',
          'Banking Professional',
        ];
      case 'education':
        return [
          'Teacher',
          'Professor',
          'Educational Administrator',
          'Curriculum Developer',
          'Educational Consultant',
          'Librarian',
          'Training Specialist',
          'Academic Researcher',
        ];
      default:
        return [
          'Manager',
          'Analyst',
          'Specialist',
          'Coordinator',
          'Consultant',
          'Director',
          'Executive',
          'Professional',
        ];
    }
  }

  /// Get year levels
  List<String> getYearLevels() {
    return [
      '1st Year',
      '2nd Year',
      '3rd Year',
      '4th Year',
      'Graduate',
      'Post Graduate',
      'Professional',
    ];
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
