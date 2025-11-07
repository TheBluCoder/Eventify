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

  /// Creates a discovery pin marker (draggable)
  /// onDragEnd callback should be provided when creating the marker
  Marker createPinMarker(LatLng position, {Function(LatLng)? onDragEnd}) {
    return Marker(
      markerId: const MarkerId('discovery_pin'),
      position: position,
      draggable: true,
      infoWindow: const InfoWindow(title: 'Discovery Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
      onDragEnd: onDragEnd ?? (LatLng position) {},
    );
  }

  /// Adds or updates the discovery pin marker
  void updatePinMarker(LatLng position, {Function(LatLng)? onDragEnd}) {
    _markers.removeWhere((m) => m.markerId == const MarkerId('discovery_pin'));
    _markers.add(createPinMarker(position, onDragEnd: onDragEnd));
  }

  /// Removes the discovery pin marker
  void removePinMarker() {
    _markers.removeWhere((m) => m.markerId == const MarkerId('discovery_pin'));
  }
}