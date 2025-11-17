import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/app_constants.dart';
import '../app/app_theme.dart';
import '../shared/models/event_model.dart';
import '../shared/data/placeholder.dart';
import '../shared/widgets/event_card.dart';
import '../routes/app_routes.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock user data - using consolidated placeholder data
  final String _userName = PlaceholderData.mockCurrentUser['userName'] as String;
  final String _userHandle = PlaceholderData.mockCurrentUser['userHandle'] as String;
  final String _userAvatar = PlaceholderData.mockCurrentUser['userAvatar'] as String;
  final int _followersCount = PlaceholderData.mockCurrentUser['followersCount'] as int;
  final int _followingCount = PlaceholderData.mockCurrentUser['followingCount'] as int;

  // Mock event lists - in a real app, these would come from API
  List<EventModel> _createdEvents = [];
  List<EventModel> _likedEvents = [];
  List<EventModel> _boostedEvents = [];
  List<Map<String, dynamic>> _followedPages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMockData();
  }

  void _loadMockData() {
    // Mock created events (events where user is the organizer)
    _createdEvents = PlaceholderData.discoverEvents.take(3).map((event) {
      return EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        organizerUsername: _userName,
        organizerAvatar: _userAvatar,
        dateTime: event.dateTime,
        location: event.location,
        distanceKm: event.distanceKm,
        latitude: event.latitude,
        longitude: event.longitude,
        interestedCount: event.interestedCount,
        tags: event.tags,
        mediaUrl: event.mediaUrl,
        isVideo: event.isVideo,
        isUserEvent: true,
      );
    }).toList();

    // Mock liked events (events the user has liked)
    _likedEvents = PlaceholderData.forYouEvents.take(2).map((event) {
      return EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        organizerUsername: event.organizerUsername,
        organizerAvatar: event.organizerAvatar,
        dateTime: event.dateTime,
        location: event.location,
        distanceKm: event.distanceKm,
        latitude: event.latitude,
        longitude: event.longitude,
        interestedCount: event.interestedCount,
        tags: event.tags,
        mediaUrl: event.mediaUrl,
        isVideo: event.isVideo,
        isLiked: true,
      );
    }).toList();

    // Mock boosted events (events the user has boosted)
    _boostedEvents = PlaceholderData.followingEvents.take(2).map((event) {
      return EventModel(
        id: event.id,
        title: event.title,
        description: event.description,
        organizerUsername: event.organizerUsername,
        organizerAvatar: event.organizerAvatar,
        dateTime: event.dateTime,
        location: event.location,
        distanceKm: event.distanceKm,
        latitude: event.latitude,
        longitude: event.longitude,
        interestedCount: event.interestedCount,
        tags: event.tags,
        mediaUrl: event.mediaUrl,
        isVideo: event.isVideo,
        isBoosted: true,
        boosterUsername: _userName,
      );
    }).toList();

    // Mock followed pages - using consolidated placeholder data
    _followedPages = PlaceholderData.mockFollowedPages;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildAppBar(innerBoxIsScrolled),
          ];
        },
        body: Column(
          children: [
            _buildProfileHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCreatedEventsTab(),
                  _buildLikedEventsTab(),
                  _buildBoostedEventsTab(),
                  _buildFollowedPagesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isScrolled) {
    return SliverAppBar(
      floating: false,
      snap: false,
      pinned: false,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.black),
          onPressed: () {
            // Navigate to settings page
            context.push(AppRouter.settings);
          },
        ),
        const SizedBox(width: 8),
      ],
      
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture overlapping banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Profile Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: AppTheme.shadowMedium(context),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.grey200,
                    backgroundImage: NetworkImage(_userAvatar),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: _userAvatar.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: AppTheme.grey600,
                          )
                        : null,
                  ),
                ),
                //Notification Button
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    size: 26,
                    color: AppTheme.grey600,
                  ),
                  onPressed: () {},
                ),
                // Edit Profile Button
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement edit profile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edit profile functionality coming soon'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: AppTheme.grey300, width: 1.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingXL,
                      vertical: AppConstants.paddingM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // User Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // User Name
                Text(
                  _userName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 4),
                // User Handle
                Text(
                  _userHandle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.grey600,
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: 12),
                // Stats Row (Following/Followers)
                Row(
                  children: [
                    _buildStatLink(
                      _followingCount,
                      'Following',
                      onTap: () {
                        // TODO: Navigate to following page
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildStatLink(
                      _followersCount,
                      'Followers',
                      onTap: () {
                        // TODO: Navigate to followers page
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatLink(int count, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            _formatNumber(count),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.grey600,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }


  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.grey300,
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppTheme.blue600,
        indicatorWeight: 3,
        labelColor: Colors.black87,
        unselectedLabelColor: AppTheme.grey600,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
        tabs: const [
          Tab(text: 'Created'),
          Tab(text: 'Liked'),
          Tab(text: 'Boosted'),
          Tab(text: 'Following'),
        ],
      ),
    );
  }

  Widget _buildCreatedEventsTab() {
    if (_createdEvents.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_outlined,
        title: 'No Created Events',
        message: 'You haven\'t created any events yet. Start creating events to see them here!',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(AppConstants.refreshDelay);
        // TODO: Refresh created events from API
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingL),
        itemCount: _createdEvents.length,
        itemBuilder: (context, index) {
          final event = _createdEvents[index];
          return EventCard(
            event: event,
            onLikeTap: () {
              // TODO: Implement like functionality
            },
            onBoost: () {
              // TODO: Implement boost functionality
            },
            onAddToCalendar: () {
              // TODO: Implement calendar integration
            },
            onFlag: () {
              // TODO: Implement flag functionality
            },
            onShare: () {
              // TODO: Implement share functionality
            },
          );
        },
      ),
    );
  }

  Widget _buildLikedEventsTab() {
    if (_likedEvents.isEmpty) {
      return _buildEmptyState(
        icon: Icons.favorite_border,
        title: 'No Liked Events',
        message: 'You haven\'t liked any events yet. Like events to save them here!',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(AppConstants.refreshDelay);
        // TODO: Refresh liked events from API
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingL),
        itemCount: _likedEvents.length,
        itemBuilder: (context, index) {
          final event = _likedEvents[index];
          return EventCard(
            event: event,
            onLikeTap: () {
              // TODO: Implement like functionality
            },
            onBoost: () {
              // TODO: Implement boost functionality
            },
            onAddToCalendar: () {
              // TODO: Implement calendar integration
            },
            onFlag: () {
              // TODO: Implement flag functionality
            },
            onShare: () {
              // TODO: Implement share functionality
            },
          );
        },
      ),
    );
  }

  Widget _buildBoostedEventsTab() {
    if (_boostedEvents.isEmpty) {
      return _buildEmptyState(
        icon: Icons.rocket_launch_outlined,
        title: 'No Boosted Events',
        message: 'You haven\'t boosted any events yet. Boost events to help them reach more people!',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(AppConstants.refreshDelay);
        // TODO: Refresh boosted events from API
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingL),
        itemCount: _boostedEvents.length,
        itemBuilder: (context, index) {
          final event = _boostedEvents[index];
          return EventCard(
            event: event,
            onLikeTap: () {
              // TODO: Implement like functionality
            },
            onBoost: () {
              // TODO: Implement boost functionality
            },
            onAddToCalendar: () {
              // TODO: Implement calendar integration
            },
            onFlag: () {
              // TODO: Implement flag functionality
            },
            onShare: () {
              // TODO: Implement share functionality
            },
          );
        },
      ),
    );
  }

  Widget _buildFollowedPagesTab() {
    if (_followedPages.isEmpty) {
      return _buildEmptyState(
        icon: Icons.people_outline,
        title: 'Not Following Anyone',
        message: 'Start following pages, categories, or users to see their events in your feed!',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(AppConstants.refreshDelay);
        // TODO: Refresh followed pages from API
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingL),
        itemCount: _followedPages.length,
        itemBuilder: (context, index) {
          final page = _followedPages[index];
          return _buildFollowedPageCard(page);
        },
      ),
    );
  }

  Widget _buildFollowedPageCard(Map<String, dynamic> page) {
    final isVerified = page['isVerified'] as bool;
    final followers = page['followers'] as int;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingXL,
        vertical: AppConstants.spacingS,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        border: Border.all(color: AppTheme.grey300),
        boxShadow: AppTheme.shadowSmall(context),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingXL,
          vertical: AppConstants.paddingL,
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.grey200,
              backgroundImage: NetworkImage(page['avatar'] as String),
              onBackgroundImageError: (exception, stackTrace) {},
              child: page['avatar'].toString().isEmpty
                  ? Icon(
                      Icons.person,
                      size: 28,
                      color: AppTheme.grey600,
                    )
                  : null,
            ),
            if (isVerified)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified,
                    size: 16,
                    color: AppTheme.blue600,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                page['name'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: AppConstants.fontSizeXL,
                      color: Colors.black87,
                    ),
              ),
            ),
            if (isVerified)
              Icon(
                Icons.verified,
                size: 16,
                color: AppTheme.blue600,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${_formatNumber(followers)} followers',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.grey600,
                    fontSize: AppConstants.fontSizeM,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              page['type'] == 'page' ? 'Page' : 'User',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.grey500,
                    fontSize: AppConstants.fontSizeS,
                  ),
            ),
          ],
        ),
        trailing: OutlinedButton(
          onPressed: () {
            // TODO: Implement unfollow functionality
            setState(() {
              _followedPages.removeAt(_followedPages.indexOf(page));
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unfollowed ${page['name']}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            side: BorderSide(color: AppTheme.grey300),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingL,
              vertical: AppConstants.paddingS,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
            ),
          ),
          child: const Text('Following'),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingHuge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppTheme.grey400,
            ),
            const SizedBox(height: AppConstants.spacingXL),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: AppConstants.fontSizeXXL,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.grey600,
                    fontSize: AppConstants.fontSizeL,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

