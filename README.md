# IGNITIA – Universal Student Career & Learning Companion

A comprehensive Flutter 3 mobile application designed to guide students through their career and learning journey with personalized roadmaps, resources, and community support.

## 🚀 Features

### Core Functionality
- **Authentication System**: Email/Google login, guest mode, and secure signup
- **Career Setup**: Dynamic career goal selection based on sector and year level
- **Personalized Roadmap**: AI-generated learning paths with progress tracking
- **Resource Library**: Curated courses, books, videos, and articles with filtering
- **Project Portfolio**: Mini-projects and skill-building exercises
- **Community Platform**: Peer motivation, milestone sharing, and discussion boards
- **AI Learning Assistant**: Intelligent chatbot for guidance and support
- **Placement Preparation**: Mock interviews, resume templates, and aptitude tests
- **Progress Tracking**: Comprehensive analytics and achievement system

### UI/UX Features
- **Material Design 3**: Modern, accessible, and beautiful interface
- **Dark/Light Theme**: System-aware theme switching
- **Responsive Design**: Optimized for phones and tablets
- **Smooth Animations**: Engaging transitions and micro-interactions
- **Accessibility**: Screen reader support and high contrast options

## 📱 Screens

1. **Splash Screen** - App introduction with loading animation
2. **Login/Signup** - Authentication with multiple options
3. **Career Setup** - Initial configuration and preference selection
4. **Dashboard** - Overview of progress and quick actions
5. **Roadmap** - Step-by-step learning path with status tracking
6. **Resources** - Learning materials with advanced filtering
7. **Projects** - Portfolio building and skill development
8. **Community** - Social features and peer interaction
9. **Notifications** - Reminders and progress alerts
10. **Placement Prep** - Interview and exam preparation tools
11. **Profile & Settings** - User management and preferences
12. **AI Chatbot** - Intelligent learning assistant

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **UI Components**: Material Design 3
- **Navigation**: Custom router with named routes
- **Animations**: Custom animations and transitions
- **Theming**: Dynamic theme system with dark/light modes
- **Architecture**: Clean architecture with separation of concerns

## 📁 Project Structure

```
lib/
├── main.dart
├── models/                 # Data models
│   ├── user_model.dart
│   ├── roadmap_model.dart
│   └── notification_model.dart
├── providers/              # State management
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   ├── roadmap_provider.dart
│   └── theme_provider.dart
├── screens/                # UI screens
│   ├── splash_screen.dart
│   ├── auth/
│   ├── setup/
│   ├── main/
│   ├── dashboard/
│   ├── roadmap/
│   ├── resources/
│   ├── projects/
│   ├── community/
│   ├── notifications/
│   ├── placement/
│   ├── profile/
│   ├── settings/
│   └── chatbot/
├── widgets/                # Reusable components
│   └── common/
│       ├── custom_button.dart
│       ├── custom_card.dart
│       └── custom_text_field.dart
├── navigation/             # Navigation logic
│   └── app_router.dart
└── utils/                  # Utilities
    ├── app_theme.dart
    └── app_routes.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code
- Android SDK / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pathpilot.git
   cd pathpilot
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **Update app configuration** in `lib/main.dart`
2. **Configure API endpoints** in provider files
3. **Add your app icons** in `assets/images/`
4. **Update app name** in `pubspec.yaml`

## 🎨 Customization

### Theming
- Modify colors in `lib/utils/app_theme.dart`
- Add custom gradients and decorations
- Update typography and spacing

### Content
- Update career sectors in `lib/providers/user_provider.dart`
- Modify roadmap templates in `lib/providers/roadmap_provider.dart`
- Customize AI responses in `lib/screens/chatbot/chatbot_screen.dart`

### Features
- Add new screens by extending the router
- Implement new providers for additional state management
- Create custom widgets in the `widgets/` directory

## 📱 Screenshots

*Screenshots would be added here showing the app's interface*

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Community contributors and testers
- All the students who inspired this project

## 📞 Support

For support, email support@pathpilot.com or join our community discussions.

---

**IGNITIA** - Empowering students to navigate their career journey with confidence and clarity. 🎓✨
