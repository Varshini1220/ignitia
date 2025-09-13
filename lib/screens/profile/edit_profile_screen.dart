import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/auth_provider.dart';
import 'package:ignitia/providers/user_provider.dart';
import 'package:ignitia/widgets/common/custom_text_field.dart';
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/utils/app_routes.dart';
import 'package:ignitia/utils/app_routes.dart';

/// Edit Profile screen for updating user information
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  
  String _selectedLanguage = 'English';
  String _selectedSector = 'Technology';
  String _selectedCareerGoal = 'Software Engineer';
  String _selectedYearLevel = '1st Year';
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _selectedLanguage = user.selectedLanguage ?? 'English';
      _selectedSector = user.selectedSector ?? 'Technology';
      _selectedCareerGoal = user.careerGoal ?? 'Software Engineer';
      _selectedYearLevel = user.yearLevel ?? '1st Year';
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Update user profile
      final success = await userProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );
      
      if (success && mounted) {
        // Update auth provider as well
        await authProvider.updateUserProfile(
          name: _nameController.text.trim(),
          selectedLanguage: _selectedLanguage,
          selectedSector: _selectedSector,
          careerGoal: _selectedCareerGoal,
          yearLevel: _selectedYearLevel,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profilePictureSelection);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: const NetworkImage(
                          'https://i.pinimg.com/564x/f3/32/19/f332192b2090f437ca9f49c1002287b6.jpg',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Basic Information
              Text(
                'Basic Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Career Information
              Text(
                'Career Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Language Dropdown
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: const InputDecoration(
                  labelText: 'Preferred Language',
                  prefixIcon: Icon(Icons.language),
                  border: OutlineInputBorder(),
                ),
                items: userProvider.getAvailableLanguages()
                    .map((language) => DropdownMenuItem(
                          value: language,
                          child: Text(language),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value ?? 'English';
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Sector Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSector,
                decoration: const InputDecoration(
                  labelText: 'Career Sector',
                  prefixIcon: Icon(Icons.work),
                  border: OutlineInputBorder(),
                ),
                items: ['Technology', 'Healthcare', 'Finance', 'Education', 'Marketing', 'Design', 'Engineering', 'Business', 'Science', 'Arts']
                    .map((sector) => DropdownMenuItem(
                          value: sector,
                          child: Text(sector),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSector = value ?? 'Technology';
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Career Goal Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCareerGoal,
                decoration: const InputDecoration(
                  labelText: 'Career Goal',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(),
                ),
                items: userProvider.getCareerGoals(_selectedSector)
                    .map((goal) => DropdownMenuItem(
                          value: goal,
                          child: Text(goal),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCareerGoal = value ?? 'Software Engineer';
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Year Level Dropdown
              DropdownButtonFormField<String>(
                value: _selectedYearLevel,
                decoration: const InputDecoration(
                  labelText: 'Year Level',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                items: userProvider.getYearLevels()
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYearLevel = value ?? '1st Year';
                  });
                },
              ),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _isLoading ? 'Saving...' : 'Save Changes',
                  onPressed: _isLoading ? null : _saveProfile,
                  size: ButtonSize.large,
                  icon: Icons.save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
