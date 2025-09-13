import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/roadmap_provider.dart';
import 'package:ignitia/widgets/common/custom_card.dart';
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/models/roadmap_model.dart';

/// Projects screen for portfolio building and skill development
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';

  final List<String> _categories = ['All', 'Foundation', 'Intermediate', 'Advanced', 'Portfolio'];
  final List<String> _difficulties = ['All', 'Beginner', 'Intermediate', 'Advanced'];

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

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Project'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This feature will allow you to create custom projects.'),
            SizedBox(height: 16),
            Text(
              'For now, you can explore the suggested projects below or check out the roadmap for project ideas!',
              style: TextStyle(fontSize: 14),
            ),
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
              // Navigate to roadmap for project ideas
              Navigator.pushNamed(context, '/roadmap');
            },
            child: const Text('View Roadmap'),
          ),
        ],
      ),
    );
  }

  List<Project> _getFilteredProjects() {
    final roadmapProvider = Provider.of<RoadmapProvider>(context, listen: false);
    var projects = roadmapProvider.projects;

    // Apply category filter
    if (_selectedCategory != 'All') {
      projects = projects.where((project) => project.category == _selectedCategory).toList();
    }

    // Apply difficulty filter
    if (_selectedDifficulty != 'All') {
      projects = projects.where((project) => project.difficulty == _selectedDifficulty).toList();
    }

    return projects;
  }

  Future<void> _updateProjectStatus(Project project, String newStatus) async {
    final roadmapProvider = Provider.of<RoadmapProvider>(context, listen: false);
    await roadmapProvider.updateProjectStatus(project.id, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roadmapProvider = Provider.of<RoadmapProvider>(context);
    
    if (roadmapProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredProjects = _getFilteredProjects();
    final completedProjects = roadmapProvider.getCompletedProjectsCount();
    final totalProjects = roadmapProvider.projects.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects & Portfolio'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAddProjectDialog();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Overview
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildProgressOverview(theme, completedProjects, totalProjects),
            ),
            
            const SizedBox(height: 24),
            
            // Filter Chips
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildFilterChips(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Projects List
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildProjectsList(theme, filteredProjects),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(ThemeData theme, int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;
    
    return CustomCard(
      isGradient: true,
      gradientColors: const [
        Color(0xFF4CAF50),
        Color(0xFF8BC34A),
      ],
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.work,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Progress',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completed of $total projects completed',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter Projects',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Category Filter
              ..._categories.map((category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Difficulty Filter
              ..._difficulties.map((difficulty) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(difficulty),
                  selected: _selectedDifficulty == difficulty,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsList(ThemeData theme, List<Project> projects) {
    if (projects.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No projects found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or check back later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${projects.length} Projects Found',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...projects.map((project) => _buildProjectCard(theme, project)).toList(),
      ],
    );
  }

  Widget _buildProjectCard(ThemeData theme, Project project) {
    final isCompleted = project.status == 'Completed';
    final isInProgress = project.status == 'In Progress';
    final isNotStarted = project.status == 'Not Started';

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Project Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(project.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.work,
                  color: _getDifficultyColor(project.difficulty),
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Title and Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          project.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(project.difficulty).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            project.difficulty,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getDifficultyColor(project.difficulty),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status Chip
              _buildStatusChip(theme, project.status),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            project.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // Skills and Duration
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${project.estimatedHours}h',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.code,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${project.skills.length} skills',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              if (isCompleted && project.completedAt != null)
                Text(
                  'Completed ${_formatDate(project.completedAt!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          
          if (project.skills.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: project.skills.take(3).map((skill) => Chip(
                label: Text(
                  skill,
                  style: theme.textTheme.bodySmall,
                ),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                side: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              )).toList(),
            ),
            if (project.skills.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${project.skills.length - 3} more skills',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
          ],
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              if (isNotStarted)
                CustomButton(
                  text: 'Start Project',
                  onPressed: () => _updateProjectStatus(project, 'In Progress'),
                  size: ButtonSize.small,
                  icon: Icons.play_arrow,
                ),
              if (isInProgress) ...[
                CustomButton(
                  text: 'Mark Complete',
                  onPressed: () => _updateProjectStatus(project, 'Completed'),
                  size: ButtonSize.small,
                  icon: Icons.check,
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'View Details',
                  onPressed: () {
                    _showProjectDetails(theme, project);
                  },
                  type: ButtonType.outline,
                  size: ButtonSize.small,
                ),
              ],
              if (isCompleted)
                CustomButton(
                  text: 'View Details',
                  onPressed: () {
                    _showProjectDetails(theme, project);
                  },
                  type: ButtonType.outline,
                  size: ButtonSize.small,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme, String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Completed':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'In Progress':
        backgroundColor = theme.colorScheme.primary.withOpacity(0.1);
        textColor = theme.colorScheme.primary;
        icon = Icons.play_circle;
        break;
      default:
        backgroundColor = theme.colorScheme.surfaceVariant;
        textColor = theme.colorScheme.onSurface.withOpacity(0.6);
        icon = Icons.schedule;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${(difference / 7).floor()} weeks ago';
    }
  }

  void _showProjectDetails(ThemeData theme, Project project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(project.difficulty).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            project.difficulty,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getDifficultyColor(project.difficulty),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          project.category,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      project.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Skills to Learn:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: project.skills.map((skill) => Chip(
                        label: Text(skill),
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        side: BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estimated Time: ${project.estimatedHours} hours',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomButton(
                      text: project.status == 'Not Started' ? 'Start Project' : 'Continue Project',
                      onPressed: () {
                        Navigator.pop(context);
                        if (project.status == 'Not Started') {
                          _updateProjectStatus(project, 'In Progress');
                        }
                      },
                      size: ButtonSize.large,
                      icon: project.status == 'Not Started' ? Icons.play_arrow : Icons.work,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
