import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/auth_provider.dart';
import 'package:ignitia/providers/theme_provider.dart';
import 'package:ignitia/providers/settings_provider.dart' as settings;
import 'package:ignitia/widgets/common/custom_card.dart' hide StatCard;
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/widgets/common/stat_card.dart';
import 'package:ignitia/utils/app_routes.dart';



/// Profile screen for user information and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLanguageSelection() {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
      {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
      {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
      {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
      {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...languages.map((lang) => ListTile(
              leading: Text(
                lang['flag']!,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(lang['name']!),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language changed to ${lang['name']}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<settings.SettingsProvider>(context);
    
    final user = authProvider.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildProfileHeader(theme, user),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Stats
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildQuickStats(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile Actions
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildProfileActions(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildSettingsSection(theme, themeProvider, settingsProvider),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Logout Button
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildLogoutButton(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, user) {
    return CustomCard(
      isGradient: true,
      gradientColors: const [
        Color(0xFF6750A4),
        Color(0xFF9C27B0),
      ],
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : const NetworkImage('https://i.pinimg.com/564x/f3/32/19/f332192b2090f437ca9f49c1002287b6.jpg'),
                child: null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.careerGoal,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.profilePictureSelection);
                    },
                    icon: const Icon(Icons.photo_camera),
                    tooltip: 'Change Profile Picture',
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Learning Days',
            value: '45',
            icon: Icons.calendar_today,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Projects',
            value: '8',
            icon: Icons.work,
            iconColor: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Certificates',
            value: '3',
            icon: Icons.verified,
            iconColor: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.editProfile);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Edit Profile',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomCard(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.roadmap);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.route,
                      size: 32,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'View Roadmap',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.projects);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.work,
                      size: 32,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'My Projects',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomCard(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.community);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.people,
                      size: 32,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Community',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection(ThemeData theme, ThemeProvider themeProvider, settings.SettingsProvider settingsProvider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Theme Toggle
          _buildSettingRow(
            theme,
            'Dark Mode',
            'Switch between light and dark themes',
            themeProvider.isDarkMode,
            (value) => themeProvider.setDarkMode(value),
            Icons.dark_mode,
          ),
          
          const SizedBox(height: 16),
          
          // Notifications
          _buildSettingRow(
            theme,
            'Notifications',
            'Manage your notification preferences',
            settingsProvider.enableNotifications,
            (value) {
              settingsProvider.setEnableNotifications(value);
            },
            Icons.notifications,
          ),
          
          const SizedBox(height: 16),
          
          // Language
          _buildSettingRow(
            theme,
            'Language',
            'Change app language',
            false,
            (value) {
              _showLanguageSelection();
            },
            Icons.language,
            isNavigation: true,
          ),
          
          const SizedBox(height: 16),
          
          // Privacy
          _buildSettingRow(
            theme,
            'Privacy & Security',
            'Manage your privacy settings',
            false,
            (value) {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
            Icons.privacy_tip,
            isNavigation: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
    ThemeData theme,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon, {
    bool isNavigation = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        if (isNavigation)
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          )
        else
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primary,
          ),
      ],
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return CustomButton(
      text: 'Sign Out',
      onPressed: _handleLogout,
      type: ButtonType.outline,
      size: ButtonSize.large,
      icon: Icons.logout,
      backgroundColor: Colors.red.withOpacity(0.1),
      textColor: Colors.red,
    );
  }
}
