import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/location_controller.dart';
import '../controllers/discover_controller.dart';

class MapViewPage extends StatelessWidget {
  final DiscoverState discoverState;
  
  const MapViewPage({super.key, required this.discoverState});

  @override
  Widget build(BuildContext context) {
    return _OptimizedMapView(discoverState: discoverState);
  }
}

// ============================================
// ADVANCED: Optimized rebuild with Selector
// ============================================

class _OptimizedMapView extends StatelessWidget {
  final DiscoverState discoverState;
  
  const _OptimizedMapView({required this.discoverState});

  @override
  Widget build(BuildContext context) {
    // Only rebuilds when isLoading changes
    return Selector<LocationController, bool>(
      selector: (_, controller) => controller.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return _buildLoadingView();
        }
        return child!;
      },
      child: _MapContent(discoverState: discoverState),
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
  final DiscoverState discoverState;
  
  const _MapContent({required this.discoverState});

  @override
  Widget build(BuildContext context) {
    // Only rebuilds when markers or location changes
    return Selector<LocationController, LatLng?>(
      selector: (_, locationController) => locationController.userLocationCoords,
      builder: (context, location, child) {
        if (location == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Stack(
          children: [
            GoogleMap(
              onMapCreated: discoverState.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: location,
                zoom: 13.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              mapType: MapType.normal,
              markers: discoverState.markers,
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  _buildBottomControls(context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: discoverState.onFilterPressed,
                    child: const Icon(
                      Icons.filter_list_outlined,
                      color: Color.fromARGB(255, 15, 15, 15),
                      size: 25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      final locationController = context.read<LocationController>();
                      discoverState.onRecenterPressed(locationController.userLocationCoords);
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
    );
  }
}
