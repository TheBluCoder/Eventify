import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/discover_controller.dart';
import '../controllers/location_controller.dart';
import '../shared/models/event_model.dart';
import '../shared/data/placeholder.dart';
import 'events_list_page.dart';

class DiscoverFeedView extends StatefulWidget {
  final DiscoverState discoverState;
  final Function(DiscoverState) onStateChanged;
  
  const DiscoverFeedView({
    super.key, 
    required this.discoverState,
    required this.onStateChanged,
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

  @override
  void dispose() {
    _scrollController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final mapHeight = screenHeight * 0.4; // 40% of screen height
    
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
          initialChildSize: 0.6, // Start at 60% (leaving 40% for map)
          minChildSize: 0.6, // Minimum 60% (map still visible)
          maxChildSize: 0.98, // Maximum 98% (almost full screen)
          builder: (context, scrollController) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Category filters
                    _buildCategoryFilters(),
                    const SizedBox(height: 8),
                    // Event List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            const SizedBox(height: 8),
                            // Trending Events Section
                            if (_trendingEvents.isNotEmpty) ...[
                              _buildTrendingSection(),
                              const SizedBox(height: 16),
                              // Divider after trending
                              Divider(height: 1, color: Colors.grey[200]),
                              const SizedBox(height: 8),
                              // Nearby header
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventsListPage(
                                          title: 'Nearby Events',
                                          events: _events,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Nearby',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_outlined, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Divider after nearby header
                              Divider(height: 1, color: Colors.grey[200]),
                              const SizedBox(height: 16),
                            ],
                            // Regular Events
                            ..._events.map((event) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildEventCard(event),
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

        return Stack(
          children: [
            // Google Map
            GoogleMap(
              onMapCreated: widget.discoverState.onMapCreated,
              onTap: (LatLng position) {
                // Place or update pin on map tap
                widget.discoverState.setPinLocation(position);
              },
              initialCameraPosition: CameraPosition(
                target: locationController.userLocationCoords!,
                zoom: 13.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              mapType: MapType.normal,
              markers: widget.discoverState.markers,
            ),
            // Map Controls (Bottom Right)
            Positioned(
              bottom: 16,
              right: 16,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Toggle pin placement mode
                              if (widget.discoverState.pinLocation != null) {
                                widget.discoverState.clearPinLocation();
                              } else if (locationController.userLocationCoords != null) {
                                widget.discoverState.setPinLocation(locationController.userLocationCoords!);
                              }
                            },
                            child: Icon(
                              widget.discoverState.pinLocation != null 
                                ? Icons.location_on 
                                : Icons.location_on_outlined,
                              color: widget.discoverState.pinLocation != null
                                ? Colors.red[600]
                                : const Color.fromARGB(255, 15, 15, 15),
                              size: 25,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              widget.discoverState.onRecenterPressed(
                                locationController.userLocationCoords!,
                              );
                            },
                            child: const Icon(
                              Icons.my_location_outlined,
                              color: Color.fromARGB(255, 15, 15, 15),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventsListPage(
                  title: 'Trending Events',
                  events: _trendingEvents,
                ),
              ),
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
                                    color: Colors.orange[600],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.trending_up, size: 12, color: Colors.white),
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
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              selectedColor: Colors.blue[600],
              checkmarkColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Image.network(
                    event.mediaUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
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
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
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
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.formattedDistance,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                  // Tags
                  Wrap(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
