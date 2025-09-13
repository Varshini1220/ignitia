import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/theme_provider.dart';
import 'package:ignitia/widgets/common/custom_card.dart';
import 'package:ignitia/widgets/common/custom_button.dart';

/// Settings screen for app preferences and configuration
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
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

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IGNITIA Privacy Policy',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Data Collection:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• We collect information you provide when creating an account\n'
                '• Learning progress and preferences to personalize your experience\n'
                '• Usage analytics to improve our services',
              ),
              SizedBox(height: 16),
              Text(
                'Data Usage:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Personalize your learning roadmap\n'
                '• Provide relevant resources and recommendations\n'
                '• Track your progress and achievements',
              ),
              SizedBox(height: 16),
              Text(
                'Data Protection:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Your data is encrypted and securely stored\n'
                '• We never share personal information with third parties\n'
                '• You can request data deletion at any time',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildAppearanceSection(theme, themeProvider),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildNotificationsSection(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Privacy Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildPrivacySection(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // About Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildAboutSection(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(ThemeData theme, ThemeProvider themeProvider) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Theme Mode
          _buildSettingRow(
            theme,
            'Theme Mode',
            'Choose your preferred theme',
            Icons.palette,
            _buildThemeModeSelector(theme, themeProvider),
          ),
          
          const SizedBox(height: 16),
          
          // Font Size
          _buildSettingRow(
            theme,
            'Font Size',
            'Adjust text size for better readability',
            Icons.text_fields,
            _buildFontSizeSelector(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeSelector(ThemeData theme, ThemeProvider themeProvider) {
    return Row(
      children: [
        _buildThemeOption(
          theme,
          'Light',
          Icons.light_mode,
          ThemeMode.light,
          themeProvider.themeMode == ThemeMode.light,
          () => themeProvider.setThemeMode(ThemeMode.light),
        ),
        const SizedBox(width: 12),
        _buildThemeOption(
          theme,
          'Dark',
          Icons.dark_mode,
          ThemeMode.dark,
          themeProvider.themeMode == ThemeMode.dark,
          () => themeProvider.setThemeMode(ThemeMode.dark),
        ),
        const SizedBox(width: 12),
        _buildThemeOption(
          theme,
          'System',
          Icons.settings_suggest,
          ThemeMode.system,
          themeProvider.themeMode == ThemeMode.system,
          () => themeProvider.setThemeMode(ThemeMode.system),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    ThemeData theme,
    String label,
    IconData icon,
    ThemeMode mode,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected 
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected 
                    ? Colors.white
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeSelector(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.text_decrease,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        Expanded(
          child: Slider(
            value: 1.0, // Default font size
            min: 0.8,
            max: 1.2,
            divisions: 4,
            onChanged: (value) {
              // TODO: Implement font size change
            },
            activeColor: theme.colorScheme.primary,
          ),
        ),
        Icon(
          Icons.text_increase,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(ThemeData theme) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Push Notifications',
            'Receive notifications on your device',
            Icons.notifications,
            Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement push notifications toggle
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Email Notifications',
            'Receive updates via email',
            Icons.email,
            Switch(
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value! ? 'Email notifications enabled' : 'Email notifications disabled'),
                  ),
                );
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Learning Reminders',
            'Daily reminders to continue learning',
            Icons.schedule,
            Switch(
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? 'Learning reminders enabled' : 'Learning reminders disabled'),
                  ),
                );
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(ThemeData theme) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy & Security',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Data Collection',
            'Help improve the app by sharing usage data',
            Icons.analytics,
            Switch(
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? 'Data collection enabled' : 'Data collection disabled'),
                  ),
                );
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Profile Visibility',
            'Make your profile visible to other users',
            Icons.visibility,
            Switch(
              value: false,
              onChanged: (value) {
                // TODO: Implement profile visibility toggle
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Privacy Policy',
            'Read our privacy policy',
            Icons.privacy_tip,
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            isNavigation: true,
            onTap: () {
              _showPrivacyPolicy();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(ThemeData theme) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'App Version',
            '1.0.0 (Build 1)',
            Icons.info,
            const SizedBox.shrink(),
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Terms of Service',
            'Read our terms and conditions',
            Icons.description,
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            isNavigation: true,
            onTap: () {
              _showTermsOfService();
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Contact Support',
            'Get help or report issues',
            Icons.support_agent,
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            isNavigation: true,
            onTap: () {
              // TODO: Open support
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingRow(
            theme,
            'Rate App',
            'Rate us on the app store',
            Icons.star,
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            isNavigation: true,
            onTap: () {
              // TODO: Open app store rating
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    Widget trailing, {
    bool isNavigation = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
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
            trailing
          else
            trailing,
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IGNITIA Terms of Service',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Acceptance of Terms:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'By using IGNITIA, you agree to these terms and conditions.',
              ),
              SizedBox(height: 16),
              Text(
                'User Responsibilities:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Provide accurate information during registration\n'
                '• Use the app for educational purposes only\n'
                '• Respect other users in community features\n'
                '• Do not share inappropriate content',
              ),
              SizedBox(height: 16),
              Text(
                'Service Availability:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• We strive for 99.9% uptime but cannot guarantee uninterrupted service\n'
                '• Features may be updated or modified without notice\n'
                '• We reserve the right to suspend accounts for violations',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
