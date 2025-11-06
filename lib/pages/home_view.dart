import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/models/event_model.dart';
import '../shared/data/placeholder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFeedTab = 'Following'; // Following, For You

  // Following feed - events from followed organizers
  final List<EventModel> _followingEvents = PlaceholderData.followingEvents;

  // For You feed - personalized recommendations
  final List<EventModel> _forYouEvents = PlaceholderData.forYouEvents;

  // Upcoming events for horizontal scroll - shows events the user liked (is interested in)
  List<EventModel> get _upcomingEvents {
    final allEvents = [..._followingEvents, ..._forYouEvents];
    // Filter for upcoming events that the user has liked
    final likedUpcoming = allEvents
        .where((e) => e.isLiked && e.dateTime.isAfter(DateTime.now()))
        .toList();
    likedUpcoming.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return likedUpcoming.take(10).toList();
  }

  // Next upcoming event (first one for banner)
  EventModel? get _nextUpcomingEvent {
    return _upcomingEvents.isNotEmpty ? _upcomingEvents.first : null;
  }

  // Remaining upcoming events (after the banner)
  List<EventModel> get _remainingUpcomingEvents {
    return _upcomingEvents.length > 1 ? _upcomingEvents.sublist(1) : [];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchRegistrationUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open registration link')),
        );
      }
    }
  }

  List<EventModel> get _currentFeedEvents {
    return _selectedFeedTab == 'Following' ? _followingEvents : _forYouEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh logic
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + 38,
              bottom: kBottomNavigationBarHeight,
            ),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Big banner for next upcoming event
                if (_nextUpcomingEvent != null) ...[
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildNextUpcomingBanner(_nextUpcomingEvent!),
                  ),
                  const SizedBox(height: 16),
                ],

                // Smaller upcoming events cards in horizontal scroll
                if (_remainingUpcomingEvents.isNotEmpty) ...[
                  _buildRemainingUpcomingEventsScroll(),
                  const SizedBox(height: 24),
                ],
                // Event cards feed
                _buildEventCards(),
              ],
            ),
          ),
        ),

        // Sticky tabs at top center
        Positioned(
          top: kToolbarHeight + 22,
          left: 0,
          right: 0,
          child: _buildStickyFeedTabs(),
        ),
      ],
    );
  }

  Widget _buildNextUpcomingBanner(EventModel event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.network(
              event.mediaUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Content overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Next Event',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Date and Location
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.formattedDateTime,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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

  Widget _buildRemainingUpcomingEventsScroll() {
    if (_remainingUpcomingEvents.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isLandscape = screenWidth > MediaQuery.of(context).size.height;

        // Flexible card width: adapts to screen size
        // Portrait: 28-36% of width, Landscape: 20-28% of width
        // But constrained to min 200px and max 350px for readability
        final baseWidth = isLandscape ? screenWidth * 0.22 : screenWidth * 0.32;
        final cardWidth = baseWidth.clamp(200.0, 350.0);

        // Image height maintains aspect ratio
        final cardImageHeight = cardWidth * 0.60;

        // Content area height - flexible, will clip overflow
        final minContentHeight = 60.0;
        final maxContentHeight = cardWidth * 0.55;
        final contentHeight = maxContentHeight.clamp(
          minContentHeight,
          double.infinity,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Divider(height: 1, color: Colors.grey[200]),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'More Upcoming',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600] ,
                            ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: Colors.grey[200]),
                ],
              ),
            ),
            SizedBox(
              height: cardImageHeight + contentHeight + 5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _remainingUpcomingEvents.length,
                itemBuilder: (context, index) {
                  return _buildSquareEventCard(
                    _remainingUpcomingEvents[index],
                    cardWidth,
                    cardImageHeight,
                    contentHeight,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSquareEventCard(
    EventModel event,
    double cardWidth,
    double imageHeight,
    double contentHeight,
  ) {
    // Responsive padding: scales with card width (smaller cards = less padding)
    final padding = EdgeInsets.all((cardWidth * 0.04).clamp(4.0, 12.0));

    // Responsive font sizes: scale with card width
    final titleFontSize = (cardWidth * 0.04).clamp(11.0, 13.0);
    final bodyFontSize = (cardWidth * 0.033).clamp(9.0, 11.0);
    final iconSize = (cardWidth * 0.04).clamp(9.0, 11.0);

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image (fixed height)
          SizedBox(
            height: imageHeight,
            width: cardWidth,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    event.mediaUrl,
                    width: cardWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: cardWidth,
                        height: imageHeight,
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator.adaptive(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: cardWidth,
                        height: imageHeight,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                  if (event.isVideo)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_filled,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Video',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Distance badge
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.formattedDistance,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Event details (flexible height - clips overflow)
          SizedBox(
            height: contentHeight,
            child: Padding(
              padding: padding,
              child: ClipRect(
                child: SingleChildScrollView(
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent scrolling, just clip
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: titleFontSize,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Date/Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: iconSize,
                            color: Colors.blue[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _formatShortDateTime(event.dateTime),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontSize: bodyFontSize,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Location (will be clipped if no space)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: iconSize,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontSize: bodyFontSize - 1,
                                    color: Colors.grey[600],
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Attendee count (will be clipped if no space)
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: iconSize,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${event.interestedCount}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: bodyFontSize - 1,
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Tags (will be clipped if no space)
                      if (event.tags.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event.tags.first,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: bodyFontSize - 2,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatShortDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (eventDate == today) {
      return 'Today';
    } else if (eventDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}';
    }
  }

  Widget _buildStickyFeedTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFeedTab('Following', _selectedFeedTab == 'Following'),
            const SizedBox(width: 12),
            _buildFeedTab('For You', _selectedFeedTab == 'For You'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedTab(String label, bool isSelected) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedFeedTab = label;
        });
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        backgroundColor: isSelected
            ? Colors.black.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.5),
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _buildEventCards() {
    final events = _currentFeedEvents;
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No events yet',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedFeedTab == 'For You'
                        ? 'Recommended for you'
                        : 'Because you follow',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: Colors.grey[700]),
                  ),
                  Icon(Icons.arrow_forward_ios_outlined, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              Divider(height: 1, color: Colors.grey[200]),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...events.map((event) => _buildEventCard(event)),
      ],
    );
  }

  Widget _buildEventCard(EventModel event) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 2, right: 16, top: 12, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Organizer avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(event.organizerAvatar),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: event.organizerAvatar.isEmpty
                      ? Icon(Icons.person, size: 20, color: Colors.grey[600])
                      : null,
                ),

                const SizedBox(width: 12),

                // Content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Organizer name (wrapped, smaller, grey)
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  event.organizerUsername,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_horiz,
                              size: 18,
                              color: Colors.grey[600],
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Image with overlays - Maintains aspect ratio with max width
                      if (event.mediaUrl.isNotEmpty)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio:
                                  16 / 9, // Common aspect ratio for media
                              child: _buildEventImageWithOverlays(event),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Column with event title, location, time, and partial description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event title (reduced size)
                          Text(
                            event.title,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontSize: 14,
                                  height: 1.3,
                                ),
                          ),
                          const SizedBox(height: 8),
                          // Time with icon
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                event.formattedDateTime,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Location with icon
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Partial description (truncated)
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              event.description,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Tags
                      if (event.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: event.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[500]!.withValues(alpha:0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],

                      // Registration button (if registration URL exists)
                      if (event.registrationUrl != null &&
                          event.registrationUrl!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _launchRegistrationUrl(event.registrationUrl!),
                            icon: const Icon(Icons.event_available, size: 16),
                            label: const Text('Register / Get Tickets'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue[700],
                              side: BorderSide(color: Colors.blue[700]!),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventImageWithOverlays(EventModel event) {
    return Stack(
      children: [
        Image.network(
          event.mediaUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
            );
          },
        ),
        // Like icon on top-left
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                // Toggle like state
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                event.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: event.isLiked ? Colors.red : Colors.white,
              ),
            ),
          ),
        ),
        // Location and Distance stacked on top-right
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Distance badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  event.formattedDistance,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Location badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  event.location,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        // Video indicator if it's a video (centered play button)
        if (event.isVideo)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, size: 32, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
