import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/auth_provider.dart';
import 'package:ignitia/screens/splash_screen.dart';
import 'package:ignitia/screens/auth/login_screen.dart';
import 'package:ignitia/screens/auth/signup_screen.dart';
import 'package:ignitia/screens/setup/career_setup_screen.dart';
import 'package:ignitia/screens/main/main_navigation.dart';
import 'package:ignitia/screens/dashboard/dashboard_screen.dart';
import 'package:ignitia/screens/roadmap/roadmap_screen.dart';
import 'package:ignitia/screens/resources/resources_screen.dart';
import 'package:ignitia/screens/notifications/notifications_screen.dart';
import 'package:ignitia/screens/placement/placement_screen.dart';
import 'package:ignitia/screens/projects/projects_screen.dart';
import 'package:ignitia/screens/community/community_screen.dart';
import 'package:ignitia/screens/profile/profile_screen.dart';
import 'package:ignitia/screens/profile/edit_profile_screen.dart';
import 'package:ignitia/screens/profile/profile_picture_selection_screen.dart';
import 'package:ignitia/screens/settings/settings_screen.dart';
import 'package:ignitia/screens/chatbot/chatbot_screen.dart';
import 'package:ignitia/utils/app_routes.dart';

/// App router for handling navigation and route management
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      
      case AppRoutes.careerSetup:
        return MaterialPageRoute(builder: (_) => const CareerSetupScreen());
      
      case AppRoutes.home:
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      
      case AppRoutes.roadmap:
        return MaterialPageRoute(builder: (_) => const RoadmapScreen());
      
      case AppRoutes.resources:
        return MaterialPageRoute(builder: (_) => const ResourcesScreen());
      
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      case AppRoutes.placement:
        return MaterialPageRoute(builder: (_) => const PlacementScreen());
      
      case AppRoutes.projects:
        return MaterialPageRoute(builder: (_) => const ProjectsScreen());
      
      case AppRoutes.community:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());
      
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case AppRoutes.profilePictureSelection:
        return MaterialPageRoute(builder: (_) => const ProfilePictureSelectionScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      case AppRoutes.chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Check if user is authenticated and redirect accordingly
  static Widget getInitialRoute(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated) {
      final user = authProvider.currentUser;
      if (user?.selectedSector.isEmpty == true || user?.careerGoal.isEmpty == true) {
        return const CareerSetupScreen();
      }
      return const MainNavigation();
    }
    
    return const LoginScreen();
  }
}
