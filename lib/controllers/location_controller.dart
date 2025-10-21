import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/services/location_service.dart';

/// App-wide location management controller
/// Provides user location data to all pages that need it
class LocationController extends ChangeNotifier {
  final LocationService _locationService;

  LatLng? _userLocationCoords;
  StreamSubscription<LatLng>? _locationSubscription;
  bool _isLoading = true;
  bool _hasLocationPermission = false;

  LocationController({
    LocationService? locationService,
  }) : _locationService = locationService ?? LocationService();

  // Getters
  LatLng? get userLocationCoords => _userLocationCoords;
  bool get isLoading => _isLoading;
  bool get hasLocationPermission => _hasLocationPermission;
  bool get hasLocation => _userLocationCoords != null;

  /// Initializes location tracking
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final coords = await _locationService.getUserLocationCoords();
    if (coords != null) {
      _userLocationCoords = coords;
      _hasLocationPermission = true;
      _isLoading = false;
      notifyListeners();

      _startLocationTracking();
    } else {
      _hasLocationPermission = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Starts listening to location updates
  void _startLocationTracking() {
    _locationSubscription = _locationService.getLocationStream().listen(
      (LatLng newLocation) {
        _updateUserLocation(newLocation);
      },
    );
  }

  /// Updates user location
  void _updateUserLocation(LatLng newLocation) {
    debugPrint(
        'Location update: ${newLocation.latitude}, ${newLocation.longitude}');

    _userLocationCoords = newLocation;
    notifyListeners();
  }

  /// Requests location permission
  Future<bool> requestLocationPermission() async {
    final coords = await _locationService.getUserLocationCoords();
    if (coords != null) {
      _userLocationCoords = coords;
      _hasLocationPermission = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
