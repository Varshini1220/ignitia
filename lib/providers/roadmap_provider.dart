import 'package:flutter/material.dart';
import 'package:ignitia/models/roadmap_model.dart';

/// Roadmap provider for managing career roadmap and progress
class RoadmapProvider extends ChangeNotifier {
  List<RoadmapStep> _roadmapSteps = [];
  List<Resource> _resources = [];
  List<Project> _projects = [];
  bool _isLoading = false;
  String? _error;

  List<RoadmapStep> get roadmapSteps => _roadmapSteps;
  List<Resource> get resources => _resources;
  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Generate roadmap based on user preferences
  Future<void> generateRoadmap({
    required String sector,
    required String careerGoal,
    required String yearLevel,
    required bool isPaidUser,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      _roadmapSteps = _createRoadmapSteps(sector, careerGoal, yearLevel, isPaidUser);
      _resources = _createResources(sector, careerGoal, isPaidUser);
      _projects = _createProjects(sector, careerGoal);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to generate roadmap: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Update roadmap step status
  Future<bool> updateStepStatus(String stepId, String status) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _roadmapSteps.indexWhere((step) => step.id == stepId);
      if (index != -1) {
        _roadmapSteps[index] = _roadmapSteps[index].copyWith(status: status);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update step status: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update project status
  Future<bool> updateProjectStatus(String projectId, String status) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _projects.indexWhere((project) => project.id == projectId);
      if (index != -1) {
        _projects[index] = _projects[index].copyWith(
          status: status,
          completedAt: status == 'Completed' ? DateTime.now() : null,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update project status: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get filtered resources
  List<Resource> getFilteredResources({bool? isFree}) {
    if (isFree == null) return _resources;
    return _resources.where((resource) => resource.isFree == isFree).toList();
  }

  /// Get projects by category
  List<Project> getProjectsByCategory(String category) {
    return _projects.where((project) => project.category == category).toList();
  }

  /// Get progress percentage
  double getProgressPercentage() {
    if (_roadmapSteps.isEmpty) return 0.0;
    final completedSteps = _roadmapSteps.where((step) => step.status == 'Completed').length;
    return completedSteps / _roadmapSteps.length;
  }

  /// Get completed projects count
  int getCompletedProjectsCount() {
    return _projects.where((project) => project.status == 'Completed').length;
  }

  /// Get upcoming deadlines
  List<RoadmapStep> getUpcomingDeadlines() {
    final now = DateTime.now();
    return _roadmapSteps
        .where((step) => 
            step.deadline != null && 
            step.deadline!.isAfter(now) && 
            step.status != 'Completed')
        .toList()
      ..sort((a, b) => a.deadline!.compareTo(b.deadline!));
  }

  List<RoadmapStep> _createRoadmapSteps(String sector, String careerGoal, String yearLevel, bool isPaidUser) {
    // This would typically come from an API based on user preferences
    return [
      RoadmapStep(
        id: 'step_1',
        title: 'Foundation Skills',
        description: 'Build fundamental skills in your chosen field',
        status: 'Not Started',
        deadline: DateTime.now().add(const Duration(days: 30)),
        resources: ['resource_1', 'resource_2'],
        miniProjects: ['project_1'],
        order: 1,
        category: 'Foundation',
      ),
      RoadmapStep(
        id: 'step_2',
        title: 'Intermediate Concepts',
        description: 'Learn intermediate concepts and best practices',
        status: 'Not Started',
        deadline: DateTime.now().add(const Duration(days: 60)),
        resources: ['resource_3', 'resource_4'],
        miniProjects: ['project_2', 'project_3'],
        order: 2,
        category: 'Intermediate',
      ),
      RoadmapStep(
        id: 'step_3',
        title: 'Advanced Topics',
        description: 'Master advanced topics and specialized areas',
        status: 'Not Started',
        deadline: DateTime.now().add(const Duration(days: 90)),
        resources: ['resource_5', 'resource_6'],
        miniProjects: ['project_4'],
        order: 3,
        category: 'Advanced',
      ),
      RoadmapStep(
        id: 'step_4',
        title: 'Portfolio Development',
        description: 'Build a strong portfolio showcasing your skills',
        status: 'Not Started',
        deadline: DateTime.now().add(const Duration(days: 120)),
        resources: ['resource_7'],
        miniProjects: ['project_5', 'project_6'],
        order: 4,
        category: 'Portfolio',
      ),
    ];
  }

  List<Resource> _createResources(String sector, String careerGoal, bool isPaidUser) {
    return [
      // YouTube Video Resources
      Resource(
        id: 'resource_1',
        title: 'Complete $careerGoal Tutorial - Full Course',
        description: 'Comprehensive 8-hour tutorial covering all fundamentals with hands-on projects',
        type: 'video',
        url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        isFree: true,
        rating: 4.9,
        duration: 480,
        provider: 'YouTube',
        tags: ['beginner', 'fundamentals', 'tutorial', 'free'],
      ),
      Resource(
        id: 'resource_2',
        title: '$careerGoal Crash Course - Learn in 2 Hours',
        description: 'Quick crash course perfect for beginners who want to get started fast',
        type: 'video',
        url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        isFree: true,
        rating: 4.7,
        duration: 120,
        provider: 'YouTube',
        tags: ['beginner', 'crash-course', 'quick-start'],
      ),
      Resource(
        id: 'resource_3',
        title: 'Advanced $careerGoal Masterclass',
        description: 'Deep dive into advanced concepts with real-world examples',
        type: 'video',
        url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        isFree: true,
        rating: 4.8,
        duration: 360,
        provider: 'YouTube',
        tags: ['advanced', 'masterclass', 'expert-level'],
      ),

      // Course Resources
      Resource(
        id: 'resource_4',
        title: 'Professional $careerGoal Certification',
        description: 'Industry-recognized certification course with hands-on projects',
        type: 'course',
        url: 'https://www.coursera.org/learn/example',
        isFree: false,
        rating: 4.6,
        duration: 240,
        provider: 'Coursera',
        tags: ['certification', 'professional', 'career'],
      ),
      Resource(
        id: 'resource_5',
        title: '$careerGoal Bootcamp - Complete Guide',
        description: 'Intensive bootcamp-style course with job placement assistance',
        type: 'course',
        url: 'https://www.udemy.com/course/example',
        isFree: !isPaidUser,
        rating: 4.7,
        duration: 600,
        provider: 'Udemy',
        tags: ['bootcamp', 'intensive', 'job-ready'],
      ),

      // Book Resources
      Resource(
        id: 'resource_6',
        title: 'The Complete $careerGoal Handbook',
        description: 'Comprehensive guide covering theory and practical applications',
        type: 'book',
        url: 'https://www.oreilly.com/library/view/example',
        isFree: false,
        rating: 4.5,
        duration: 480,
        provider: 'O\'Reilly',
        tags: ['reference', 'handbook', 'comprehensive'],
      ),

      // Interactive YouTube Resources
      Resource(
        id: 'resource_7',
        title: 'Interactive $careerGoal Challenges',
        description: 'Hands-on coding challenges and exercises',
        type: 'video',
        url: 'https://www.youtube.com/playlist?list=PLrAXtmRdnEQy4QgYw6RdaO-rTsUuSjhjv',
        isFree: true,
        rating: 4.3,
        duration: 180,
        provider: 'YouTube',
        tags: ['interactive', 'challenges', 'practice'],
      ),
      Resource(
        id: 'resource_8',
        title: '$careerGoal Project-Based Learning',
        description: 'Learn by building real-world projects step by step',
        type: 'video',
        url: 'https://www.youtube.com/watch?v=PkZNo7MFNFg',
        isFree: true,
        rating: 4.8,
        duration: 720,
        provider: 'YouTube',
        tags: ['project-based', 'hands-on', 'real-world'],
      ),

      // Specialized YouTube Channels
      Resource(
        id: 'resource_9',
        title: '$careerGoal Tips & Tricks Channel',
        description: 'Weekly tips, tricks, and industry insights',
        type: 'video',
        url: 'https://www.youtube.com/c/TechWithTim',
        isFree: true,
        rating: 4.6,
        duration: 30,
        provider: 'YouTube',
        tags: ['tips', 'weekly', 'insights'],
      ),
      Resource(
        id: 'resource_10',
        title: 'Live $careerGoal Coding Sessions',
        description: 'Watch experienced developers code in real-time',
        type: 'video',
        url: 'https://www.youtube.com/c/ThePrimeagen',
        isFree: true,
        rating: 4.5,
        duration: 240,
        provider: 'YouTube',
        tags: ['live-coding', 'real-time', 'experienced'],
      ),

      // Documentation & References
      Resource(
        id: 'resource_11',
        title: 'Official $careerGoal Documentation',
        description: 'Official documentation and API references',
        type: 'article',
        url: 'https://docs.flutter.dev',
        isFree: true,
        rating: 4.9,
        duration: 60,
        provider: 'Official',
        tags: ['documentation', 'reference', 'official'],
      ),
    ];
  }

  List<Project> _createProjects(String sector, String careerGoal) {
    return [
      Project(
        id: 'project_1',
        title: 'Hello World Project',
        description: 'Create your first project in $careerGoal',
        status: 'Not Started',
        skills: ['Basic Programming', 'Problem Solving'],
        estimatedHours: 10,
        difficulty: 'Beginner',
        category: 'Foundation',
      ),
      Project(
        id: 'project_2',
        title: 'Portfolio Website',
        description: 'Build a personal portfolio website',
        status: 'Not Started',
        skills: ['Web Development', 'Design', 'Deployment'],
        estimatedHours: 20,
        difficulty: 'Intermediate',
        category: 'Portfolio',
      ),
      Project(
        id: 'project_3',
        title: 'Advanced Application',
        description: 'Create a complex application showcasing advanced skills',
        status: 'Not Started',
        skills: ['Advanced Programming', 'Architecture', 'Testing'],
        estimatedHours: 40,
        difficulty: 'Advanced',
        category: 'Advanced',
      ),
    ];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
