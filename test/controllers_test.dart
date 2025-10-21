import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Import your classes
import 'package:echoes/controllers/location_controller.dart';
import 'package:echoes/controllers/discover_controller.dart';
import 'package:echoes/shared/widgets/marker_manager.dart';

void main() {
  group('LocationController', () {
    group('initial state', () {
      test('given LocationController is instantiated, when accessed before initialization, then it should be loading', () {
        // Given
        final locationController = LocationController();

        // When (before initialize is called)
        // Then
        expect(locationController.isLoading, isTrue);
        expect(locationController.userLocationCoords, isNull);
        expect(locationController.hasLocationPermission, isFalse);
        expect(locationController.hasLocation, isFalse);
        
        // Cleanup
        locationController.dispose();
      });
    });

    group('dispose', () {
      test('given LocationController, when dispose is called, then it should clean up resources', () {
        // Given
        final locationController = LocationController();
        
        // When & Then
        expect(() => locationController.dispose(), returnsNormally);
      });
    });
  });

  group('DiscoverController', () {
    group('view switching', () {
      test('given DiscoverController, when toggleView is called, then it should switch between map and list view', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        expect(discoverController.isMapView, isFalse);

        // When
        discoverController.toggleView();

        // Then
        expect(discoverController.isMapView, isTrue);

        // When
        discoverController.toggleView();

        // Then
        expect(discoverController.isMapView, isFalse);
        
        // Cleanup
        discoverController.dispose();
      });

      test('given DiscoverController, when setMapView is called, then it should set map view', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        expect(discoverController.isMapView, isFalse);

        // When
        discoverController.setMapView();

        // Then
        expect(discoverController.isMapView, isTrue);
        
        // Cleanup
        discoverController.dispose();
      });

      test('given DiscoverController, when setListView is called, then it should set list view', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        discoverController.setMapView(); // Start with map view
        expect(discoverController.isMapView, isTrue);

        // When
        discoverController.setListView();

        // Then
        expect(discoverController.isMapView, isFalse);
        
        // Cleanup
        discoverController.dispose();
      });
    });

    group('marker management', () {
      test('given DiscoverController, when updateUserLocationMarker is called, then it should update marker', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        final position = const LatLng(43.6532, -79.3832);

        // When
        discoverController.updateUserLocationMarker(position);

        // Then
        expect(discoverController.markers.length, 1);
        final marker = discoverController.markers.first;
        expect(marker.markerId, const MarkerId('user_location'));
        expect(marker.position, position);
        
        // Cleanup
        discoverController.dispose();
      });
    });

    group('button actions', () {
      test('given DiscoverController, when onFilterPressed is called, then it should handle filter button press', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        
        // When & Then
        expect(() => discoverController.onFilterPressed(), returnsNormally);
        
        // Cleanup
        discoverController.dispose();
      });

      test('given DiscoverController with user location, when onRecenterPressed is called, then it should handle recenter button press', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        final userLocation = const LatLng(43.6532, -79.3832);

        // When & Then
        expect(() => discoverController.onRecenterPressed(userLocation), returnsNormally);
        
        // Cleanup
        discoverController.dispose();
      });

      test('given DiscoverController without user location, when onRecenterPressed is called, then it should handle gracefully', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        
        // When & Then
        expect(() => discoverController.onRecenterPressed(null), returnsNormally);
        
        // Cleanup
        discoverController.dispose();
      });
    });

    group('dispose', () {
      test('given DiscoverController, when dispose is called, then it should clean up resources', () {
        // Given
        final markerManager = MarkerManager();
        final discoverController = DiscoverController(markerManager: markerManager);
        
        // When & Then
        expect(() => discoverController.dispose(), returnsNormally);
      });
    });
  });

  group('MarkerManager', () {
    group('updateUserLocationMarker', () {
      test('given marker set is empty, when updateUserLocationMarker is called, then it should add user location marker', () {
        // Given
        final markerManager = MarkerManager();
        final position = const LatLng(43.6532, -79.3832);

        // When
        markerManager.updateUserLocationMarker(position);

        // Then
        expect(markerManager.markers.length, 1);
        final marker = markerManager.markers.first;
        expect(marker.markerId, const MarkerId('user_location'));
        expect(marker.position, position);
      });

      test('given existing user location marker, when updateUserLocationMarker is called with new position, then it should replace existing marker', () {
        // Given
        final markerManager = MarkerManager();
        final initialPosition = const LatLng(43.6532, -79.3832);
        final updatedPosition = const LatLng(43.7000, -79.4000);
        markerManager.updateUserLocationMarker(initialPosition);

        // When
        markerManager.updateUserLocationMarker(updatedPosition);

        // Then
        expect(markerManager.markers.length, 1);
        final marker = markerManager.markers.first;
        expect(marker.position, updatedPosition);
        expect(marker.markerId, const MarkerId('user_location'));
      });
    });

    group('addMarker', () {
      test('given empty marker set, when addMarker is called, then it should add marker to set', () {
        // Given
        final markerManager = MarkerManager();
        final marker = Marker(
          markerId: const MarkerId('test_marker'),
          position: const LatLng(43.6532, -79.3832),
        );

        // When
        markerManager.addMarker(marker);

        // Then
        expect(markerManager.markers.length, 1);
        expect(markerManager.markers.first.markerId, const MarkerId('test_marker'));
      });
    });

    group('removeMarker', () {
      test('given markers exist, when removeMarker is called with specific ID, then it should remove that marker', () {
        // Given
        final markerManager = MarkerManager();
        markerManager.addMarker(Marker(
          markerId: const MarkerId('marker1'),
          position: const LatLng(43.6532, -79.3832),
        ));
        markerManager.addMarker(Marker(
          markerId: const MarkerId('marker2'),
          position: const LatLng(43.7000, -79.4000),
        ));

        // When
        markerManager.removeMarker(const MarkerId('marker1'));

        // Then
        expect(markerManager.markers.length, 1);
        expect(markerManager.markers.first.markerId, const MarkerId('marker2'));
      });
    });

    group('clearMarkers', () {
      test('given markers exist, when clearMarkers is called, then it should remove all markers', () {
        // Given
        final markerManager = MarkerManager();
        markerManager.addMarker(Marker(
          markerId: const MarkerId('marker1'),
          position: const LatLng(43.6532, -79.3832),
        ));
        markerManager.addMarker(Marker(
          markerId: const MarkerId('marker2'),
          position: const LatLng(43.7000, -79.4000),
        ));

        // When
        markerManager.clearMarkers();

        // Then
        expect(markerManager.markers.length, 0);
        expect(markerManager.markers, isEmpty);
      });
    });

    group('getMarker', () {
      test('given marker exists, when getMarker is called with existing ID, then it should return marker', () {
        // Given
        final markerManager = MarkerManager();
        final expectedMarkerId = const MarkerId('test_marker');
        markerManager.addMarker(Marker(
          markerId: expectedMarkerId,
          position: const LatLng(43.6532, -79.3832),
        ));

        // When
        final result = markerManager.getMarker(expectedMarkerId);

        // Then
        expect(result, isNotNull);
        expect(result!.markerId, expectedMarkerId);
      });

      test('given empty marker set, when getMarker is called with non-existent ID, then it should return null', () {
        // Given
        final markerManager = MarkerManager();

        // When
        final result = markerManager.getMarker(const MarkerId('non_existent'));

        // Then
        expect(result, isNull);
      });
    });

    group('createUserLocationMarker', () {
      test('given position coordinates, when createUserLocationMarker is called, then it should create marker with correct properties', () {
        // Given
        final markerManager = MarkerManager();
        final position = const LatLng(43.6532, -79.3832);

        // When
        final marker = markerManager.createUserLocationMarker(position);

        // Then
        expect(marker.markerId, const MarkerId('user_location'));
        expect(marker.position, position);
        expect(marker.infoWindow.title, 'You are here');
      });
    });
  });
}
