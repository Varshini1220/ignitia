import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/settings_provider.dart' as sp;

class SettingsPage extends StatelessWidget {
  final List<String> languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Kannada'];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<sp.SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Language Selection
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(settings.language),
            trailing: DropdownButton<String>(
              value: settings.language,
              items: languages.map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              )).toList(),
              onChanged: (value) {
                if (value != null) settings.setLanguage(value);
              },
            ),
          ),
          const Divider(),

          // Privacy Settings
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Allow Data Sharing'),
            trailing: Switch(
              value: settings.allowDataSharing,
              onChanged: settings.setAllowDataSharing,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('Show Online Status'),
            trailing: Switch(
              value: settings.showOnlineStatus,
              onChanged: settings.setShowOnlineStatus,
            ),
          ),
          const Divider(),

          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Enable Notifications'),
            trailing: Switch(
              value: settings.enableNotifications,
              onChanged: settings.setEnableNotifications,
            ),
          ),
          if (settings.enableNotifications) ...[
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Daily Reminders'),
                    trailing: Switch(
                      value: settings.dailyReminders,
                      onChanged: settings.setDailyReminders,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text('Goal Completion Alerts'),
                    trailing: Switch(
                      value: settings.goalCompletionAlerts,
                      onChanged: settings.setGoalCompletionAlerts,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Community Updates'),
                    trailing: Switch(
                      value: settings.communityUpdates,
                      onChanged: settings.setCommunityUpdates,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Divider(),

          // Theme (optional, if you want to add)
          // ListTile(
          //   leading: Icon(Icons.dark_mode),
          //   title: Text('Dark Mode'),
          //   trailing: Switch(
          //     value: themeProvider.isDarkMode,
          //     onChanged: themeProvider.setDarkMode,
          //   ),
          // ),
        ],
      ),
    );
  }
}