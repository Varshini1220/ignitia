import 'package:flutter/material.dart';
import 'package:ignitia/widgets/common/custom_card.dart';
import 'package:ignitia/widgets/common/custom_button.dart';

/// Placement and exam preparation hub
class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  State<PlacementScreen> createState() => _PlacementScreenState();
}

class _PlacementScreenState extends State<PlacementScreen>
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

  void _showMockInterviewsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mock Interviews'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Practice with AI-powered mock interviews:'),
            SizedBox(height: 16),
            Text('• Technical interviews for your field'),
            Text('• Behavioral interview questions'),
            Text('• Real-time feedback and scoring'),
            Text('• Industry-specific scenarios'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mock interview feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Start Interview'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Placement & Exam Prep'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add search functionality
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildHeader(theme),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildQuickActions(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Mock Interviews Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildMockInterviews(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Resume Templates Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildResumeTemplates(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Aptitude Tests Section
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildAptitudeTests(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return CustomCard(
      isGradient: true,
      gradientColors: const [
        Color(0xFF2196F3),
        Color(0xFF21CBF3),
      ],
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.work_outline,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get Job Ready',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prepare for interviews, build your resume, and ace aptitude tests',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
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
                  _showMockInterviewsDialog();
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.video_call,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mock Interviews',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Practice with AI',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                  // TODO: Navigate to resume builder
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.description,
                      size: 32,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Resume Builder',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create & Download',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                  // TODO: Navigate to aptitude tests
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 32,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aptitude Tests',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Practice Tests',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                  // TODO: Navigate to interview tips
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      size: 32,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Interview Tips',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Expert Advice',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
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

  Widget _buildMockInterviews(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Mock Interviews',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // TODO: View all mock interviews
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._getMockInterviewData().map((interview) => _buildInterviewCard(theme, interview)).toList(),
      ],
    );
  }

  Widget _buildInterviewCard(ThemeData theme, Map<String, dynamic> interview) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        // TODO: Start mock interview
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: interview['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              interview['icon'],
              color: interview['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  interview['title'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  interview['description'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      interview['duration'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.people,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      interview['difficulty'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.play_arrow,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildResumeTemplates(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Resume Templates',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // TODO: View all templates
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getResumeTemplateData().map((template) => _buildTemplateCard(theme, template)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCard(ThemeData theme, Map<String, dynamic> template) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: CustomCard(
        onTap: () {
          // TODO: Use template
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: template['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  template['icon'],
                  size: 48,
                  color: template['color'],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              template['title'],
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              template['description'],
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  template['rating'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  template['isFree'] ? 'FREE' : 'PREMIUM',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: template['isFree'] ? Colors.green : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAptitudeTests(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Aptitude Tests',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // TODO: View all tests
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._getAptitudeTestData().map((test) => _buildTestCard(theme, test)).toList(),
      ],
    );
  }

  Widget _buildTestCard(ThemeData theme, Map<String, dynamic> test) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        // TODO: Start test
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: test['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              test['icon'],
              color: test['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test['title'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  test['description'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${test['questions']} questions',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      test['duration'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomButton(
            text: 'Start',
            onPressed: () {
              // TODO: Start test
            },
            size: ButtonSize.small,
            icon: Icons.play_arrow,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockInterviewData() {
    return [
      {
        'title': 'Technical Interview - Software Engineer',
        'description': 'Practice coding problems and system design questions',
        'duration': '45 min',
        'difficulty': 'Advanced',
        'icon': Icons.code,
        'color': Colors.blue,
      },
      {
        'title': 'Behavioral Interview',
        'description': 'Practice common behavioral questions and STAR method',
        'duration': '30 min',
        'difficulty': 'Intermediate',
        'icon': Icons.psychology,
        'color': Colors.green,
      },
      {
        'title': 'Data Science Interview',
        'description': 'Statistics, machine learning, and data analysis questions',
        'duration': '60 min',
        'difficulty': 'Advanced',
        'icon': Icons.analytics,
        'color': Colors.orange,
      },
    ];
  }

  List<Map<String, dynamic>> _getResumeTemplateData() {
    return [
      {
        'title': 'Modern Professional',
        'description': 'Clean and modern design for tech professionals',
        'rating': '4.8',
        'isFree': true,
        'icon': Icons.description,
        'color': Colors.blue,
      },
      {
        'title': 'Creative Designer',
        'description': 'Eye-catching design for creative professionals',
        'rating': '4.6',
        'isFree': false,
        'icon': Icons.palette,
        'color': Colors.purple,
      },
      {
        'title': 'Executive Summary',
        'description': 'Professional template for senior positions',
        'rating': '4.9',
        'isFree': false,
        'icon': Icons.business,
        'color': Colors.green,
      },
    ];
  }

  List<Map<String, dynamic>> _getAptitudeTestData() {
    return [
      {
        'title': 'Quantitative Aptitude',
        'description': 'Mathematics, algebra, geometry, and numerical reasoning',
        'questions': 50,
        'duration': '60 min',
        'icon': Icons.calculate,
        'color': Colors.blue,
      },
      {
        'title': 'Verbal Reasoning',
        'description': 'Reading comprehension, vocabulary, and grammar',
        'questions': 40,
        'duration': '45 min',
        'icon': Icons.menu_book,
        'color': Colors.green,
      },
      {
        'title': 'Logical Reasoning',
        'description': 'Pattern recognition, sequences, and logical puzzles',
        'questions': 35,
        'duration': '40 min',
        'icon': Icons.psychology,
        'color': Colors.orange,
      },
      {
        'title': 'Technical Aptitude',
        'description': 'Programming concepts, algorithms, and data structures',
        'questions': 60,
        'duration': '90 min',
        'icon': Icons.computer,
        'color': Colors.purple,
      },
    ];
  }
}
