import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/location_controller.dart';
import '../controllers/discover_controller.dart';
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
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
            color: Colors.white60,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(221, 20, 20, 20).withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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
                  borderRadius: BorderRadius.circular(12),
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