import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Manages map markers
class MarkerManager {
  final Set<Marker> _markers = {};

  Set<Marker> get markers => Set.unmodifiable(_markers);

  /// Creates a user location marker
  Marker createUserLocationMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('user_location'),
      position: position,
      infoWindow: const InfoWindow(title: 'You are here'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure,
      ),
    );
  }

  /// Adds or updates the user location marker
  void updateUserLocationMarker(LatLng position) {
    _markers.removeWhere((m) => m.markerId == const MarkerId('user_location'));
    _markers.add(createUserLocationMarker(position));
  }

  /// Adds a marker to the set
  void addMarker(Marker marker) {
    _markers.add(marker);
  }

  /// Removes a marker by ID
  void removeMarker(MarkerId markerId) {
    _markers.removeWhere((m) => m.markerId == markerId);
  }

  /// Clears all markers
  void clearMarkers() {
    _markers.clear();
  }

  /// Gets a marker by ID
  Marker? getMarker(MarkerId markerId) {
    try {
      return _markers.firstWhere((m) => m.markerId == markerId);
    } catch (e) {
      return null;
    }
  }
}