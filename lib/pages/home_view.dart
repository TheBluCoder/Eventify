import 'package:flutter/material.dart';
import '../shared/models/event_model.dart';
import '../shared/data/placeholder.dart';
import '../app/app_constants.dart';
import '../app/app_theme.dart';
import '../shared/widgets/event_card.dart';
import '../shared/widgets/empty_state_widget.dart';
import '../shared/widgets/divider_section_header.dart';
import '../shared/widgets/distance_badge.dart';
import '../shared/widgets/video_badge.dart';
import '../shared/widgets/image_loading_widget.dart';
import '../shared/utils/url_launcher_util.dart';
import '../shared/utils/date_time_formatter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  // String _selectedFeedTab = AppConstants.feedTabFollowing;

  // Following feed - events from followed organizers
  final List<EventModel> _followingEvents = PlaceholderData.followingEvents;

  // For You feed - personalized recommendations
  final List<EventModel> _forYouEvents = PlaceholderData.forYouEvents;

  // Track events added to calendar (by event ID)
  final Set<String> _eventsAddedToCalendar = <String>{};

  // Upcoming events for horizontal scroll - shows events the user is interested in or created
  // NOTE: We are NOT using isLiked to filter upcoming events. Instead, we use:
  // - Events added to calendar via "Add to Calendar" in dropdown menu (tracked in _eventsAddedToCalendar)
  // - isUserEvent (events the user created)
  // The "Add to Calendar" action in the event card dropdown will add events to this upcoming section.
  List<EventModel> get _upcomingEvents {
    // Include both following and forYou events for upcoming section
    final allEvents = [..._followingEvents, ..._forYouEvents];
    // Filter for upcoming events that the user has added to calendar OR events they created
    final upcoming = allEvents
        .where((e) => 
            (_eventsAddedToCalendar.contains(e.id) || e.isUserEvent) && 
            e.dateTime.isAfter(DateTime.now()))
        .toList();
    upcoming.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return upcoming.take(10).toList();
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
    await UrlLauncherUtil.launchURL(url, context: context);
  }

  void _handleAddToCalendar(EventModel event) {
    setState(() {
      _eventsAddedToCalendar.add(event.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event.title} added to your upcoming events'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleFlag(EventModel event) {
    // TODO: Implement flag/report functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Flagged: ${event.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleShare(EventModel event) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${event.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBoost(EventModel event) {
    // TODO: Implement boost functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Boosted: ${event.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<EventModel> get _currentFeedEvents {
    // Always return following events for now
    return _followingEvents;
    // return _selectedFeedTab == AppConstants.feedTabFollowing
    //     ? _followingEvents
    //     : _forYouEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement refresh logic
            await Future.delayed(AppConstants.refreshDelay);
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + AppConstants.spacingXL,
              bottom: kBottomNavigationBarHeight,
            ),
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Big banner for next upcoming event
                if (_nextUpcomingEvent != null) ...[
                  AspectRatio(
                    aspectRatio: AppConstants.aspectRatio16_9,
                    child: _buildNextUpcomingBanner(_nextUpcomingEvent!),
                  ),
                  const SizedBox(height: AppConstants.spacingXL),
                ],

                // Smaller upcoming events cards in horizontal scroll
                if (_remainingUpcomingEvents.isNotEmpty) ...[
                  _buildRemainingUpcomingEventsScroll(),
                  const SizedBox(height: AppConstants.spacingXXXL),
                ],
                // Event cards feed
                _buildEventCards(),
              ],
            ),
          ),
        ),

        // Sticky tabs at top center - COMMENTED OUT
        // Positioned(
        //   top: kToolbarHeight + AppConstants.spacingXXL,
        //   left: 0,
        //   right: 0,
        //   child: _buildStickyFeedTabs(),
        // ),
      ],
    );
  }

  Widget _buildNextUpcomingBanner(EventModel event) {
    return Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
          height: AppConstants.bannerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
            boxShadow: AppTheme.shadowLarge(context),
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
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
              decoration: AppTheme.gradientOverlay,
            ),
            // Content overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingXXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badges
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingL,
                            vertical: AppConstants.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: AppConstants.opacityLight),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Next Event',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: AppConstants.fontSizeM,
                            ),
                          ),
                        ),
                        if (event.isUserEvent) ...[
                          const SizedBox(width: AppConstants.spacingM),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingL,
                              vertical: AppConstants.paddingS,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: AppConstants.opacityLight),
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event,
                                  size: AppConstants.iconSizeS,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: AppConstants.paddingXS),
                                Text(
                                  'Hosting',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppConstants.fontSizeM,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingL),
                    // Title
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeTitle,
                        shadows: AppTheme.textShadow,
                      ),
                      maxLines: AppConstants.maxLinesTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.paddingM),
                    // Date and Location
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: AppConstants.iconSizeM,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: AppConstants.paddingS),
                        Text(
                          event.formattedDateTime,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70, fontSize: AppConstants.fontSizeL),
                        ),
                        const SizedBox(width: AppConstants.spacingXL),
                        Icon(
                          Icons.location_on,
                          size: AppConstants.iconSizeM,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: AppConstants.paddingS),
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
      },
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
        final baseWidth = isLandscape
            ? screenWidth * AppConstants.cardWidthLandscapePercentage
            : screenWidth * AppConstants.cardWidthPortraitPercentage;
        final cardWidth = baseWidth.clamp(
          AppConstants.cardWidthMin,
          AppConstants.cardWidthMax,
        );

        // Image height maintains aspect ratio
        final cardImageHeight = cardWidth * AppConstants.aspectRatioCard;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DividerSectionHeader(
              title: 'More Upcoming',
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingXL,
                vertical: AppConstants.paddingM,
              ),
            ),
            SizedBox(
              height: cardImageHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                itemCount: _remainingUpcomingEvents.length,
                itemBuilder: (context, index) {
                  return _buildSquareEventCard(
                    _remainingUpcomingEvents[index],
                    cardWidth,
                    cardImageHeight,
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
  ) {
    // Responsive font sizes: scale with card width
    final titleFontSize = (cardWidth * 0.04).clamp(11.0, 13.0);
    final bodyFontSize = (cardWidth * 0.033).clamp(9.0, 11.0);
    final iconSize = (cardWidth * 0.04).clamp(9.0, 11.0);

    return Builder(
      builder: (context) {
        return Container(
          width: cardWidth,
          margin: const EdgeInsets.only(right: AppConstants.spacingL),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
            border: Border.all(color: AppTheme.grey300),
            boxShadow: AppTheme.shadowSmall(context),
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        child: SizedBox(
          height: imageHeight,
          width: cardWidth,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              ImageLoadingWidget(
                imageUrl: event.mediaUrl,
                width: cardWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                errorIconSize: AppConstants.iconSizeHuge,
              ),
              // Gradient overlay
              Container(
                decoration: AppTheme.gradientOverlay,
              ),
              // Small badges at top
              if (event.isVideo)
                Positioned(
                  top: AppConstants.paddingS,
                  left: AppConstants.paddingS,
                  child: const VideoBadge(),
                ),
              // Hosting badge (if user created event)
              if (event.isUserEvent)
                Positioned(
                  top: AppConstants.paddingS,
                  left: event.isVideo ? 50 : AppConstants.paddingS,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingS,
                      vertical: AppConstants.paddingXS,
                    ),
                    decoration: AppTheme.badgeDecoration(
                      color: Colors.blue,
                      borderRadius: AppConstants.borderRadiusXS,
                      opacity: AppConstants.opacityHeavy,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event,
                          size: AppConstants.iconSizeXS,
                          color: Colors.white,
                        ),
                        const SizedBox(width: AppConstants.paddingXS),
                        Text(
                          'Hosting',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize: AppConstants.fontSizeXS,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Attendee count overlay at top left
              Positioned(
                top: AppConstants.paddingS,
                left: _getAttendeeBadgeLeftPosition(event),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingS,
                    vertical: AppConstants.paddingXS,
                  ),
                  decoration: AppTheme.badgeDecoration(
                    color: Colors.black,
                    borderRadius: AppConstants.borderRadiusXS,
                    opacity: AppConstants.opacityHeavy,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: AppConstants.iconSizeXS,
                        color: Colors.white,
                      ),
                      const SizedBox(width: AppConstants.paddingXS),
                      Text(
                        '${event.interestedCount}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeXS,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Distance badge at top right
              Positioned(
                top: AppConstants.paddingS,
                right: AppConstants.paddingS,
                child: DistanceBadge(
                  distance: event.formattedDistance,
                  fontSize: AppConstants.fontSizeXS,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingS,
                    vertical: AppConstants.paddingXS,
                  ),
                  borderRadius: AppConstants.borderRadiusXS,
                ),
              ),
              // Content overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize + 2,
                          shadows: AppTheme.textShadow,
                        ),
                        maxLines: AppConstants.maxLinesTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      // Date and Location
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: iconSize,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: AppConstants.paddingS),
                          Text(
                            _formatShortDateTime(event.dateTime),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.white70,
                                  fontSize: bodyFontSize,
                                ),
                          ),
                          const SizedBox(width: AppConstants.spacingL),
                          Icon(
                            Icons.location_on,
                            size: iconSize,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: AppConstants.paddingS),
                          Expanded(
                            child: Text(
                              event.location,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: bodyFontSize,
                                  ),
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
      ),
        );
      },
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
      return DateTimeFormatter.formatShortDateTime(dateTime);
    }
  }

  double _getAttendeeBadgeLeftPosition(EventModel event) {
    double left = AppConstants.paddingS;
    if (event.isVideo) {
      left = 50; // Position after video badge
    }
    if (event.isUserEvent) {
      // Position after hosting badge (approximately 80px wide)
      left = event.isVideo ? 130 : 80;
    }
    return left;
  }

  // COMMENTED OUT - Sticky feed tabs functionality
  // Widget _buildStickyFeedTabs() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingS),
  //     child: Center(
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           _buildFeedTab(
  //             AppConstants.feedTabFollowing,
  //             _selectedFeedTab == AppConstants.feedTabFollowing,
  //           ),
  //           const SizedBox(width: AppConstants.spacingL),
  //           _buildFeedTab(
  //             AppConstants.feedTabForYou,
  //             _selectedFeedTab == AppConstants.feedTabForYou,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildFeedTab(String label, bool isSelected) {
  //   return TextButton(
  //     onPressed: () {
  //       setState(() {
  //         _selectedFeedTab = label;
  //       });
  //     },
  //     style: TextButton.styleFrom(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: AppConstants.spacingL,
  //         vertical: AppConstants.paddingXS,
  //       ),
  //       backgroundColor: isSelected
  //           ? Colors.black.withValues(alpha: AppConstants.opacityVeryHeavy)
  //           : Colors.white.withValues(alpha: AppConstants.opacityMedium),
  //       foregroundColor: isSelected ? Colors.white : Colors.black,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(AppConstants.borderRadiusXL),
  //       ),
  //     ),
  //     child: Text(
  //       label,
  //       style: TextStyle(
  //         fontWeight: FontWeight.w600,
  //         fontSize: AppConstants.fontSizeXL,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEventCards() {
    final events = _currentFeedEvents;
    if (events.isEmpty) {
      return const EmptyStateWidget(message: 'No events yet');
    }

    final hasUpcomingEvents = _upcomingEvents.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only show "Because you follow" header when there are upcoming events
        if (hasUpcomingEvents) ...[
          DividerSectionHeader(
            title: 'Because you follow',
            // title: _selectedFeedTab == AppConstants.feedTabForYou
            //               ? 'Recommended for you'
            //               : 'Because you follow',
          ),
          const SizedBox(height: AppConstants.paddingM),
        ],
        ...events.map(
          (event) => EventCard(
            event: event,
            onRegistrationTap: () => _launchRegistrationUrl(
              event.registrationUrl ?? '',
            ),
            onAddToCalendar: () => _handleAddToCalendar(event),
            onFlag: () => _handleFlag(event),
            onShare: () => _handleShare(event),
            onBoost: () => _handleBoost(event),
          ),
        ),
      ],
    );
  }

}
