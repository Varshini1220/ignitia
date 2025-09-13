import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/auth_provider.dart';
import 'package:ignitia/providers/user_provider.dart';
import 'package:ignitia/providers/roadmap_provider.dart';
import 'package:ignitia/providers/theme_provider.dart';
import 'package:ignitia/providers/settings_provider.dart';
import 'package:ignitia/providers/profile_picture_provider.dart';
import 'package:ignitia/screens/splash_screen.dart';
import 'package:ignitia/navigation/app_router.dart';
import 'package:ignitia/utils/app_theme.dart';
import 'package:ignitia/utils/app_routes.dart';

void main() {
  runApp(const IgnitiaApp());
}

class IgnitiaApp extends StatelessWidget {
  const IgnitiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RoadmapProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ProfilePictureProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'IGNITIA',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
