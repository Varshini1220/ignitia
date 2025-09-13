import 'package:flutter/material.dart';
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/widgets/common/custom_text_field.dart';

/// AI Chatbot screen for learning guidance and help
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _addWelcomeMessage();
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
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _clearChatHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to clear all chat messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _addWelcomeMessage(); // Re-add welcome message
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat history cleared!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _addWelcomeMessage() {
    _messages.add({
      'text': 'Hi! I\'m your AI learning companion. I can help you with:\n\n• Career guidance and roadmap planning\n• Learning resources and recommendations\n• Project ideas and skill development\n• Interview preparation tips\n• Study strategies and motivation\n\nWhat would you like to know?',
      'isUser': false,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    _messages.add({
      'text': message,
      'isUser': true,
      'timestamp': DateTime.now(),
    });

    _messageController.clear();
    setState(() {
      _isTyping = true;
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 2));
    
    final response = _generateAIResponse(message);
    _messages.add({
      'text': response,
      'isUser': false,
      'timestamp': DateTime.now(),
    });

    setState(() {
      _isTyping = false;
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _generateAIResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('career') || lowerMessage.contains('job')) {
      return 'Great question about career planning! Here are some key steps:\n\n1. **Self-Assessment**: Identify your interests, skills, and values\n2. **Research**: Explore different career paths and requirements\n3. **Skill Development**: Focus on building relevant skills\n4. **Networking**: Connect with professionals in your field\n5. **Portfolio Building**: Create projects that showcase your abilities\n\nWould you like me to help you with any specific aspect of career planning?';
    } else if (lowerMessage.contains('learn') || lowerMessage.contains('study')) {
      return 'Learning effectively is crucial for success! Here are some proven strategies:\n\n📚 **Active Learning**: Practice coding, build projects, teach others\n⏰ **Time Management**: Use techniques like Pomodoro (25-min focused sessions)\n🎯 **Goal Setting**: Break large goals into smaller, achievable milestones\n🔄 **Spaced Repetition**: Review material at increasing intervals\n👥 **Community**: Join study groups and online communities\n\nWhat specific skill or subject are you looking to learn?';
    } else if (lowerMessage.contains('project') || lowerMessage.contains('portfolio')) {
      return 'Building a strong portfolio is essential! Here are some project ideas:\n\n**Beginner Projects:**\n• Personal website\n• To-do list app\n• Calculator\n• Weather app\n\n**Intermediate Projects:**\n• E-commerce website\n• Social media dashboard\n• API integration project\n• Mobile app\n\n**Advanced Projects:**\n• Full-stack application\n• Machine learning model\n• Open-source contribution\n• Complex web application\n\nWhat type of project interests you most?';
    } else if (lowerMessage.contains('interview') || lowerMessage.contains('prepare')) {
      return 'Interview preparation is key to landing your dream job! Here\'s how to prepare:\n\n**Technical Preparation:**\n• Practice coding problems on platforms like LeetCode\n• Review fundamental concepts\n• Prepare for system design questions\n\n**Behavioral Preparation:**\n• Use the STAR method (Situation, Task, Action, Result)\n• Prepare examples of leadership, teamwork, and problem-solving\n\n**General Tips:**\n• Research the company and role\n• Prepare thoughtful questions\n• Practice with mock interviews\n• Dress professionally and arrive early\n\nWould you like specific advice for any type of interview?';
    } else if (lowerMessage.contains('motivation') || lowerMessage.contains('stuck')) {
      return 'It\'s completely normal to feel stuck sometimes! Here are some ways to stay motivated:\n\n💪 **Remember Your Why**: Connect back to your long-term goals\n🎯 **Small Wins**: Celebrate every small achievement\n👥 **Community**: Connect with others on similar journeys\n📈 **Progress Tracking**: Keep a learning journal\n🔄 **Change It Up**: Try different learning methods or projects\n⏰ **Take Breaks**: Rest is important for long-term success\n\nRemember, every expert was once a beginner. What specific challenge are you facing?';
    } else {
      return 'That\'s an interesting question! I\'m here to help with your learning journey. I can assist with:\n\n• Career guidance and planning\n• Learning strategies and resources\n• Project ideas and portfolio building\n• Interview preparation\n• Study motivation and tips\n\nCould you be more specific about what you\'d like help with? I\'m here to support your learning goals!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Learning Assistant'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _clearChatHistory();
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return _buildTypingIndicator(theme);
                    }
                    return _buildMessageBubble(theme, _messages[index]);
                  },
                ),
              ),
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _messageController,
                    hint: 'Type your message...',
                    maxLines: 3,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: 'Send',
                  onPressed: _sendMessage,
                  icon: Icons.send,
                  size: ButtonSize.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ThemeData theme, Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    final timestamp = message['timestamp'] as DateTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(
                Icons.smart_toy,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser 
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isUser 
                          ? Colors.white.withOpacity(0.7)
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondary,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primary,
            child: const Icon(
              Icons.smart_toy,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(theme, 0),
                const SizedBox(width: 4),
                _buildTypingDot(theme, 1),
                const SizedBox(width: 4),
                _buildTypingDot(theme, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(ThemeData theme, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = index * 0.2;
        final animationValue = (_animationController.value - delay).clamp(0.0, 1.0);
        final opacity = (1.0 - animationValue) * 0.5 + 0.5;
        
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
