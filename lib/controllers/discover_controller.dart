import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/utils/marker_manager.dart';
import '../core/utils/map_controller_wrapper.dart';
import '../shared/data/placeholder.dart';
import '../shared/models/event_model.dart';

/// State class for DiscoverPage logic
/// Handles map-specific functionality and view switching
class DiscoverState {
  final MarkerManager _markerManager;
  final MapControllerWrapper _mapControllerWrapper;

  bool _isMapView = false; // Local state for view switching
  bool _hasInitiallyPositionedCamera = false;
  
  // Filter and discovery properties
  String _selectedCategory = 'All';
  int _eventCount = 247; // Mock data - will be replaced with real data
  int _radiusKm = 5;
  String _locationName = 'Lagos, Nigeria'; // Mock data - will be replaced with real location
  String _dateRange = 'Anytime';
  String _eventType = 'All';
  String _priceFilter = 'All';
  bool _verifiedOnly = false;
  String _sortBy = 'Distance';
  
  // Pin location for discovery
  LatLng? _pinLocation;

  DiscoverState({
    MarkerManager? markerManager,
    MapControllerWrapper? mapControllerWrapper,
  })  : _markerManager = markerManager ?? MarkerManager(),
        _mapControllerWrapper = mapControllerWrapper ?? MapControllerWrapper();

  // Getters
  bool get isMapView => _isMapView;
  Set<Marker> get markers => _markerManager.markers;
  String get selectedCategory => _selectedCategory;
  int get eventCount => _eventCount;
  int get radiusKm => _radiusKm;
  String get locationName => _locationName;
  String get dateRange => _dateRange;
  String get eventType => _eventType;
  String get priceFilter => _priceFilter;
  bool get verifiedOnly => _verifiedOnly;
  String get sortBy => _sortBy;
  LatLng? get pinLocation => _pinLocation;
  
  bool get hasActiveFilters => 
    _selectedCategory != 'All' ||
    _dateRange != 'Anytime' ||
    _eventType != 'All' ||
    _priceFilter != 'All' ||
    _verifiedOnly;

  /// Toggles between map and list view
  void toggleView() {
    _isMapView = !_isMapView;
  }

  /// Sets map view
  void setMapView() {
    _isMapView = true;
  }

  /// Sets list view
  void setListView() {
    _isMapView = false;
  }

  /// Sets the map controller and loads event markers
  void onMapCreated(GoogleMapController controller) {
    _mapControllerWrapper.setController(controller);
    _loadEventMarkers();
  }

  /// Loads event markers with custom icons
  Future<void> _loadEventMarkers() async {
    // Get all discover events
    final events = PlaceholderData.discoverEvents;
    
    // Clear existing event markers
    _markerManager.clearEventMarkers();
    
    // Create markers for each event
    for (final event in events) {
      try {
        // Get custom marker icon from event's mediaUrl
        // Creates a circular marker with white border and shadow
        final customIcon = await MarkerManager.getCustomMarkerIcon(
          imageUrl: event.mediaUrl,
          size: const Size(48, 48),
          isCircular: true,
          borderWidth: 2.0,
          borderColor: Colors.white,
          shadowBlur: 4.0,
        );
        
        // Create event marker
        final marker = _markerManager.createEventMarker(
          eventId: event.id,
          position: LatLng(event.latitude, event.longitude),
          title: event.title,
          icon: customIcon,
        );
        
        // Add marker to the set
        _markerManager.addEventMarker(marker);
      } catch (e) {
        debugPrint('Error creating marker for event ${event.id}: $e');
      }
    }
  }

  /// Handles recenter button press
  void onRecenterPressed(LatLng? userLocation) {
    if (userLocation != null) {
      _mapControllerWrapper.animateCameraToPosition(userLocation);
    }
    debugPrint('Recenter button pressed');
  }

  /// Updates user location marker
  void updateUserLocationMarker(LatLng location) {
    _markerManager.updateUserLocationMarker(location);
    
    // Only animate camera to user location on initial positioning
    if (!_hasInitiallyPositionedCamera) {
      _mapControllerWrapper.animateCameraToPosition(location);
      _hasInitiallyPositionedCamera = true;
    }
  }

  /// Handles filter button press
  void onFilterPressed() {
    debugPrint('Filter button pressed');
    // TODO: Implement filter logic
  }

  // Filter and discovery methods
  void selectCategory(String category) {
    _selectedCategory = category;
    _updateEventCount();
  }

  void setRadius(int radiusKm) {
    _radiusKm = radiusKm;
    _updateEventCount();
  }

  void setDateRange(String range) {
    _dateRange = range;
    _updateEventCount();
  }

  void setEventType(String type) {
    _eventType = type;
    _updateEventCount();
  }

  void setPriceFilter(String price) {
    _priceFilter = price;
    _updateEventCount();
  }

  void setVerifiedOnly(bool value) {
    _verifiedOnly = value;
    _updateEventCount();
  }

  void setSortBy(String sortOption) {
    _sortBy = sortOption;
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _dateRange = 'Anytime';
    _eventType = 'All';
    _priceFilter = 'All';
    _verifiedOnly = false;
    _radiusKm = 5;
    _updateEventCount();
  }

  void updateLocationName(String name) {
    _locationName = name;
  }

  /// Sets the pin location for discovery
  void setPinLocation(LatLng location) {
    _pinLocation = location;
    _markerManager.updatePinMarker(
      location,
      onDragEnd: onPinDragEnd,
    );
    // Animate camera to pin location
    _mapControllerWrapper.animateCameraToPosition(location);
    // Update location name based on pin location
    // TODO: Implement reverse geocoding to get location name
    _updateEventCount();
  }

  /// Clears the pin location (revert to user location)
  void clearPinLocation() {
    _pinLocation = null;
    _markerManager.removePinMarker();
    _updateEventCount();
  }

  /// Handles pin drag end
  void onPinDragEnd(LatLng newPosition) {
    setPinLocation(newPosition);
  }

  // Mock method to update event count based on filters
  // This will be replaced with actual API calls later
  void _updateEventCount() {
    // Simulate different event counts based on filters
    int baseCount = 247;
    
    if (_selectedCategory != 'All') baseCount = (baseCount * 0.3).toInt();
    if (_dateRange == 'Today') baseCount = (baseCount * 0.1).toInt();
    if (_dateRange == 'This Week') baseCount = (baseCount * 0.4).toInt();
    if (_dateRange == 'This Month') baseCount = (baseCount * 0.7).toInt();
    if (_eventType != 'All') baseCount = (baseCount * 0.6).toInt();
    if (_priceFilter == 'Free') baseCount = (baseCount * 0.5).toInt();
    if (_priceFilter == 'Paid') baseCount = (baseCount * 0.5).toInt();
    if (_verifiedOnly) baseCount = (baseCount * 0.3).toInt();
    
    // Adjust by radius
    baseCount = (baseCount * (_radiusKm / 10)).toInt().clamp(0, 999);
    
    _eventCount = baseCount;
  }

  /// Gets an event by ID from discover events
  EventModel? getEventById(String eventId) {
    try {
      return PlaceholderData.discoverEvents.firstWhere(
        (event) => event.id == eventId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Disposes of resources
  void dispose() {
    _mapControllerWrapper.dispose();
  }
}