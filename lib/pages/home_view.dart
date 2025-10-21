import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../controllers/home_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';
  String _selectedSort = 'Distance';
  bool _isRefreshing = false;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'Tech Meetup: AI & Machine Learning',
      'description':
          'Join us for an exciting discussion about the latest trends in AI and ML. Free pizza and networking!',
      'location': 'Downtown Tech Hub',
      'distance': '0.5 km',
      'date': 'Today, 7:00 PM',
      'tags': ['Tech', 'AI', 'Networking'],
      'organizer': 'Tech Community',
      'interested': 45,
      'isFollowing': false,
      'isBoosted': false,
      'isLiked': false,
      'imageUrl':
          'https://www.vizrt.com/wp-content/uploads/ai-ml-new20article-vizrt-hdr-img-1920x1080-1.png',
    },
    {
      'id': '2',
      'title': 'Garage Sale - Everything Must Go!',
      'description':
          'Moving sale! Furniture, electronics, books, and more. Great deals on quality items.',
      'location': '123 Oak Street',
      'distance': '1.2 km',
      'date': 'Tomorrow, 9:00 AM',
      'tags': ['Sale', 'Furniture', 'Local'],
      'organizer': 'Sarah Johnson',
      'interested': 12,
      'isFollowing': true,
      'isBoosted': false,
      'isLiked': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
    },
    {
      'id': '3',
      'title': 'University Hackathon 2024',
      'description':
          '48-hour coding competition with prizes up to \$5000. All skill levels welcome!',
      'location': 'University Campus',
      'distance': '2.1 km',
      'date': 'This Weekend',
      'tags': ['Hackathon', 'Programming', 'Competition'],
      'organizer': 'CS Department',
      'interested': 120,
      'isFollowing': false,
      'isBoosted': true,
      'isLiked': false,
      'imageUrl':
          'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400',
    },
    {
      'id': '4',
      'title': 'Community Garden Workshop',
      'description':
          'Learn sustainable gardening techniques and help maintain our community garden.',
      'location': 'Community Center',
      'distance': '0.8 km',
      'date': 'Saturday, 10:00 AM',
      'tags': ['Gardening', 'Community', 'Sustainability'],
      'organizer': 'Green Thumbs Club',
      'interested': 28,
      'isFollowing': true,
      'isBoosted': false,
      'isLiked': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
    },
    {
      'id': '5',
      'title': 'Live Music: Jazz Night',
      'description':
          'Enjoy an evening of smooth jazz with local musicians. Drinks and light snacks available.',
      'location': 'Blue Note Lounge',
      'distance': '1.5 km',
      'date': 'Friday, 8:00 PM',
      'tags': ['Music', 'Jazz', 'Entertainment'],
      'organizer': 'Blue Note Lounge',
      'interested': 67,
      'isFollowing': false,
      'isBoosted': false,
      'isLiked': false,
      'imageUrl':
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400',
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: kToolbarHeight + 30,
          bottom: kBottomNavigationBarHeight,
          right: 5,
          left: 5,
        ),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return _buildEventCard(_events[index]);
        },
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventPoster(event),
          _buildEventImage(event),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEventHeader(event),
                const SizedBox(height: 8),
                _buildEventDescription(event),
                const SizedBox(height: 12),
                _buildEventDetails(event),
                const SizedBox(height: 12),
                _buildEventTags(event),
                const SizedBox(height: 16),
                _buildEventActions(event),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventImage(Map<String, dynamic> event) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        image: DecorationImage(
          image: NetworkImage(event['imageUrl']),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Boost indicator
          if (event['isBoosted'])
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'BOOSTED',
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
          // Distance indicator
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(70),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event['distance'],
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
    );
  }

  Widget _buildEventHeader(Map<String, dynamic> event) {
    return Text(
      event['title'],
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEventDescription(Map<String, dynamic> event) {
    return Text(
      event['description'],
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Colors.grey[700],
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEventDetails(Map<String, dynamic> event) {
    return Wrap(
      spacing: 16.0, // Horizontal spacing between detail items
      runSpacing: 8.0, // Vertical spacing when wrapping to next line
      children: [
        // Location detail
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Text(
              event['location'],
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        // Date detail
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Text(
              event['date'],
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        // Interested count detail
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 14, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Text(
              '${event['interested']}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventTags(Map<String, dynamic> event) {
    final tagColors = [
      {'bg': Colors.blue[50]!, 'border': Colors.blue[200]!, 'text': Colors.blue[700]!},
      {'bg': Colors.green[50]!, 'border': Colors.green[200]!, 'text': Colors.green[700]!},
      {'bg': Colors.orange[50]!, 'border': Colors.orange[200]!, 'text': Colors.orange[700]!},
      {'bg': Colors.purple[50]!, 'border': Colors.purple[200]!, 'text': Colors.purple[700]!},
      {'bg': Colors.red[50]!, 'border': Colors.red[200]!, 'text': Colors.red[700]!},
      {'bg': Colors.teal[50]!, 'border': Colors.teal[200]!, 'text': Colors.teal[700]!},
      {'bg': Colors.indigo[50]!, 'border': Colors.indigo[200]!, 'text': Colors.indigo[700]!},
      {'bg': Colors.pink[50]!, 'border': Colors.pink[200]!, 'text': Colors.pink[700]!},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: (event['tags'] as List<String>).asMap().entries.map((entry) {
        final index = entry.key;
        final tag = entry.value;
        final colors = tagColors[index % tagColors.length];
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colors['bg'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 11,
              color: colors['text'],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventPoster(Map<String, dynamic> event) {
    return InkWell(
      onTap: () => _navigateToProfile(event),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Text(
                event['organizer'][0].toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                event['organizer'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventActions(Map<String, dynamic> event) {
    return Row(
      children: [
        // Like icon
        IconButton(
          onPressed: () => _toggleLike(event),
          icon: Icon( size: 21,
            event['isLiked'] == true ? Icons.favorite : Icons.favorite_border,
          ),
          color: event['isLiked'] == true ? Colors.red : Colors.grey[600],
          tooltip: 'Like Event',
        ),
        // Boost icon
        IconButton(
          onPressed: () => _boostEvent(event),
          icon: Icon( size: 21,
            event['isBoosted'] ? Icons.trending_up : Icons.trending_up_outlined,
          ),
          color: event['isBoosted'] ? Colors.orange : Colors.grey[600],
          tooltip: 'Boost Event',
        ),
        // Share icon (alternative)
        IconButton(
          onPressed: () => _shareEvent(event),
          icon: const Icon( size: 21,Icons.send_outlined),
          color: Colors.grey[600],
          tooltip: 'Share Event',
        ),
        const Spacer(),
        // More options menu
        PopupMenuButton<String>(
          icon: const Icon( size: 21,Icons.more_horiz_outlined),
          color: Colors.grey[600],
          tooltip: 'More Options',
          onSelected: (value) => _handleMenuAction(value, event),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'follow',
              child: Row(
                children: [
                  Icon(
                    event['isFollowing']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: event['isFollowing'] ? Colors.red : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(event['isFollowing'] ? 'Unfollow' : 'Follow'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'calendar',
              child: const Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                  SizedBox(width: 12),
                  Text('Add to Calendar'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'share',
              child: const Row(
                children: [
                  Icon(Icons.send, color: Colors.green, size: 20),
                  SizedBox(width: 12),
                  Text('Share Event'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'report',
              child: const Row(
                children: [
                  Icon(Icons.flag_outlined, color: Colors.red, size: 20),
                  SizedBox(width: 12),
                  Text('Report Event'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Advanced Filters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Radius', style: TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: 5.0,
              min: 0.1,
              max: 50.0,
              divisions: 50,
              label: '5.0 km',
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Event Type',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Wrap(
              spacing: 8,
              children: ['Free', 'Paid', 'Online', 'In-Person'].map((type) {
                return FilterChip(
                  label: Text(type),
                  selected: false,
                  onSelected: (selected) {},
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleFollow(Map<String, dynamic> event) {
    setState(() {
      event['isFollowing'] = !event['isFollowing'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event['isFollowing']
              ? 'Following ${event['organizer']}'
              : 'Unfollowed ${event['organizer']}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCalendar(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${event['title']}" to calendar'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _boostEvent(Map<String, dynamic> event) {
    setState(() {
      event['isBoosted'] = !event['isBoosted'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(event['isBoosted'] ? 'Event boosted!' : 'Boost removed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareEvent(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shared "${event['title']}"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportEvent(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Event'),
        content: const Text('Why are you reporting this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Event reported')));
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> event) {
    switch (action) {
      case 'follow':
        _toggleFollow(event);
        break;
      case 'calendar':
        _addToCalendar(event);
        break;
      case 'share':
        _shareEvent(event);
        break;
      case 'report':
        _reportEvent(event);
        break;
    }
  }

  void _toggleLike(Map<String, dynamic> event) {
    setState(() {
      event['isLiked'] = !(event['isLiked'] == true);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event['isLiked']
              ? 'Liked "${event['title']}"'
              : 'Unliked "${event['title']}"',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToProfile(Map<String, dynamic> event) {
    // TODO: Navigate to profile page
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProfilePage(userId: event['organizer_id']),
    //   ),
    // );
    
    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to ${event['organizer']}\'s profile'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
