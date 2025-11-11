import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/location_controller.dart';
import '../controllers/discover_controller.dart';
import '../shared/widgets/shared_map_widget.dart';

class MapViewPage extends StatelessWidget {
  final DiscoverState discoverState;
  
  const MapViewPage({super.key, required this.discoverState});

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
      child: SharedMapWidget(
        discoverState: discoverState,
        // No onMapTap for map view page (commented out in original)
        showControls: true,
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Loading ...",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
