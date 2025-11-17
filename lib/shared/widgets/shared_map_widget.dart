import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/discover_controller.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';
import '../../routes/app_routes.dart';

/// Shared map widget used by both DiscoverFeedView and MapViewPage
/// Ensures both views stay in sync with the same markers, styling, and behavior
class SharedMapWidget extends StatefulWidget {
  final DiscoverState discoverState;
  final Function(LatLng)? onMapTap;
  final bool showControls;
  final EdgeInsets? controlsPadding;
  
  const SharedMapWidget({
    super.key,
    required this.discoverState,
    this.onMapTap,
    this.showControls = true,
    this.controlsPadding,
  });

  @override
  State<SharedMapWidget> createState() => _SharedMapWidgetState();
}

class _SharedMapWidgetState extends State<SharedMapWidget> {
  // Cache map style futures for both light and dark themes
  static Future<String>? _lightMapStyleFuture;
  static Future<String>? _darkMapStyleFuture;

  // Track marker IDs to detect changes
  Set<String> _previousMarkerIds = {};

  // Load map style asynchronously based on theme
  Future<String> _loadMapStyle(bool isDarkMode) {
    if (isDarkMode) {
      _darkMapStyleFuture ??= () async {
        try {
          return await rootBundle.loadString('assets/dark_map_style.json');
        } catch (e) {
          debugPrint('Error loading dark map style: $e');
          return '';
        }
      }();
      return _darkMapStyleFuture!;
    } else {
      _lightMapStyleFuture ??= () async {
        try {
          return await rootBundle.loadString('assets/map_style.json');
        } catch (e) {
          debugPrint('Error loading light map style: $e');
          return '';
        }
      }();
      return _lightMapStyleFuture!;
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize marker IDs tracking
    _previousMarkerIds = widget.discoverState.markers
        .map((m) => m.markerId.value)
        .toSet();
    // Start periodic check for marker updates
    _checkMarkerUpdates();
  }

  void _checkMarkerUpdates() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      final currentMarkerIds = widget.discoverState.markers
          .map((m) => m.markerId.value)
          .toSet();
      
      // Only rebuild if marker IDs have changed
      if (currentMarkerIds != _previousMarkerIds) {
        setState(() {
          _previousMarkerIds = currentMarkerIds;
        });
      }
      
      // Continue checking
      _checkMarkerUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Selector<LocationController, LatLng?>(
      selector: (_, locationController) => locationController.userLocationCoords,
      builder: (context, location, child) {
        if (location == null) {
          return Container(
            color: isDarkMode ? AppTheme.darkBackground : Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Use current markers from shared state (always in sync)
        final currentMarkers = widget.discoverState.markers;

        return FutureBuilder<String>(
          future: _loadMapStyle(isDarkMode),
          builder: (context, snapshot) {
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: widget.discoverState.onMapCreated,
                  onTap: widget.onMapTap,
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: AppConstants.mapZoom,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  markers: _buildMarkersWithTapHandlers(context, currentMarkers),
                  style: snapshot.data,
                ),
                if (widget.showControls)
                  _buildMapControls(context, location),
              ],
            );
          },
        );
      },
    );
  }

  Set<Marker> _buildMarkersWithTapHandlers(BuildContext context, Set<Marker> markers) {
    return markers.map((marker) {
      final markerId = marker.markerId.value;
      // Only add tap handler for event markers
      if (markerId.startsWith('event_')) {
        return Marker(
          markerId: marker.markerId,
          position: marker.position,
          icon: marker.icon,
          infoWindow: marker.infoWindow,
          onTap: () {
            final eventId = markerId.substring(6); // Remove 'event_' prefix
            final event = widget.discoverState.getEventById(eventId);
            if (event != null) {
              context.push(AppRouter.viewEvent, extra: event);
            }
          },
        );
      }
      return marker;
    }).toSet();
  }

  Widget _buildMapControls(BuildContext context, LatLng userLocation) {
    final padding = widget.controlsPadding ?? 
        const EdgeInsets.only(right: 16.0, bottom: 16.0);
    
    return Positioned(
      bottom: padding.bottom,
      right: padding.right,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
            vertical: AppConstants.spacingL,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkSurface.withValues(alpha: 0.9)
                : Colors.white70,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusXL),
            boxShadow: AppTheme.shadowMedium(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  // Toggle pin placement mode
                  if (widget.discoverState.pinLocation != null) {
                    widget.discoverState.clearPinLocation();
                  } else {
                    widget.discoverState.setPinLocation(userLocation);
                  }
                },
                child: Icon(
                  widget.discoverState.pinLocation != null
                    ? Icons.location_on
                    : Icons.location_on_outlined,
                  color: widget.discoverState.pinLocation != null
                    ? AppTheme.red600
                    : AppTheme.iconColor(context),
                  size: AppConstants.iconSizeXXL + 5,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  widget.discoverState.onRecenterPressed(userLocation);
                },
                child: Icon(
                  Icons.my_location_outlined,
                  color: AppTheme.iconColor(context),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

