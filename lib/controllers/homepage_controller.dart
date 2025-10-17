import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/location_service.dart';
import '../utils/marker_manager.dart';
import '../utils/map_controller_wrapper.dart';

/// Controller for HomePage logic
class HomePageController extends ChangeNotifier {
  final LocationService _locationService;
  final MarkerManager _markerManager;
  final MapControllerWrapper _mapControllerWrapper;

  LatLng? _userLocationCoords;
  StreamSubscription<LatLng>? _locationSubscription;
  bool _isLoading = true;

  HomePageController({
    LocationService? locationService,
    MarkerManager? markerManager,
    MapControllerWrapper? mapControllerWrapper,
  })  : _locationService = locationService ?? LocationService(),
        _markerManager = markerManager ?? MarkerManager(),
        _mapControllerWrapper = mapControllerWrapper ?? MapControllerWrapper();

  // Getters
  LatLng? get userLocationCoords => _userLocationCoords;
  Set<Marker> get markers => _markerManager.markers;
  bool get isLoading => _isLoading;

  /// Initializes location tracking
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final coords = await _locationService.getUserLocationCoords();
    if (coords != null) {
      _userLocationCoords = coords;
      _markerManager.updateUserLocationMarker(coords);
      _isLoading = false;
      notifyListeners();

      _startLocationTracking();
    } else {
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

  /// Updates user location and marker
  void _updateUserLocation(LatLng newLocation) {
    debugPrint(
        '\n\nLocation update: ${newLocation.latitude}, ${newLocation.longitude}');

    _userLocationCoords = newLocation;
    _markerManager.updateUserLocationMarker(newLocation);
    _mapControllerWrapper.animateCameraToPosition(newLocation);
    notifyListeners();
  }

  /// Sets the map controller
  void onMapCreated(GoogleMapController controller) {
    _mapControllerWrapper.setController(controller);
  }

 /// Handles filter button press
  void onRecenterPressed() {
    // Implement filter logic
    debugPrint('Filter button pressed');
  }


  /// Handles filter button press
  void onFilterPressed() {
    // Implement filter logic
    debugPrint('Filter button pressed');
  }

  /// Handles map view button press
  void onMapViewPressed() {
    // Implement map view logic
    debugPrint('Map view button pressed');
  }

  /// Handles list view button press
  void onListViewPressed() {
    // Implement list view logic
    debugPrint('List view button pressed');
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _mapControllerWrapper.dispose();
    super.dispose();
  }
}