import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/auth_provider.dart';
import 'package:ignitia/providers/user_provider.dart';
import 'package:ignitia/providers/roadmap_provider.dart';
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/widgets/common/custom_text_field.dart';
import 'package:ignitia/utils/app_routes.dart';

/// Career setup screen for configuring user preferences and generating roadmap
class CareerSetupScreen extends StatefulWidget {
  const CareerSetupScreen({super.key});

  @override
  State<CareerSetupScreen> createState() => _CareerSetupScreenState();
}

class _CareerSetupScreenState extends State<CareerSetupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedLanguage = 'English';
  String _selectedSector = '';
  String _selectedCareerGoal = '';
  String _selectedYearLevel = '1st Year';
  bool _isPaidUser = false;
  
  List<String> _availableCareerGoals = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadInitialData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  void _loadInitialData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Initialize UserProvider with AuthProvider data if not already initialized
    if (userProvider.user == null && authProvider.currentUser != null) {
      userProvider.initializeUser(authProvider.currentUser!);
    }

    final user = authProvider.currentUser;
    _selectedLanguage = user?.selectedLanguage ?? 'English';
    _selectedSector = user?.selectedSector ?? '';
    _selectedCareerGoal = user?.careerGoal ?? '';
    _selectedYearLevel = user?.yearLevel ?? '1st Year';
    _isPaidUser = user?.isPaidUser ?? false;

    if (_selectedSector.isNotEmpty) {
      _availableCareerGoals = userProvider.getCareerGoals(_selectedSector);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSectorChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedSector = value;
        _selectedCareerGoal = '';
        _availableCareerGoals = Provider.of<UserProvider>(context, listen: false)
            .getCareerGoals(value);
      });
    }
  }

  void _onCareerGoalChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedCareerGoal = value;
      });
    }
  }

  Future<void> _generateRoadmap() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedSector.isEmpty || _selectedCareerGoal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both sector and career goal'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final roadmapProvider = Provider.of<RoadmapProvider>(context, listen: false);

    // Update user preferences in both providers
    await userProvider.updatePreferences(
      language: _selectedLanguage,
      sector: _selectedSector,
      careerGoal: _selectedCareerGoal,
      yearLevel: _selectedYearLevel,
      isPaidUser: _isPaidUser,
    );

    // Also update the AuthProvider with the updated user data
    if (authProvider.currentUser != null) {
      final updatedUser = authProvider.currentUser!.copyWith(
        selectedLanguage: _selectedLanguage,
        selectedSector: _selectedSector,
        careerGoal: _selectedCareerGoal,
        yearLevel: _selectedYearLevel,
        isPaidUser: _isPaidUser,
      );
      await authProvider.updateProfile(updatedUser);
    }

    // Generate roadmap
    await roadmapProvider.generateRoadmap(
      sector: _selectedSector,
      careerGoal: _selectedCareerGoal,
      yearLevel: _selectedYearLevel,
      isPaidUser: _isPaidUser,
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final roadmapProvider = Provider.of<RoadmapProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6750A4),
              Color(0xFF9C27B0),
              Color(0xFFE91E63),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Header Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.rocket_launch,
                          size: 40,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Let\'s Set Up Your Career Path',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tell us about your goals and we\'ll create a personalized learning roadmap',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Setup Form
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Language Selection
                            Text(
                              'Preferred Language',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedLanguage,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              dropdownColor: theme.colorScheme.surface,
                              items: userProvider.getAvailableLanguages()
                                  .map((language) => DropdownMenuItem(
                                        value: language,
                                        child: Text(
                                          language,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedLanguage = value ?? 'English';
                                });
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Sector Selection
                            Text(
                              'Career Sector',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedSector.isEmpty ? null : _selectedSector,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                hintText: 'Select your career sector',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                              ),
                              dropdownColor: theme.colorScheme.surface,
                              items: userProvider.getAvailableSectors()
                                  .map((sector) => DropdownMenuItem(
                                        value: sector,
                                        child: Text(
                                          sector,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: _onSectorChanged,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a career sector';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Career Goal Selection
                            Text(
                              'Specific Career Goal',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedCareerGoal.isEmpty ? null : _selectedCareerGoal,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                hintText: _selectedSector.isEmpty
                                    ? 'Select sector first'
                                    : 'Select your career goal',
                                hintStyle: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  fontSize: 16,
                                ),
                              ),
                              dropdownColor: theme.colorScheme.surface,
                              items: _availableCareerGoals
                                  .map((goal) => DropdownMenuItem(
                                        value: goal,
                                        child: Text(
                                          goal,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: _selectedSector.isEmpty ? null : _onCareerGoalChanged,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a career goal';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Year Level Selection
                            Text(
                              'Current Level',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedYearLevel,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              dropdownColor: theme.colorScheme.surface,
                              items: userProvider.getYearLevels()
                                  .map((level) => DropdownMenuItem(
                                        value: level,
                                        child: Text(
                                          level,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedYearLevel = value ?? '1st Year';
                                });
                              },
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Paid/Free Toggle
                            Text(
                              'Learning Type',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isPaidUser = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: !_isPaidUser 
                                              ? theme.colorScheme.primary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Free',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: !_isPaidUser 
                                                ? Colors.white
                                                : theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isPaidUser = true;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: _isPaidUser 
                                              ? theme.colorScheme.primary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Premium',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: _isPaidUser 
                                                ? Colors.white
                                                : theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Generate Roadmap Button
                            CustomButton(
                              text: 'Generate My Roadmap',
                              onPressed: roadmapProvider.isLoading ? null : _generateRoadmap,
                              isLoading: roadmapProvider.isLoading,
                              size: ButtonSize.large,
                              icon: Icons.rocket_launch,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Info Text
                            Text(
                              'Don\'t worry, you can always change these settings later in your profile.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
