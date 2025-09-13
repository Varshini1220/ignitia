import 'package:flutter/material.dart';

/// Provider for managing profile picture options and selection
class ProfilePictureProvider extends ChangeNotifier {
  String _selectedProfilePicture = '';
  
  String get selectedProfilePicture => _selectedProfilePicture;

  /// Collection of beautiful girl profile pictures
  static const List<Map<String, String>> profilePictures = [
    {
      'id': 'ghibli_girl_1',
      'name': 'Anime Girl 1',
      'url': 'https://i.pinimg.com/564x/f3/32/19/f332192b2090f437ca9f49c1002287b6.jpg',
      'category': 'Anime',
    },
    {
      'id': 'ghibli_girl_2',
      'name': 'Anime Girl 2',
      'url': 'https://i.pinimg.com/564x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
      'category': 'Anime',
    },
    {
      'id': 'ghibli_girl_3',
      'name': 'Anime Girl 3',
      'url': 'https://i.pinimg.com/564x/a6/58/32/a65832155622ac173337874f02b543ce.jpg',
      'category': 'Anime',
    },
    {
      'id': 'cute_girl_1',
      'name': 'Cute Girl 1',
      'url': 'https://i.pinimg.com/564x/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg',
      'category': 'Cute',
    },
    {
      'id': 'cute_girl_2',
      'name': 'Cute Girl 2',
      'url': 'https://i.pinimg.com/564x/2d/d2/ba/2dd2ba49140d24f2f70a5bbe82bb1326.jpg',
      'category': 'Cute',
    },
    {
      'id': 'aesthetic_girl_1',
      'name': 'Aesthetic Girl 1',
      'url': 'https://i.pinimg.com/564x/4f/a3/7c/4fa37c8b5d6e7f8a9b0c1d2e3f4g5h6i.jpg',
      'category': 'Aesthetic',
    },
    {
      'id': 'aesthetic_girl_2',
      'name': 'Aesthetic Girl 2',
      'url': 'https://i.pinimg.com/564x/7e/8f/9a/7e8f9a1b2c3d4e5f6a7b8c9d0e1f2g3h.jpg',
      'category': 'Aesthetic',
    },
    {
      'id': 'kawaii_girl_1',
      'name': 'Kawaii Girl 1',
      'url': 'https://i.pinimg.com/564x/1a/2b/3c/1a2b3c4d5e6f7a8b9c0d1e2f3g4h5i6j.jpg',
      'category': 'Kawaii',
    },
    {
      'id': 'kawaii_girl_2',
      'name': 'Kawaii Girl 2',
      'url': 'https://i.pinimg.com/564x/5d/6e/7f/5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0g.jpg',
      'category': 'Kawaii',
    },
    {
      'id': 'stylish_girl_1',
      'name': 'Stylish Girl 1',
      'url': 'https://i.pinimg.com/564x/9g/8h/7i/9g8h7i6a5b4c3d2e1f0a9b8c7d6e5f4g.jpg',
      'category': 'Stylish',
    },
    {
      'id': 'stylish_girl_2',
      'name': 'Stylish Girl 2',
      'url': 'https://i.pinimg.com/564x/3w/2x/1y/3w2x1y0a9b8c7d6e5f4a3b2c1d0e9f8g.jpg',
      'category': 'Stylish',
    },
    {
      'id': 'dreamy_girl_1',
      'name': 'Dreamy Girl 1',
      'url': 'https://i.pinimg.com/564x/6k/7l/8m/6k7l8m9a0b1c2d3e4f5a6b7c8d9e0f1g.jpg',
      'category': 'Dreamy',
    },
    {
      'id': 'modern_girl_1',
      'name': 'Modern Girl 1',
      'url': 'https://i.pinimg.com/564x/c4/d5/e6/c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9.jpg',
      'category': 'Modern',
    },
    {
      'id': 'modern_girl_2',
      'name': 'Modern Girl 2',
      'url': 'https://i.pinimg.com/564x/g0/h1/i2/g0h1i2j3k4l5m6n7o8p9q0r1s2t3u4v5.jpg',
      'category': 'Modern',
    },
  ];

  /// Get profile pictures by category
  List<Map<String, String>> getProfilePicturesByCategory(String category) {
    return profilePictures.where((pic) => pic['category'] == category).toList();
  }

  /// Get all categories
  List<String> getCategories() {
    return profilePictures.map((pic) => pic['category']!).toSet().toList();
  }

  /// Set selected profile picture
  void setProfilePicture(String pictureUrl) {
    _selectedProfilePicture = pictureUrl;
    notifyListeners();
  }

  /// Get profile picture by ID
  Map<String, String>? getProfilePictureById(String id) {
    try {
      return profilePictures.firstWhere((pic) => pic['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get random profile picture
  Map<String, String> getRandomProfilePicture() {
    final random = DateTime.now().millisecondsSinceEpoch % profilePictures.length;
    return profilePictures[random];
  }
}
