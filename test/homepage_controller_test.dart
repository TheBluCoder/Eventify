import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

// Import your classes
import 'package:echoes/controllers/homepage_controller.dart';
import 'package:echoes/controllers/marker_manager.dart';
// import 'package:echoes/controllers/map_controller_wrapper.dart';
import 'package:echoes/controllers/location_service.dart';

// Generate mocks with: flutter pub run build_runner build
@GenerateNiceMocks([MockSpec<Location>(), MockSpec<LocationService>(), MockSpec<GoogleMapController>()])
import 'homepage_controller_test.mocks.dart';

void main() {
  group('LocationService', () {
    late MockLocation mockLocation;
    late LocationService locationService;

    setUp(() {
      mockLocation = MockLocation();
      locationService = LocationService(location: mockLocation);
    });

    group('getUserLocationCoords', () {
      test('given location service is enabled and permission is granted, when getUserLocationCoords is called, then it should return LatLng', () async {
        // Given
        final expectedLatitude = 43.6532;
        final expectedLongitude = -79.3832;
        
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
        when(mockLocation.hasPermission())
            .thenAnswer((_) async => PermissionStatus.granted);
        when(mockLocation.getLocation()).thenAnswer(
          (_) async => LocationData.fromMap({
            'latitude': expectedLatitude,
            'longitude': expectedLongitude,
          }),
        );

        // When
        final result = await locationService.getUserLocationCoords();

        // Then
        expect(result, isNotNull);
        expect(result!.latitude, expectedLatitude);
        expect(result.longitude, expectedLongitude);
        verify(mockLocation.serviceEnabled()).called(1);
        verify(mockLocation.hasPermission()).called(1);
        verify(mockLocation.getLocation()).called(1);
      });

      test('given location service is not enabled and user denies request, when getUserLocationCoords is called, then it should return null', () async {
        // Given
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => false);
        when(mockLocation.requestService()).thenAnswer((_) async => false);

        // When
        final result = await locationService.getUserLocationCoords();

        // Then
        expect(result, isNull);
        verify(mockLocation.serviceEnabled()).called(1);
        verify(mockLocation.requestService()).called(1);
        verifyNever(mockLocation.hasPermission());
        verifyNever(mockLocation.getLocation());
      });

      test('given location permission is denied, when getUserLocationCoords is called, then it should return null', () async {
        // Given
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
        when(mockLocation.hasPermission())
            .thenAnswer((_) async => PermissionStatus.denied);
        when(mockLocation.requestPermission())
            .thenAnswer((_) async => PermissionStatus.denied);

        // When
        final result = await locationService.getUserLocationCoords();

        // Then
        expect(result, isNull);
        verify(mockLocation.serviceEnabled()).called(1);
        verify(mockLocation.hasPermission()).called(1);
        verify(mockLocation.requestPermission()).called(1);
        verifyNever(mockLocation.getLocation());
      });

      test('given location data has null coordinates, when getUserLocationCoords is called, then it should return null', () async {
        // Given
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
        when(mockLocation.hasPermission())
            .thenAnswer((_) async => PermissionStatus.granted);
        when(mockLocation.getLocation()).thenAnswer(
          (_) async => LocationData.fromMap({
            'latitude': null,
            'longitude': null,
          }),
        );

        // When
        final result = await locationService.getUserLocationCoords();

        // Then
        expect(result, isNull);
      });
    });

    group('getLocationStream', () {
      late StreamController<LocationData> streamController;

      setUp(() {
        streamController = StreamController<LocationData>();
        when(mockLocation.onLocationChanged)
            .thenAnswer((_) => streamController.stream);
      });

      tearDown(() {
        streamController.close();
      });

      test('given valid location data, when location stream emits coordinates, then it should emit LatLng', () async {
        // Given
        final expectedLatitude = 43.6532;
        final expectedLongitude = -79.3832;

        // When
        final stream = locationService.getLocationStream();
        streamController.add(LocationData.fromMap({
          'latitude': expectedLatitude,
          'longitude': expectedLongitude,
        }));

        // Then
        await expectLater(
          stream,
          emits(LatLng(expectedLatitude, expectedLongitude)),
        );
      });

      test('given location data with null coordinates, when location stream emits data, then it should filter out null coordinates', () async {
        // Given
        final validLatitude = 43.6532;
        final validLongitude = -79.3832;

        // When
        final stream = locationService.getLocationStream();
        
        streamController.add(LocationData.fromMap({
          'latitude': null,
          'longitude': null,
        }));
        
        streamController.add(LocationData.fromMap({
          'latitude': validLatitude,
          'longitude': validLongitude,
        }));

        // Then
        await expectLater(
          stream,
          emits(LatLng(validLatitude, validLongitude)),
        );
      });

      test('given location data with only one null coordinate, when location stream emits data, then it should filter out partial null coordinates', () async {
        // Given
        final validLatitude = 43.6532;
        final validLongitude = -79.3832;

        // When
        final stream = locationService.getLocationStream();
        
        streamController.add(LocationData.fromMap({
          'latitude': validLatitude,
          'longitude': null,
        }));
        
        streamController.add(LocationData.fromMap({
          'latitude': validLatitude,
          'longitude': validLongitude,
        }));

        // Then
        await expectLater(
          stream,
          emits(LatLng(validLatitude, validLongitude)),
        );
      });
    });

    group('ensureServiceEnabled', () {
      test('given location service is already enabled, when ensureServiceEnabled is called, then it should return true', () async {
        // Given
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);

        // When
        final result = await locationService.ensureServiceEnabled();

        // Then
        expect(result, isTrue);
        verify(mockLocation.serviceEnabled()).called(1);
        verifyNever(mockLocation.requestService());
      });

      test('given location service is disabled and user enables it, when ensureServiceEnabled is called, then it should return true', () async {
        // Given
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => false);
        when(mockLocation.requestService()).thenAnswer((_) async => true);

        // When
        final result = await locationService.ensureServiceEnabled();

        // Then
        expect(result, isTrue);
        verify(mockLocation.serviceEnabled()).called(1);
        verify(mockLocation.requestService()).called(1);
      });

      test('given location service is disabled and user denies request, when ensureServiceEnabled is called, then it should return false', () async {
        // Given
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => false);
        when(mockLocation.requestService()).thenAnswer((_) async => false);

        // When
        final result = await locationService.ensureServiceEnabled();

        // Then
        expect(result, isFalse);
        verify(mockLocation.serviceEnabled()).called(1);
        verify(mockLocation.requestService()).called(1);
      });
    });

    group('ensurePermissionGranted -', () {
      test('given permission is already granted, when ensurePermissionGranted is called, then it should return true', () async {
        // Given
        when(mockLocation.hasPermission())
            .thenAnswer((_) async => PermissionStatus.granted);

        // When
        final result = await locationService.ensurePermissionGranted();

        // Then
        expect(result, isTrue);
        verify(mockLocation.hasPermission()).called(1);
        verifyNever(mockLocation.requestPermission());
      });

      test('given permission is denied and user grants it, when ensurePermissionGranted is called, then it should return true', () async {
        // Given
        when(mockLocation.hasPermission())
            .thenAnswer((_) async => PermissionStatus.denied);
        when(mockLocation.requestPermission())
            .thenAnswer((_) async => PermissionStatus.granted);

        // When
        final result = await locationService.ensurePermissionGranted();

        // Then
        expect(result, isTrue);
        verify(mockLocation.hasPermission()).called(1);
        verify(mockLocation.requestPermission()).called(1);
      });

      test('given permission is denied and user denies it, when ensurePermissionGranted is called, then it should return false', () async {
        // Given
        when(mockLocation.hasPermission())
            .thenAnswer((_) async => PermissionStatus.denied);
        when(mockLocation.requestPermission())
            .thenAnswer((_) async => PermissionStatus.denied);

        // When
        final result = await locationService.ensurePermissionGranted();

        // Then
        expect(result, isFalse);
        verify(mockLocation.hasPermission()).called(1);
        verify(mockLocation.requestPermission()).called(1);
      });

      // test('given permission is deniedForever but then granted, when ensurePermissionGranted is called, then it should return true', () async {
      //   // Given
      //   when(mockLocation.hasPermission())
      //       .thenAnswer((_) async => PermissionStatus.deniedForever);
      //   when(mockLocation.requestPermission())
      //       .thenAnswer((_) async => PermissionStatus.granted);

      //   // When
      //   final result = await locationService.ensurePermissionGranted();

      //   // Then
      //   expect(result, isTrue);
      // });
    });
  });

  group('MarkerManager', () {
    late MarkerManager markerManager;

    setUp(() {
      markerManager = MarkerManager();
    });

    group('updateUserLocationMarker', () {
      test('given marker set is empty, when updateUserLocationMarker is called, then it should add user location marker', () {
        // Given
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

      test('given other markers exist, when updateUserLocationMarker is called, then it should not affect other markers', () {
        // Given
        final otherMarker = Marker(
          markerId: const MarkerId('other_marker'),
          position: const LatLng(43.8000, -79.5000),
        );
        markerManager.addMarker(otherMarker);
        final userPosition = const LatLng(43.6532, -79.3832);

        // When
        markerManager.updateUserLocationMarker(userPosition);

        // Then
        expect(markerManager.markers.length, 2);
        expect(markerManager.getMarker(const MarkerId('other_marker')), isNotNull);
      });
    });

    group('addMarker', () {
      test('given empty marker set, when addMarker is called, then it should add marker to set', () {
        // Given
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

      test('given empty marker set, when multiple addMarker calls are made, then it should add multiple markers', () {
        // Given
        final marker1 = Marker(
          markerId: const MarkerId('marker1'),
          position: const LatLng(43.6532, -79.3832),
        );
        final marker2 = Marker(
          markerId: const MarkerId('marker2'),
          position: const LatLng(43.7000, -79.4000),
        );

        // When
        markerManager.addMarker(marker1);
        markerManager.addMarker(marker2);

        // Then
        expect(markerManager.markers.length, 2);
      });
    });

    group('removeMarker', () {
      test('given markers exist, when removeMarker is called with specific ID, then it should remove that marker', () {
        // Given
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

      test('given empty marker set, when removeMarker is called with non-existent ID, then it should not throw error', () {
        // Given (empty marker manager)

        // When & Then
        expect(
          () => markerManager.removeMarker(const MarkerId('non_existent')),
          returnsNormally,
        );
        expect(markerManager.markers.length, 0);
      });
    });

    group('clearMarkers', () {
      test('given markers exist, when clearMarkers is called, then it should remove all markers', () {
        // Given
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

      test('given empty marker set, when clearMarkers is called, then it should handle clearing gracefully', () {
        // Given (empty marker manager)

        // When
        markerManager.clearMarkers();

        // Then
        expect(markerManager.markers, isEmpty);
      });
    });

    group('getMarker', () {
      test('given marker exists, when getMarker is called with existing ID, then it should return marker', () {
        // Given
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
        // Given (empty marker manager)

        // When
        final result = markerManager.getMarker(const MarkerId('non_existent'));

        // Then
        expect(result, isNull);
      });
    });

    group('createUserLocationMarker', () {
      test('given position coordinates, when createUserLocationMarker is called, then it should create marker with correct properties', () {
        // Given
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

  group('HomePageController', () {
    late MockLocationService mockLocationService;
    late MarkerManager markerManager;
    late HomePageController controller;

    setUp(() {
      mockLocationService = MockLocationService();
      markerManager = MarkerManager();
    });

    group('initialize', () {
      tearDown(() {
        controller.dispose();
      });

      test('given successful location service, when initialize is called, then it should set loading to false and update location', () async {
        // Given
        final expectedLocation = const LatLng(43.6532, -79.3832);
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );
        
        when(mockLocationService.getUserLocationCoords())
            .thenAnswer((_) async => expectedLocation);
        when(mockLocationService.getLocationStream())
            .thenAnswer((_) => Stream.empty());

        // When
        await controller.initialize();

        // Then
        expect(controller.isLoading, isFalse);
        expect(controller.userLocationCoords, expectedLocation);
        expect(controller.markers.length, 1);
        verify(mockLocationService.getUserLocationCoords()).called(1);
        verify(mockLocationService.getLocationStream()).called(1);
      });

      test('given location service fails, when initialize is called, then it should set loading to false', () async {
        // Given
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );
        
        when(mockLocationService.getUserLocationCoords())
            .thenAnswer((_) async => null);

        // When
        await controller.initialize();

        // Then
        expect(controller.isLoading, isFalse);
        expect(controller.userLocationCoords, isNull);
        expect(controller.markers.length, 0);
        verifyNever(mockLocationService.getLocationStream());
      });

      test('given HomePageController is instantiated, when accessed before initialization, then it should be loading', () {
        // Given
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );

        // When (before initialize is called)
        // Then
        expect(controller.isLoading, isTrue);
      });
    });

    group('location updates', () {
      late StreamController<LatLng> streamController;

      setUp(() {
        streamController = StreamController<LatLng>();
      });

      tearDown(() {
        controller.dispose();
        streamController.close();
      });

      test('given location stream emits new coordinates, when location updates, then it should update user location', () async {
        // Given
        final initialLocation = const LatLng(43.6532, -79.3832);
        final updatedLocation = const LatLng(43.7000, -79.4000);
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );
        
        when(mockLocationService.getUserLocationCoords())
            .thenAnswer((_) async => initialLocation);
        when(mockLocationService.getLocationStream())
            .thenAnswer((_) => streamController.stream);

        await controller.initialize();

        // When
        streamController.add(updatedLocation);
        await Future.delayed(Duration.zero); // Allow stream to process

        // Then
        expect(controller.userLocationCoords, updatedLocation);
        final userMarker = markerManager.getMarker(const MarkerId('user_location'));
        expect(userMarker?.position, updatedLocation);
      });

      test('given location stream emits multiple coordinates, when location changes multiple times, then it should update marker multiple times', () async {
        // Given
        final initialLocation = const LatLng(43.6532, -79.3832);
        final location2 = const LatLng(43.7000, -79.4000);
        final location3 = const LatLng(43.8000, -79.5000);
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );
        
        when(mockLocationService.getUserLocationCoords())
            .thenAnswer((_) async => initialLocation);
        when(mockLocationService.getLocationStream())
            .thenAnswer((_) => streamController.stream);

        await controller.initialize();

        // When
        streamController.add(location2);
        await Future.delayed(Duration.zero);
        streamController.add(location3);
        await Future.delayed(Duration.zero);

        // Then
        expect(controller.userLocationCoords, location3);
        expect(controller.markers.length, 1); // Still only one user location marker
      });
    });

    group('onMapCreated', () {
      tearDown(() {
        controller.dispose();
      });

      test('given map controller, when onMapCreated is called, then it should set map controller', () {
        // Given
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );
        final mockMapController = MockGoogleMapController();

        // When
        controller.onMapCreated(mockMapController);

        // Then
        expect(() => controller.onMapCreated(mockMapController), returnsNormally);
      });
    });

    group('button actions', () {
      setUp(() {
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );
      });

      tearDown(() {
        controller.dispose();
      });

      test('given HomePageController, when onFilterPressed is called, then it should handle filter button press', () {
        // Given (controller set up in setUp)

        // When & Then
        expect(() => controller.onFilterPressed(), returnsNormally);
      });

      test('given HomePageController, when onMapViewPressed is called, then it should handle map view button press', () {
        // Given (controller set up in setUp)

        // When & Then
        expect(() => controller.onMapViewPressed(), returnsNormally);
      });

      test('given HomePageController, when onListViewPressed is called, then it should handle list view button press', () {
        // Given (controller set up in setUp)

        // When & Then
        expect(() => controller.onListViewPressed(), returnsNormally);
      });
    });

    group('dispose -', () {
      test('given initialized HomePageController, when dispose is called, then it should clean up resources', () async {
        // Given
        final streamController = StreamController<LatLng>();
        controller = HomePageController(
          locationService: mockLocationService,
          markerManager: markerManager,
        );
        
        when(mockLocationService.getUserLocationCoords())
            .thenAnswer((_) async => const LatLng(43.6532, -79.3832));
        when(mockLocationService.getLocationStream())
            .thenAnswer((_) => streamController.stream);

        await controller.initialize();

        // When
        await streamController.close();
        // debugPrint("controller disposed called before");
        expect(() => controller.dispose(), returnsNormally);


        expect(
          () => controller.dispose(),
          throwsA(isA<FlutterError>()),
        );
        // Then
      });
    });
  });
}

// // Mock classes for testing
// class MockLocation extends Mock implements Location {}
// class MockGoogleMapController extends Mock implements GoogleMapController {}
// class MockLocationService extends Mock implements LocationService {}