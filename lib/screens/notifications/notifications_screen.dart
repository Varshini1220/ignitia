import 'package:flutter/material.dart';
import 'package:ignitia/widgets/common/custom_card.dart';
import 'package:ignitia/widgets/common/custom_button.dart';

/// Notifications screen for reminders and alerts
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _dailyReminders = true;
  bool _weeklyReminders = true;
  bool _progressAlerts = true;
  bool _motivationalNudges = true;
  bool _deadlineAlerts = true;

  // Mock notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Daily Learning Reminder',
      'message': 'Time to continue your journey! Complete your next roadmap step.',
      'type': 'reminder',
      'time': '9:00 AM',
      'isRead': false,
      'isEnabled': true,
    },
    {
      'id': '2',
      'title': 'Progress Update',
      'message': 'Great job! You\'ve completed 3 projects this week.',
      'type': 'progress',
      'time': '2:30 PM',
      'isRead': true,
      'isEnabled': true,
    },
    {
      'id': '3',
      'title': 'Motivational Tip',
      'message': 'Success is the sum of small efforts repeated day in and day out.',
      'type': 'motivational',
      'time': '8:00 AM',
      'isRead': false,
      'isEnabled': true,
    },
    {
      'id': '4',
      'title': 'Deadline Alert',
      'message': 'You have 2 days left to complete "Foundation Skills" step.',
      'type': 'deadline',
      'time': '6:00 PM',
      'isRead': false,
      'isEnabled': true,
    },
    {
      'id': '5',
      'title': 'Weekly Summary',
      'message': 'Your weekly learning summary is ready. Check your progress!',
      'type': 'weekly',
      'time': '7:00 PM',
      'isRead': true,
      'isEnabled': true,
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          if (unreadCount > 0)
            CustomButton(
              text: 'Mark All Read',
              onPressed: _markAllAsRead,
              type: ButtonType.text,
              size: ButtonSize.small,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildNotificationSettings(theme),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications List
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildNotificationsList(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(ThemeData theme) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Notification Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Daily Reminders
          _buildSettingRow(
            theme,
            'Daily Learning Reminders',
            'Get reminded to study every day',
            _dailyReminders,
            (value) => setState(() => _dailyReminders = value),
            Icons.schedule,
          ),
          
          const SizedBox(height: 16),
          
          // Weekly Reminders
          _buildSettingRow(
            theme,
            'Weekly Progress Updates',
            'Receive weekly summaries of your progress',
            _weeklyReminders,
            (value) => setState(() => _weeklyReminders = value),
            Icons.calendar_today,
          ),
          
          const SizedBox(height: 16),
          
          // Progress Alerts
          _buildSettingRow(
            theme,
            'Progress Alerts',
            'Get notified when you complete milestones',
            _progressAlerts,
            (value) => setState(() => _progressAlerts = value),
            Icons.trending_up,
          ),
          
          const SizedBox(height: 16),
          
          // Motivational Nudges
          _buildSettingRow(
            theme,
            'Motivational Tips',
            'Receive daily motivational quotes and tips',
            _motivationalNudges,
            (value) => setState(() => _motivationalNudges = value),
            Icons.lightbulb,
          ),
          
          const SizedBox(height: 16),
          
          // Deadline Alerts
          _buildSettingRow(
            theme,
            'Deadline Alerts',
            'Get reminded about upcoming deadlines',
            _deadlineAlerts,
            (value) => setState(() => _deadlineAlerts = value),
            Icons.warning,
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
    IconData icon,
  ) {
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
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildNotificationsList(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Notifications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${_notifications.where((n) => !n['isRead']).length} unread',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._notifications.map((notification) => _buildNotificationCard(theme, notification)).toList(),
      ],
    );
  }

  Widget _buildNotificationCard(ThemeData theme, Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;
    
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Notification Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getTypeColor(type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTypeIcon(type),
              color: _getTypeColor(type),
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  notification['time'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Actions
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'mark_read') {
                _markAsRead(notification['id']);
              } else if (value == 'delete') {
                _deleteNotification(notification['id']);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.check, size: 16),
                    SizedBox(width: 8),
                    Text('Mark as Read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
            child: Icon(
              Icons.more_vert,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'reminder':
        return Colors.blue;
      case 'progress':
        return Colors.green;
      case 'motivational':
        return Colors.orange;
      case 'deadline':
        return Colors.red;
      case 'weekly':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'reminder':
        return Icons.schedule;
      case 'progress':
        return Icons.trending_up;
      case 'motivational':
        return Icons.lightbulb;
      case 'deadline':
        return Icons.warning;
      case 'weekly':
        return Icons.calendar_today;
      default:
        return Icons.notifications;
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
  }
}
