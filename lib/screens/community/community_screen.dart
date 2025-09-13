import 'package:flutter/material.dart';
import 'package:ignitia/widgets/common/custom_card.dart';
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/widgets/common/custom_text_field.dart';

/// Community screen for peer motivation and discussion
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedSector = 'All';
  String _searchQuery = '';
  int _selectedTab = 0;

  final List<String> _sectors = ['All', 'Technology', 'Healthcare', 'Finance', 'Education', 'Design'];
  final List<String> _tabs = ['Posts', 'Milestones', 'Resources'];

  // Mock community data
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'author': 'Sarah Chen',
      'avatar': 'https://via.placeholder.com/40',
      'sector': 'Technology',
      'title': 'Just completed my first React project! 🎉',
      'content': 'After 3 months of learning, I finally built a full-stack web application. The journey was challenging but incredibly rewarding. Here are some key learnings...',
      'likes': 24,
      'comments': 8,
      'shares': 3,
      'timeAgo': '2 hours ago',
      'isLiked': false,
      'tags': ['React', 'JavaScript', 'Web Development'],
    },
    {
      'id': '2',
      'author': 'Mike Johnson',
      'avatar': 'https://via.placeholder.com/40',
      'sector': 'Technology',
      'title': 'Data Science Career Path - My Experience',
      'content': 'Sharing my journey from a business background to becoming a data scientist. The key was focusing on practical projects and building a strong portfolio.',
      'likes': 45,
      'comments': 12,
      'shares': 7,
      'timeAgo': '5 hours ago',
      'isLiked': true,
      'tags': ['Data Science', 'Career Change', 'Portfolio'],
    },
    {
      'id': '3',
      'author': 'Emily Rodriguez',
      'avatar': 'https://via.placeholder.com/40',
      'sector': 'Design',
      'title': 'UI/UX Design Resources That Actually Help',
      'content': 'After 2 years in the field, here are the resources that made the biggest difference in my design skills. From tools to courses to communities...',
      'likes': 32,
      'comments': 15,
      'shares': 9,
      'timeAgo': '1 day ago',
      'isLiked': false,
      'tags': ['UI/UX', 'Design', 'Resources'],
    },
  ];

  final List<Map<String, dynamic>> _milestones = [
    {
      'id': '1',
      'author': 'Alex Kim',
      'avatar': 'https://via.placeholder.com/40',
      'sector': 'Technology',
      'milestone': 'Completed 100 Days of Code Challenge',
      'description': 'Consistently coded for 100 days straight! Built 15 projects and learned 3 new technologies.',
      'likes': 67,
      'comments': 23,
      'timeAgo': '3 hours ago',
      'isLiked': true,
    },
    {
      'id': '2',
      'author': 'Lisa Wang',
      'avatar': 'https://via.placeholder.com/40',
      'sector': 'Healthcare',
      'milestone': 'Passed Medical Licensing Exam',
      'description': 'After 4 years of medical school, I finally passed my licensing exam! Ready to start my residency.',
      'likes': 89,
      'comments': 34,
      'timeAgo': '6 hours ago',
      'isLiked': false,
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

  void _showCommentsDialog(Map<String, dynamic> milestone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Comments on "${milestone['title']}"'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // Sample comments
                  itemBuilder: (context, index) {
                    final comments = [
                      {'user': 'Alex', 'comment': 'Great achievement! Keep it up!', 'time': '2h ago'},
                      {'user': 'Sarah', 'comment': 'This is inspiring. How did you manage your time?', 'time': '4h ago'},
                      {'user': 'Mike', 'comment': 'Congratulations! What\'s your next goal?', 'time': '6h ago'},
                    ];
                    final comment = comments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment['user']!,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                comment['time']!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(comment['comment']!),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add comment functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment added!')),
                      );
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
        title: const Text('Community'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAddPostDialog();
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
            // Header Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildHeader(theme),
            ),
            
            const SizedBox(height: 24),
            
            // Search and Filters
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildSearchAndFilters(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tab Bar
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildTabBar(theme),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Content
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildContent(theme),
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
        Color(0xFF9C27B0),
        Color(0xFFE91E63),
      ],
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connect & Learn Together',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share your journey, celebrate milestones, and learn from peers',
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

  Widget _buildSearchAndFilters(ThemeData theme) {
    return Column(
      children: [
        // Search Bar
        SearchTextField(
          hint: 'Search posts, milestones, or resources...',
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Sector Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _sectors.map((sector) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(sector),
                selected: _selectedSector == sector,
                onSelected: (selected) {
                  setState(() {
                    _selectedSector = sector;
                  });
                },
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    switch (_selectedTab) {
      case 0:
        return _buildPosts(theme);
      case 1:
        return _buildMilestones(theme);
      case 2:
        return _buildResources(theme);
      default:
        return _buildPosts(theme);
    }
  }

  Widget _buildPosts(ThemeData theme) {
    final filteredPosts = _posts.where((post) {
      if (_selectedSector != 'All' && post['sector'] != _selectedSector) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return post['title'].toLowerCase().contains(query) ||
               post['content'].toLowerCase().contains(query) ||
               (post['tags'] as List).any((tag) => tag.toLowerCase().contains(query));
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${filteredPosts.length} Posts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...filteredPosts.map((post) => _buildPostCard(theme, post)).toList(),
      ],
    );
  }

  Widget _buildPostCard(ThemeData theme, Map<String, dynamic> post) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(post['avatar']),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['author'],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${post['sector']} • ${post['timeAgo']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  // TODO: Handle menu actions
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'bookmark',
                    child: Row(
                      children: [
                        Icon(Icons.bookmark_border, size: 16),
                        SizedBox(width: 8),
                        Text('Bookmark'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'report',
                    child: Row(
                      children: [
                        Icon(Icons.report, size: 16),
                        SizedBox(width: 8),
                        Text('Report'),
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
          
          const SizedBox(height: 12),
          
          // Post Content
          Text(
            post['title'],
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post['content'],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          
          // Tags
          if (post['tags'].isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (post['tags'] as List).map((tag) => Chip(
                label: Text(
                  '#$tag',
                  style: theme.textTheme.bodySmall,
                ),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                side: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              )).toList(),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Actions
          Row(
            children: [
              _buildActionButton(
                theme,
                Icons.thumb_up,
                post['likes'].toString(),
                post['isLiked'],
                () {
                  setState(() {
                    post['isLiked'] = !post['isLiked'];
                    post['likes'] += post['isLiked'] ? 1 : -1;
                  });
                },
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                theme,
                Icons.comment,
                post['comments'].toString(),
                false,
                () {
                  // TODO: Open comments
                },
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                theme,
                Icons.share,
                post['shares'].toString(),
                false,
                () {
                  // TODO: Share post
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    IconData icon,
    String count,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Milestones',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._milestones.map((milestone) => _buildMilestoneCard(theme, milestone)).toList(),
      ],
    );
  }

  Widget _buildMilestoneCard(ThemeData theme, Map<String, dynamic> milestone) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(milestone['avatar']),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      milestone['author'],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      milestone['timeAgo'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  milestone['milestone'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone['description'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildActionButton(
                      theme,
                      Icons.thumb_up,
                      milestone['likes'].toString(),
                      milestone['isLiked'],
                      () {
                        setState(() {
                          milestone['isLiked'] = !milestone['isLiked'];
                          milestone['likes'] += milestone['isLiked'] ? 1 : -1;
                        });
                      },
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      theme,
                      Icons.comment,
                      milestone['comments'].toString(),
                      false,
                      () {
                        _showCommentsDialog(milestone);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResources(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.library_books,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Community Resources',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon! Share and discover resources recommended by the community.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddPostDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Post'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Post Title',
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                maxLength: 500,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              titleController.dispose();
              contentController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty &&
                  contentController.text.trim().isNotEmpty) {
                // In a real app, you would save the post to a database
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                titleController.dispose();
                contentController.dispose();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in both title and content'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
