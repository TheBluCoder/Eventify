import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return const _HomePageContent();
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    // No need for Consumer here since we're using Selector below
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: const _OptimizedMapView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
      ),
      actions: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(148, 110, 152, 179),
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 60, 61, 60)
                          .withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_3_rounded,
                      color: Colors.black54,
                    ),
                  ),
                ),
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.85),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 0.0,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black54,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: 'communities',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'create'),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}

// ============================================
// ADVANCED: Optimized rebuild with Selector
// ============================================

class _OptimizedMapView extends StatelessWidget {
  const _OptimizedMapView();

  @override
  Widget build(BuildContext context) {
    // Only rebuilds when isLoading changes
    return Selector<HomePageController, bool>(
      selector: (_, controller) => controller.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return _buildLoadingView();
        }
        return child!;
      },
      child: const _MapContent(),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading ...",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class _MapContent extends StatelessWidget {
  const _MapContent();

  @override
  Widget build(BuildContext context) {
    // Only rebuilds when markers or location changes
    return Selector<HomePageController,
        ({Set<Marker> markers, LatLng? location})>(
      selector: (_, controller) => (
        markers: controller.markers,
        location: controller.userLocationCoords,
      ),
      builder: (context, data, child) {
        // IMPORTANT: Use 'data' parameter, not context.read()
        // This ensures the widget rebuilds when the selected values change
        return Stack(
          children: [
            GoogleMap(
              onMapCreated: context.read<HomePageController>().onMapCreated,
              initialCameraPosition: CameraPosition(
                target: data.location!, // Use data from selector
                zoom: 13.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              mapType: MapType.normal,
              markers: data.markers, // Use data from selector
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildViewToggle(),
                  const Spacer(),
                  _buildBottomControls(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewToggle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 213, 218, 220)
                .withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => ElevatedButton(
                      onPressed:
                          context.read<HomePageController>().onMapViewPressed,
                      child: const Icon(
                        Icons.map_outlined,
                        color: Color.fromARGB(221, 50, 48, 48),
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Builder(
                    builder: (context) => TextButton(
                      onPressed:
                          context.read<HomePageController>().onListViewPressed,
                      child: const Icon(
                        Icons.list_outlined,
                        color: Color.fromARGB(221, 50, 48, 48),
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Builder(
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: context.read<HomePageController>().onFilterPressed,
                    child: const Icon(
                      Icons.filter_list_outlined,
                      color: Color.fromARGB(255, 242, 243, 244),
                      size: 25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: context.read<HomePageController>().onRecenterPressed,
                    child: const Icon(
                      Icons.my_location_outlined,
                      color: Color.fromARGB(255, 243, 244, 244),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}