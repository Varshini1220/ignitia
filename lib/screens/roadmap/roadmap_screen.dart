import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/roadmap_provider.dart';
import 'package:ignitia/widgets/common/custom_card.dart';
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/models/roadmap_model.dart';
import 'package:ignitia/utils/app_routes.dart';

/// Roadmap screen showing step-by-step career progression
class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen>
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

  Future<void> _updateStepStatus(RoadmapStep step, String newStatus) async {
    final roadmapProvider = Provider.of<RoadmapProvider>(context, listen: false);
    await roadmapProvider.updateStepStatus(step.id, newStatus);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'not started':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _showStepDetails(BuildContext context, RoadmapStep step) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          final theme = Theme.of(context);
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(step.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            step.status,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(step.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Description',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Resources (${step.resources.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...step.resources.map((resourceId) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.book,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Resource: $resourceId',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ],
                          ),
                        )).toList(),
                        const SizedBox(height: 24),
                        Text(
                          'Mini Projects (${step.miniProjects.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...step.miniProjects.map((projectId) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.code,
                                size: 20,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Project: $projectId',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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

    final roadmapSteps = roadmapProvider.roadmapSteps;
    final progressPercentage = roadmapProvider.getProgressPercentage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Roadmap'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add filter/sort options
            },
            icon: const Icon(Icons.filter_list),
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
              child: _buildProgressOverview(theme, progressPercentage),
            ),
            
            const SizedBox(height: 24),
            
            // Roadmap Steps
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildRoadmapSteps(theme, roadmapSteps),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(ThemeData theme, double progress) {
    return CustomCard(
      isGradient: true,
      gradientColors: const [
        Color(0xFF6750A4),
        Color(0xFF9C27B0),
      ],
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Learning Journey',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toInt()}% Complete',
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

  Widget _buildRoadmapSteps(ThemeData theme, List<RoadmapStep> steps) {
    if (steps.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.route,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No roadmap steps available',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your career setup to generate your personalized roadmap',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Steps',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return _buildRoadmapStep(theme, step, index, steps.length);
        }).toList(),
      ],
    );
  }

  Widget _buildRoadmapStep(ThemeData theme, RoadmapStep step, int index, int totalSteps) {
    final isCompleted = step.status == 'Completed';
    final isInProgress = step.status == 'In Progress';
    final isNotStarted = step.status == 'Not Started';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Number and Connector
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green
                      : isInProgress
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? Colors.green
                        : isInProgress
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : Text(
                          '${index + 1}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isInProgress
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (index < totalSteps - 1)
                Container(
                  width: 2,
                  height: 60,
                  color: isCompleted
                      ? Colors.green
                      : theme.colorScheme.surfaceVariant,
                ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Step Content
          Expanded(
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          step.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? Colors.green
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      _buildStatusChip(theme, step.status),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    step.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  
                  if (step.deadline != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Deadline: ${_formatDeadline(step.deadline!)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  if (step.resources.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Resources:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: step.resources.map((resource) => Chip(
                        label: Text(
                          resource,
                          style: theme.textTheme.bodySmall,
                        ),
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        side: BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      )).toList(),
                    ),
                  ],
                  
                  if (step.miniProjects.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Mini Projects:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: step.miniProjects.map((project) => Chip(
                        label: Text(
                          project,
                          style: theme.textTheme.bodySmall,
                        ),
                        backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                        side: BorderSide(
                          color: theme.colorScheme.secondary.withOpacity(0.3),
                        ),
                      )).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  Row(
                    children: [
                      if (isNotStarted)
                        CustomButton(
                          text: 'Start',
                          onPressed: () => _updateStepStatus(step, 'In Progress'),
                          size: ButtonSize.small,
                          icon: Icons.play_arrow,
                        ),
                      if (isInProgress) ...[
                        CustomButton(
                          text: 'Mark Complete',
                          onPressed: () => _updateStepStatus(step, 'Completed'),
                          size: ButtonSize.small,
                          icon: Icons.check,
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                          text: 'View Resources',
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.resources);
                          },
                          type: ButtonType.outline,
                          size: ButtonSize.small,
                        ),
                      ],
                      if (isCompleted)
                        CustomButton(
                          text: 'View Details',
                          onPressed: () {
                            _showStepDetails(context, step);
                          },
                          type: ButtonType.outline,
                          size: ButtonSize.small,
                        ),
                    ],
                  ),
                ],
              ),
            ),
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

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference < 0) {
      return 'Overdue';
    } else if (difference < 7) {
      return '$difference days';
    } else {
      return '${(difference / 7).floor()} weeks';
    }
  }
}
