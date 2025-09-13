/// User model representing student profile and preferences
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String selectedLanguage;
  final String selectedSector;
  final String careerGoal;
  final String yearLevel;
  final bool isPaidUser;
  final DateTime createdAt;
  final DateTime lastLogin;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    required this.selectedLanguage,
    required this.selectedSector,
    required this.careerGoal,
    required this.yearLevel,
    required this.isPaidUser,
    required this.createdAt,
    required this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      selectedLanguage: json['selectedLanguage'] ?? 'English',
      selectedSector: json['selectedSector'] ?? '',
      careerGoal: json['careerGoal'] ?? '',
      yearLevel: json['yearLevel'] ?? '1st Year',
      isPaidUser: json['isPaidUser'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin: DateTime.parse(json['lastLogin'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'selectedLanguage': selectedLanguage,
      'selectedSector': selectedSector,
      'careerGoal': careerGoal,
      'yearLevel': yearLevel,
      'isPaidUser': isPaidUser,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
    String? selectedLanguage,
    String? selectedSector,
    String? careerGoal,
    String? yearLevel,
    bool? isPaidUser,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedSector: selectedSector ?? this.selectedSector,
      careerGoal: careerGoal ?? this.careerGoal,
      yearLevel: yearLevel ?? this.yearLevel,
      isPaidUser: isPaidUser ?? this.isPaidUser,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
