import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/discover_controller.dart';
import '../controllers/location_controller.dart';
import '../shared/models/event_model.dart';
import '../shared/data/placeholder.dart';
import '../app/app_constants.dart';
import '../app/app_theme.dart';
import '../shared/widgets/divider_section_header.dart';
import '../shared/widgets/distance_badge.dart';
import '../shared/widgets/image_loading_widget.dart';
import '../shared/widgets/shared_map_widget.dart';
import '../routes/app_routes.dart';

class DiscoverFeedView extends StatefulWidget {
  final DiscoverState discoverState;
  final Function(DiscoverState) onStateChanged;
  final Function(double)? onSheetPositionChanged;
  
  const DiscoverFeedView({
    super.key, 
    required this.discoverState,
    required this.onStateChanged,
    this.onSheetPositionChanged,
  });

  @override
  State<DiscoverFeedView> createState() => _DiscoverFeedViewState();
}

class _DiscoverFeedViewState extends State<DiscoverFeedView> {
  final ScrollController _scrollController = ScrollController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  String _selectedCategory = 'All Events';

  // Mock data for events
  final List<EventModel> _events = PlaceholderData.discoverEvents;
  final List<EventModel> _trendingEvents = PlaceholderData.trendingEvents;

  final List<String> _categories = PlaceholderData.discoverCategories;
  
  // Track liked events
  final Set<String> _likedEventIds = <String>{};
  
  // Track boosted events
  final Set<String> _boostedEventIds = <String>{};

  @override
  void initState() {
    super.initState();
    // Listen to sheet position changes
    _sheetController.addListener(_onSheetPositionChanged);
  }

  void _onSheetPositionChanged() {
    if (widget.onSheetPositionChanged != null) {
      final position = _sheetController.size;
      widget.onSheetPositionChanged!(position);
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetPositionChanged);
    _scrollController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final mapHeight = screenHeight * AppConstants.mapHeightPercentage;
    
    return Stack(
      children: [
        // Map View (Top 40%)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: mapHeight,
          child: _buildMapView(),
        ),
        // Draggable Sheet with Event List
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: AppConstants.sheetInitialSize,
          minChildSize: AppConstants.sheetMinSize,
          maxChildSize: AppConstants.sheetMaxSize,
          builder: (context, scrollController) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.borderRadiusL),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: AppConstants.shadowBlurL,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.only(
                        top: AppConstants.paddingM,
                        bottom: AppConstants.paddingM,
                      ),
                      width: AppConstants.dragHandleWidth,
                      height: AppConstants.dragHandleHeight,
                      decoration: BoxDecoration(
                        color: AppTheme.grey300,
                        borderRadius: BorderRadius.circular(AppConstants.paddingXS),
                      ),
                    ),
                    // Category filters
                    _buildCategoryFilters(),
                    const SizedBox(height: 8),
                    // Event List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(AppConstants.refreshDelay);
                        },
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingXL,
                          ),
                          children: [
                            const SizedBox(height: 8),
                            // Trending Events Section
                            if (_trendingEvents.isNotEmpty) ...[
                              _buildTrendingSection(),
                              const SizedBox(height: AppConstants.spacingXL),
                              // Nearby header
                              DividerSectionHeader(
                                title: 'Nearby',
                                onTap: () {
                                  context.push(
                                    AppRouter.eventsList,
                                    extra: {
                                      'title': 'Nearby Events',
                                      'events': _events,
                                    },
                                  );
                                },
                                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingS),
                              ),
                              const SizedBox(height: AppConstants.spacingXL),
                            ],
                            // Regular Events
                            ..._events.map((event) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GestureDetector(
                                onTap: () {
                                  context.push(AppRouter.viewEvent, extra: event);
                                },
                                child: _buildEventCard(event),
                              ),
                            )),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMapView() {
    return Consumer<LocationController>(
      builder: (context, locationController, child) {
        if (!locationController.hasLocation || locationController.userLocationCoords == null) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return SharedMapWidget(
          discoverState: widget.discoverState,
          onMapTap: (LatLng position) {
            // Place or update pin on map tap
            widget.discoverState.setPinLocation(position);
          },
          controlsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        );
      },
    );
  }

  Widget _buildTrendingSection() {
    if (_trendingEvents.isEmpty) return const SizedBox.shrink();
    
    final firstTrendingEvent = _trendingEvents.first;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.trending_up, size: 18, color: Colors.orange[600]),
              const SizedBox(width: 6),
              Text(
                'Trending Now',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            context.push(
              AppRouter.eventsList,
              extra: {
                'title': 'Trending Events',
                'events': _trendingEvents,
              },
            );
          },
          child: Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Event Image
                  Image.network(
                    firstTrendingEvent.mediaUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      );
                    },
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
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
                  ),
                  // Content
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Trending badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600]!.withAlpha(50),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.trending_up, size: 12, color: Colors.orange[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Trending',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Title
                                Text(
                                  firstTrendingEvent.title,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Stats
                                Row(
                                  children: [
                                    Icon(Icons.person_outline, size: 12, color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${firstTrendingEvent.interestedCount}',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.location_on, size: 12, color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        firstTrendingEvent.location,
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: Colors.white70,
                                          fontSize: 11,
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
                          // Arrow icon
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: AppConstants.categoryFilterHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: AppTheme.blue600,
              checkmarkColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white : AppTheme.grey700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppTheme.blue600 : AppTheme.grey300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(EventModel event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        border: Border.all(color: AppTheme.grey300),
        boxShadow: AppTheme.shadowSmall(context),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusXS),
              child: Stack(
                children: [
                  ImageLoadingWidget(
                    imageUrl: event.mediaUrl,
                    width: AppConstants.cardImageWidth,
                    height: AppConstants.cardImageHeight,
                    fit: BoxFit.cover,
                    errorIconSize: AppConstants.iconSizeHuge,
                  ),
                  if (event.isVideo)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  // Distance badge
                  Positioned(
                    top: AppConstants.paddingS,
                    right: AppConstants.paddingS,
                    child: DistanceBadge(
                      distance: event.formattedDistance,
                      fontSize: AppConstants.fontSizeS,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingS,
                        vertical: AppConstants.paddingXS,
                      ),
                      borderRadius: AppConstants.borderRadiusXS,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organizer info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(event.organizerAvatar),
                        onBackgroundImageError: (exception, stackTrace) {},
                        child: event.organizerAvatar.isEmpty 
                          ? Icon(Icons.person, size: 14, color: Colors.grey[600])
                          : null,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          event.organizerUsername,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Event title
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Date & Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.formattedDateTime,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.person_outline,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${event.interestedCount}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Tags and Action Buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: event.tags.take(2).map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                      // Like and Boost buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Like button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_likedEventIds.contains(event.id)) {
                                  _likedEventIds.remove(event.id);
                                } else {
                                  _likedEventIds.add(event.id);
                                }
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _likedEventIds.contains(event.id) || event.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 16,
                                color: _likedEventIds.contains(event.id) || event.isLiked
                                    ? Colors.red
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Boost button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_boostedEventIds.contains(event.id)) {
                                  _boostedEventIds.remove(event.id);
                                } else {
                                  _boostedEventIds.add(event.id);
                                }
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.rocket_launch,
                                size: 16,
                                color: _boostedEventIds.contains(event.id) || event.isBoosted
                                    ? Colors.orange
                                    : Colors.grey[700],
                              ),
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
      ),
    );
  }
}
