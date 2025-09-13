/// Roadmap step model for career progression tracking
class RoadmapStep {
  final String id;
  final String title;
  final String description;
  final String status; // 'Not Started', 'In Progress', 'Completed'
  final DateTime? deadline;
  final List<String> resources;
  final List<String> miniProjects;
  final int order;
  final String category;

  RoadmapStep({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.deadline,
    required this.resources,
    required this.miniProjects,
    required this.order,
    required this.category,
  });

  factory RoadmapStep.fromJson(Map<String, dynamic> json) {
    return RoadmapStep(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Not Started',
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      resources: List<String>.from(json['resources'] ?? []),
      miniProjects: List<String>.from(json['miniProjects'] ?? []),
      order: json['order'] ?? 0,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'resources': resources,
      'miniProjects': miniProjects,
      'order': order,
      'category': category,
    };
  }

  RoadmapStep copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    DateTime? deadline,
    List<String>? resources,
    List<String>? miniProjects,
    int? order,
    String? category,
  }) {
    return RoadmapStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      resources: resources ?? this.resources,
      miniProjects: miniProjects ?? this.miniProjects,
      order: order ?? this.order,
      category: category ?? this.category,
    );
  }
}

/// Resource model for courses, books, and learning materials
class Resource {
  final String id;
  final String title;
  final String description;
  final String type; // 'course', 'book', 'video', 'article'
  final String url;
  final bool isFree;
  final double rating;
  final int duration; // in minutes
  final String provider;
  final List<String> tags;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.url,
    required this.isFree,
    required this.rating,
    required this.duration,
    required this.provider,
    required this.tags,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'course',
      url: json['url'] ?? '',
      isFree: json['isFree'] ?? true,
      rating: (json['rating'] ?? 0.0).toDouble(),
      duration: json['duration'] ?? 0,
      provider: json['provider'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'url': url,
      'isFree': isFree,
      'rating': rating,
      'duration': duration,
      'provider': provider,
      'tags': tags,
    };
  }
}

/// Project model for portfolio and skill building
class Project {
  final String id;
  final String title;
  final String description;
  final String status; // 'Not Started', 'In Progress', 'Completed'
  final List<String> skills;
  final int estimatedHours;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final String category;
  final DateTime? completedAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.skills,
    required this.estimatedHours,
    required this.difficulty,
    required this.category,
    this.completedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Not Started',
      skills: List<String>.from(json['skills'] ?? []),
      estimatedHours: json['estimatedHours'] ?? 0,
      difficulty: json['difficulty'] ?? 'Beginner',
      category: json['category'] ?? '',
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'skills': skills,
      'estimatedHours': estimatedHours,
      'difficulty': difficulty,
      'category': category,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    List<String>? skills,
    int? estimatedHours,
    String? difficulty,
    String? category,
    DateTime? completedAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      skills: skills ?? this.skills,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
