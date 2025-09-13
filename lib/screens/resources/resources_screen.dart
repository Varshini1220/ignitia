import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ignitia/providers/roadmap_provider.dart';
import 'package:ignitia/widgets/common/custom_card.dart';
import 'package:ignitia/widgets/common/custom_text_field.dart';
import 'package:ignitia/widgets/common/custom_button.dart';
import 'package:ignitia/models/roadmap_model.dart';

/// Resources screen showing recommended courses and learning materials
class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _searchQuery = '';
  bool _showFreeOnly = false;
  String _selectedType = 'All';
  String _selectedProvider = 'All';

  final List<String> _resourceTypes = ['All', 'Course', 'Book', 'Video', 'Article'];
  final List<String> _providers = ['All', 'Coursera', 'Udemy', 'YouTube', 'O\'Reilly', 'Khan Academy'];

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

  void _openResource(String url) {
    // In a real app, you would use url_launcher package
    // For now, we'll show a snackbar with the URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: $url'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () => _copyToClipboard(url),
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL copied to clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showBookmarksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bookmarked Resources'),
        content: const SizedBox(
          width: double.maxFinite,
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('No bookmarks yet'),
                SizedBox(height: 8),
                Text(
                  'Bookmark resources to access them quickly later',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
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

  List<Resource> _getFilteredResources() {
    final roadmapProvider = Provider.of<RoadmapProvider>(context, listen: false);
    var resources = roadmapProvider.resources;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      resources = resources.where((resource) =>
          resource.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resource.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          resource.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }

    // Apply free filter
    if (_showFreeOnly) {
      resources = resources.where((resource) => resource.isFree).toList();
    }

    // Apply type filter
    if (_selectedType != 'All') {
      resources = resources.where((resource) => resource.type == _selectedType.toLowerCase()).toList();
    }

    // Apply provider filter
    if (_selectedProvider != 'All') {
      resources = resources.where((resource) => resource.provider == _selectedProvider).toList();
    }

    return resources;
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

    final filteredResources = _getFilteredResources();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Resources'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showBookmarksDialog();
            },
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Filters
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildSearchAndFilters(theme),
            ),
            
            const SizedBox(height: 24),
            
            // Resources List
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildResourcesList(theme, filteredResources),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(ThemeData theme) {
    return Column(
      children: [
        // Search Bar
        SearchTextField(
          hint: 'Search resources...',
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Free Only Toggle
              FilterChip(
                label: const Text('Free Only'),
                selected: _showFreeOnly,
                onSelected: (selected) {
                  setState(() {
                    _showFreeOnly = selected;
                  });
                },
              ),
              
              const SizedBox(width: 8),
              
              // Type Filter
              DropdownButton<String>(
                value: _selectedType,
                items: _resourceTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value ?? 'All';
                  });
                },
                underline: Container(),
                style: theme.textTheme.bodyMedium,
              ),
              
              const SizedBox(width: 8),
              
              // Provider Filter
              DropdownButton<String>(
                value: _selectedProvider,
                items: _providers.map((provider) => DropdownMenuItem(
                  value: provider,
                  child: Text(provider),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvider = value ?? 'All';
                  });
                },
                underline: Container(),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResourcesList(ThemeData theme, List<Resource> resources) {
    if (resources.isEmpty) {
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
              'No resources found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
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
          '${resources.length} Resources Found',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...resources.map((resource) => _buildResourceCard(theme, resource)).toList(),
      ],
    );
  }

  Widget _buildResourceCard(ThemeData theme, Resource resource) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {
        // TODO: Open resource URL or show details
        _showResourceDetails(theme, resource);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Resource Type Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(resource.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(resource.type),
                  color: _getTypeColor(resource.type),
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Title and Provider
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.provider,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Price Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: resource.isFree 
                      ? Colors.green.withOpacity(0.1)
                      : theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  resource.isFree ? 'FREE' : 'PAID',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: resource.isFree ? Colors.green : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            resource.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // Rating and Duration
          Row(
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                resource.rating.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.schedule,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${resource.duration} min',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
          
          if (resource.tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: resource.tags.map((tag) => Chip(
                label: Text(
                  tag,
                  style: theme.textTheme.bodySmall,
                ),
                backgroundColor: theme.colorScheme.surfaceVariant,
                side: BorderSide.none,
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'course':
        return Colors.blue;
      case 'book':
        return Colors.orange;
      case 'video':
        return Colors.red;
      case 'article':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'course':
        return Icons.school;
      case 'book':
        return Icons.menu_book;
      case 'video':
        return Icons.play_circle;
      case 'article':
        return Icons.article;
      default:
        return Icons.description;
    }
  }

  void _showResourceDetails(ThemeData theme, Resource resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
                      resource.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'by ${resource.provider}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      resource.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Open Resource',
                            onPressed: () {
                              _openResource(resource.url);
                              Navigator.pop(context);
                            },
                            size: ButtonSize.large,
                            icon: Icons.open_in_new,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CustomButton(
                          text: '',
                          onPressed: () {
                            _copyToClipboard(resource.url);
                          },
                          type: ButtonType.outline,
                          size: ButtonSize.large,
                          icon: Icons.copy,
                        ),
                      ],
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
