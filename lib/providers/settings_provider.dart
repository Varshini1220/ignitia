import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'English';
  bool _allowDataSharing = false;
  bool _showOnlineStatus = true;
  bool _enableNotifications = true;
  bool _dailyReminders = true;
  bool _goalCompletionAlerts = true;
  bool _communityUpdates = true;

  String get language => _language;
  bool get allowDataSharing => _allowDataSharing;
  bool get showOnlineStatus => _showOnlineStatus;
  bool get enableNotifications => _enableNotifications;
  bool get dailyReminders => _dailyReminders;
  bool get goalCompletionAlerts => _goalCompletionAlerts;
  bool get communityUpdates => _communityUpdates;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = prefs.getString('language') ?? 'English';
    _allowDataSharing = prefs.getBool('allowDataSharing') ?? false;
    _showOnlineStatus = prefs.getBool('showOnlineStatus') ?? true;
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    _dailyReminders = prefs.getBool('dailyReminders') ?? true;
    _goalCompletionAlerts = prefs.getBool('goalCompletionAlerts') ?? true;
    _communityUpdates = prefs.getBool('communityUpdates') ?? true;
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> setAllowDataSharing(bool value) async {
    _allowDataSharing = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allowDataSharing', value);
    notifyListeners();
  }

  Future<void> setShowOnlineStatus(bool value) async {
    _showOnlineStatus = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnlineStatus', value);
    notifyListeners();
  }

  Future<void> setEnableNotifications(bool value) async {
    _enableNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications', value);
    notifyListeners();
  }

  Future<void> setDailyReminders(bool value) async {
    _dailyReminders = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyReminders', value);
    notifyListeners();
  }

  Future<void> setGoalCompletionAlerts(bool value) async {
    _goalCompletionAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('goalCompletionAlerts', value);
    notifyListeners();
  }

  Future<void> setCommunityUpdates(bool value) async {
    _communityUpdates = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('communityUpdates', value);
    notifyListeners();
  }
}