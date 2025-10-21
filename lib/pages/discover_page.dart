import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/location_controller.dart';
import '../controllers/discover_controller.dart';
import 'discover_map_view_page.dart';
import 'discover_feed_view.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiscoverController(),
      child: const _DiscoverPageContent(),
    );
  }
}

class _DiscoverPageContent extends StatefulWidget {
  const _DiscoverPageContent();

  @override
  State<_DiscoverPageContent> createState() => _DiscoverPageContentState();
}

class _DiscoverPageContentState extends State<_DiscoverPageContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
      title: Column(
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
              // Search button
              IconButton(
                onPressed: () {
                  _showAdvancedSearchModal(context);
                },
                icon: Icon(
                  Icons.search_outlined,
                  color: Colors.grey[700],
                  size: 24,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              Container(width: 1, height: 24, color: Colors.grey[300]),
              // View toggle button
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildViewToggle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return Consumer<DiscoverController>(
      builder: (context, discoverController, child) {
        return ElevatedButton(
          onPressed: () {
            discoverController.toggleView();
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
            discoverController.isMapView ? Icons.list_outlined : Icons.map_outlined,
            size: 18,
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer2<DiscoverController, LocationController>(
      builder: (context, discoverController, locationController, child) {
        // Update user location marker when location changes
        if (locationController.hasLocation && discoverController.isMapView && locationController.userLocationCoords != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            discoverController.updateUserLocationMarker(locationController.userLocationCoords!);
          });
        }

        if (discoverController.isMapView) {
          return const MapViewPage();
        }

        return const DiscoverFeedView();
      },
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