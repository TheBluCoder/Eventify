import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/location_controller.dart';
import '../controllers/discover_controller.dart';
import '../app/app_constants.dart';
import '../app/app_theme.dart';
import 'discover_map_view_page.dart';
import 'discover_feed_view.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchController = TextEditingController();
  late DiscoverState _discoverState;
  late List<Widget> _views;
  double _appBarOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _discoverState = DiscoverState();
    _views = [
      DiscoverFeedView(
        discoverState: _discoverState,
        onStateChanged: (updatedState) {
          setState(() {
            // State is already updated in place, just trigger rebuild
          });
        },
        onSheetPositionChanged: (position) {
          // Only update opacity when in feed view (not map view)
          if (!_discoverState.isMapView) {
            setState(() {
              // Calculate opacity based on sheet position
              // Sheet minChildSize: 0.6, maxChildSize: 0.98
              // When sheet is at 0.6, opacity = 1.0 (fully visible)
              // When sheet is at 0.98, opacity = 0.0 (fully hidden)
              const minSize = AppConstants.sheetMinSize;
              const maxSize = AppConstants.sheetMaxSize;
              if (position <= minSize) {
                _appBarOpacity = 1.0;
              } else if (position >= maxSize) {
                _appBarOpacity = 0.0;
              } else {
                // Linear interpolation between min and max
                _appBarOpacity = 1.0 - ((position - minSize) / (maxSize - minSize));
              }
            });
          }
        },
      ),
      MapViewPage(discoverState: _discoverState),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _discoverState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final appBar = AppBar(
        actionsIconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
        actionsPadding: EdgeInsets.only(bottom: 10),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto",
                ),
              ),
              Text(
                "Explore events around you",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: const Color.fromARGB(255, 97, 97, 97),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: null,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppConstants.blurSigma,
              sigmaY: AppConstants.blurSigma,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.shadowMedium(context),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Location selector button
              IconButton(
                onPressed: () {
                  _showLocationSelectorModal(context);
                },
                icon: Icon(
                  Icons.location_city_outlined,
                  color: Colors.grey[700],
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                tooltip: 'Select City/Country',
              ),
              // Search button
              IconButton(
                onPressed: () {
                  _showAdvancedSearchModal(context);
                },
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.grey[700],
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              // View toggle button
              _buildViewToggle(context),
            ],
          ),
        ),
      ],
    );
    
    final normalHeight = appBar.preferredSize.height;
    // When opacity is 0, completely hide the AppBar (height = 0)
    // When opacity > 0, show it with animated height
    final isHidden = _appBarOpacity <= 0.0;
    final currentHeight = isHidden ? 0.0 : normalHeight;
    
    return PreferredSize(
      preferredSize: Size.fromHeight(currentHeight),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: isHidden
            ? const SizedBox.shrink()
            : AnimatedOpacity(
                opacity: _appBarOpacity,
                duration: const Duration(milliseconds: 200),
                child: appBar,
              ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _discoverState.toggleView();
        });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(40, 40),
        backgroundColor: const Color.fromARGB(255, 41, 42, 43),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Icon(
        _discoverState.isMapView ? Icons.list_outlined : Icons.map_outlined,
        size: 18,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final locationController = context.read<LocationController>();
    
    // Update user location marker when location changes
    if (locationController.hasLocation && 
        _discoverState.isMapView && 
        locationController.userLocationCoords != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _discoverState.updateUserLocationMarker(locationController.userLocationCoords!);
        });
      });
    }

    // Reset AppBar opacity when switching to map view
    if (_discoverState.isMapView && _appBarOpacity != 1.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _appBarOpacity = 1.0;
        });
      });
    }

    return IndexedStack(
      index: _discoverState.isMapView ? 1 : 0,
      children: _views,
    );
  }


  void _showLocationSelectorModal(BuildContext context) {
    final popularCities = [
      {'name': 'Lagos, Nigeria', 'lat': 6.5244, 'lng': 3.3792},
      {'name': 'Abuja, Nigeria', 'lat': 9.0765, 'lng': 7.3986},
      {'name': 'Port Harcourt, Nigeria', 'lat': 4.8156, 'lng': 7.0498},
      {'name': 'Ibadan, Nigeria', 'lat': 7.3775, 'lng': 3.9470},
      {'name': 'Kano, Nigeria', 'lat': 12.0022, 'lng': 8.5919},
      {'name': 'Accra, Ghana', 'lat': 5.6037, 'lng': -0.1870},
      {'name': 'Nairobi, Kenya', 'lat': -1.2921, 'lng': 36.8219},
      {'name': 'Cairo, Egypt', 'lat': 30.0444, 'lng': 31.2357},
      {'name': 'Johannesburg, South Africa', 'lat': -26.2041, 'lng': 28.0473},
      {'name': 'Cape Town, South Africa', 'lat': -33.9249, 'lng': 18.4241},
    ];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Location',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a city or country to discover events',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Popular Cities',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: popularCities.length,
                itemBuilder: (context, index) {
                  final city = popularCities[index];
                  return ListTile(
                    leading: const Icon(Icons.location_city, color: Colors.blue),
                    title: Text(city['name'] as String),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Set pin location to selected city
                      final location = LatLng(
                        city['lat'] as double,
                        city['lng'] as double,
                      );
                      _discoverState.setPinLocation(location);
                      _discoverState.updateLocationName(city['name'] as String);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAdvancedSearchModal(BuildContext context) {
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
              'Advanced Search',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for events, locations, or categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quick Filters',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Tech', 'Music', 'Sports', 'Food', 'Art', 'Community'].map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: false,
                  onSelected: (selected) {
                    // TODO: Implement filter logic
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement search logic
                  Navigator.pop(context);
                },
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}