import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// Service responsible for location operations
class LocationService {
  final Location _location;

  LocationService({Location? location}) : _location = location ?? Location();

  /// Checks if location service is enabled and requests if not
  Future<bool> ensureServiceEnabled() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  /// Checks and requests location permission
  Future<bool> ensurePermissionGranted() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  /// Gets the current user location coordinates
  Future<LatLng?> getUserLocationCoords() async {
    final serviceEnabled = await ensureServiceEnabled();
    if (!serviceEnabled) return null;

    final permissionGranted = await ensurePermissionGranted();
    if (!permissionGranted) return null;

    final locationData = await _location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return null;
    }

    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  /// Creates a stream of location updates
  Stream<LatLng> getLocationStream() {
    return _location.onLocationChanged
        .where((location) =>
            location.latitude != null && location.longitude != null)
        .map((location) => LatLng(location.latitude!, location.longitude!));
  }
}