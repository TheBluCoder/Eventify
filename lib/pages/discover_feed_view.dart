import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/discover_controller.dart';

class DiscoverFeedView extends StatefulWidget {
  const DiscoverFeedView({super.key});

  @override
  State<DiscoverFeedView> createState() => _DiscoverFeedViewState();
}

class _DiscoverFeedViewState extends State<DiscoverFeedView> {
  final ScrollController _scrollController = ScrollController();
  String _selectedDiscoveryTab = 'trending';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight+20),
      child: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh logic
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Discovery tabs
              _buildDiscoveryTabs(context),
              // Content based on selected tab
              Consumer<DiscoverController>(
                builder: (context, discoverController, child) {
                  return _buildDiscoveryContent(context, discoverController);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoveryTabs(BuildContext context) {
    final tabs = [
      {'id': 'trending', 'label': 'Trending', 'icon': Icons.trending_up},
      {'id': 'nearby', 'label': 'Nearby', 'icon': Icons.location_on},
      {'id': 'categories', 'label': 'Categories', 'icon': Icons.category},
      {'id': 'time', 'label': 'Time', 'icon': Icons.schedule},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final isSelected = _selectedDiscoveryTab == tab['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDiscoveryTab = tab['id'] as String;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[600] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab['icon'] as IconData,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tab['label'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDiscoveryContent(BuildContext context, DiscoverController controller) {
    switch (_selectedDiscoveryTab) {
      case 'trending':
        return _buildTrendingContent(context, controller);
      case 'nearby':
        return _buildNearbyContent(context, controller);
      case 'categories':
        return _buildCategoriesContent(context, controller);
      case 'time':
        return _buildTimeContent(context, controller);
      default:
        return _buildTrendingContent(context, controller);
    }
  }

  Widget _buildTrendingContent(BuildContext context, DiscoverController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero section with featured event
        _buildHeroSection(context),
        const SizedBox(height: 20),
        
        // Quick discovery actions
        _buildQuickDiscoveryActions(context),
        const SizedBox(height: 20),
        
        // Trending events section
        _buildTrendingEventsSection(context),
        const SizedBox(height: 20),
        
        // Popular categories
        _buildPopularCategoriesSection(context),
        const SizedBox(height: 20),
        
        // All events list
        _buildAllEventsSection(context),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.purple[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1511578314322-379afb476865?w=400'),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '🔥 TRENDING NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tech Meetup: AI & Machine Learning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Downtown Tech Hub • 0.5 km',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '45 interested',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
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

  Widget _buildQuickDiscoveryActions(BuildContext context) {
    final actions = [
      {'icon': Icons.explore, 'label': 'Surprise Me', 'color': Colors.orange},
      {'icon': Icons.near_me, 'label': 'Nearby', 'color': Colors.green},
      {'icon': Icons.trending_up, 'label': 'Trending', 'color': Colors.purple},
      {'icon': Icons.today, 'label': 'Today', 'color': Colors.blue},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Implement discovery action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${action['label']} tapped')),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (action['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: action['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.center,
                      action['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrendingEventsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                '🔥 Trending Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all trending events
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildTrendingEventCard(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingEventCard(BuildContext context, int index) {
    final events = [
      {
        'title': 'University Hackathon 2024',
        'location': 'University Campus',
        'distance': '2.1 km',
        'interested': 120,
        'image': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400',
        'trending': true,
      },
      {
        'title': 'Live Music: Jazz Night',
        'location': 'Blue Note Lounge',
        'distance': '1.5 km',
        'interested': 67,
        'image': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
        'trending': false,
      },
      {
        'title': 'Community Garden Workshop',
        'location': 'Community Center',
        'distance': '0.8 km',
        'interested': 28,
        'image': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
        'trending': true,
      },
    ];

    final event = events[index];

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(event['image'] as String),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Trending badge
                if (event['trending'] as bool)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.trending_up, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'TRENDING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Distance
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event['distance'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Event details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event['location'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.people, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${event['interested']} interested',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Tech',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildPopularCategoriesSection(BuildContext context) {
    final categories = [
      {'name': 'Tech', 'count': 45, 'color': Colors.blue, 'icon': Icons.computer},
      {'name': 'Music', 'count': 32, 'color': Colors.purple, 'icon': Icons.music_note},
      {'name': 'Sports', 'count': 28, 'color': Colors.green, 'icon': Icons.sports},
      {'name': 'Food', 'count': 24, 'color': Colors.orange, 'icon': Icons.restaurant},
      {'name': 'Art', 'count': 19, 'color': Colors.pink, 'icon': Icons.palette},
      {'name': 'Community', 'count': 15, 'color': Colors.teal, 'icon': Icons.people},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                '📂 Popular Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDiscoveryTab = 'categories';
                  });
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  // TODO: Filter by category
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Filtering by ${category['name']}')),
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width - 56) / 2,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          color: category['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category['count']} events',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAllEventsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                '📅 All Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all events
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Show first 3 events from feed
        _buildEventsPreview(context),
      ],
    );
  }

  Widget _buildNearbyContent(BuildContext context, DiscoverController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                '📍 Events Near You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Consumer<DiscoverController>(
                builder: (context, discoverController, child) {
                  return Text(
                    '${discoverController.eventCount} events',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Radius selector
        _buildRadiusSelector(context, controller),
        const SizedBox(height: 20),
        // Nearby events
        _buildEventsPreview(context),
      ],
    );
  }

  Widget _buildRadiusSelector(BuildContext context, DiscoverController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Discovery Radius',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${controller.radiusKm} km',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: controller.radiusKm.toDouble(),
            min: 1,
            max: 50,
            divisions: 49,
            onChanged: (value) {
              controller.setRadius(value.toInt());
            },
            activeColor: Colors.blue[600],
            inactiveColor: Colors.grey[300],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 km', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              Text('50 km', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesContent(BuildContext context, DiscoverController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            '🎯 Browse by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Category grid
        _buildCategoryGrid(context),
      ],
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      {'name': 'Technology', 'count': 45, 'color': Colors.blue, 'icon': Icons.computer},
      {'name': 'Music & Arts', 'count': 32, 'color': Colors.purple, 'icon': Icons.music_note},
      {'name': 'Sports & Fitness', 'count': 28, 'color': Colors.green, 'icon': Icons.sports},
      {'name': 'Food & Drink', 'count': 24, 'color': Colors.orange, 'icon': Icons.restaurant},
      {'name': 'Education', 'count': 19, 'color': Colors.indigo, 'icon': Icons.school},
      {'name': 'Community', 'count': 15, 'color': Colors.teal, 'icon': Icons.people},
      {'name': 'Business', 'count': 12, 'color': Colors.grey, 'icon': Icons.business},
      {'name': 'Health & Wellness', 'count': 8, 'color': Colors.pink, 'icon': Icons.favorite},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories.map((category) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 56) / 2,
            child: GestureDetector(
              onTap: () {
                // TODO: Filter by category
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Filtering by ${category['name']}')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category['count']} events',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeContent(BuildContext context, DiscoverController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            '⏰ Events by Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Time-based filters
        _buildTimeFilters(context, controller),
        const SizedBox(height: 20),
        // Events for selected time
        _buildEventsPreview(context),
      ],
    );
  }

  Widget _buildTimeFilters(BuildContext context, DiscoverController controller) {
    final timeFilters = [
      {'label': 'Today', 'value': 'Today', 'count': 12},
      {'label': 'Tomorrow', 'value': 'Tomorrow', 'count': 8},
      {'label': 'This Week', 'value': 'This Week', 'count': 45},
      {'label': 'This Weekend', 'value': 'This Weekend', 'count': 23},
      {'label': 'Next Week', 'value': 'Next Week', 'count': 38},
      {'label': 'This Month', 'value': 'This Month', 'count': 156},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: timeFilters.map((filter) {
          final isSelected = controller.dateRange == filter['value'];
          return GestureDetector(
            onTap: () {
              controller.setDateRange(filter['value'] as String);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[600] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    filter['label'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${filter['count']} events',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventsPreview(BuildContext context) {
    // Mock events data
    final events = [
      {
        'title': 'Tech Meetup: AI & Machine Learning',
        'location': 'Downtown Tech Hub',
        'distance': '0.5 km',
        'date': 'Today, 7:00 PM',
        'interested': 45,
        'imageUrl': 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400',
      },
      {
        'title': 'Garage Sale - Everything Must Go!',
        'location': '123 Oak Street',
        'distance': '1.2 km',
        'date': 'Tomorrow, 9:00 AM',
        'interested': 12,
        'imageUrl': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
      },
      {
        'title': 'University Hackathon 2024',
        'location': 'University Campus',
        'distance': '2.1 km',
        'date': 'This Weekend',
        'interested': 120,
        'imageUrl': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400',
      },
    ];

    return Column(
      children: events.map((event) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: NetworkImage(event['imageUrl'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Distance indicator
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event['distance'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Event details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event['location'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event['date'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.people_outline, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              '${event['interested']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
