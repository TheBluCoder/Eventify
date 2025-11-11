import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

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

  /// Creates an event marker with custom icon
  /// [eventId] - Unique identifier for the event
  /// [position] - LatLng position of the event
  /// [title] - Title to display in info window
  /// [icon] - Custom BitmapDescriptor icon for the marker
  Marker createEventMarker({
    required String eventId,
    required LatLng position,
    required String title,
    required BitmapDescriptor icon,
  }) {
    return Marker(
      markerId: MarkerId('event_$eventId'),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(
        title: title,
      ),
    );
  }

  /// Adds an event marker to the set
  void addEventMarker(Marker marker) {
    _markers.add(marker);
  }

  /// Removes all event markers (keeps user location and pin markers)
  void clearEventMarkers() {
    _markers.removeWhere((m) => 
      m.markerId.value.startsWith('event_')
    );
  }

  /// Creates a custom marker icon from a network image URL
  /// Uses the event's mediaUrl to create a custom marker icon
  /// 
  /// [imageUrl] - The network URL of the image to use for the marker
  /// [size] - The desired size of the marker icon (default: 48x48)
  /// [borderRadius] - Border radius for rounded corners (default: 8). Set to size.width/2 for circular
  /// [isCircular] - If true, creates a circular marker (overrides borderRadius)
  /// [borderWidth] - Width of the border around the marker (default: 2)
  /// [borderColor] - Color of the border (default: white)
  /// [shadowBlur] - Blur radius for shadow effect (default: 4)
  /// [shadowColor] - Color of the shadow (default: black with 0.3 opacity)
  /// 
  /// Returns a [BitmapDescriptor] that can be used for map markers
  static Future<BitmapDescriptor> getCustomMarkerIcon({
    required String imageUrl,
    Size size = const Size(48, 48),
    double? borderRadius,
    bool isCircular = false,
    double borderWidth = 2.0,
    Color borderColor = Colors.white,
    double shadowBlur = 4.0,
    Color? shadowColor,
  }) async {
    try {
      // Load image from network
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to load image: ${response.statusCode}');
      }

      // Decode the image
      final Uint8List imageBytes = response.bodyBytes;
      final ui.Codec codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: size.width.toInt(),
        targetHeight: size.height.toInt(),
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      // Calculate border radius
      final double radius = isCircular 
          ? size.width / 2 
          : (borderRadius ?? 8.0);
      
      // Calculate canvas size with padding for shadow
      final double padding = shadowBlur + borderWidth;
      final double canvasWidth = size.width + (padding * 2);
      final double canvasHeight = size.height + (padding * 2);
      
      // Create a picture recorder and canvas
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      
      // Draw shadow first (behind everything)
      if (shadowBlur > 0) {
        final Paint shadowPaint = Paint()
          ..color = shadowColor ?? Colors.black.withValues(alpha: 0.3)
          ..maskFilter = MaskFilter.blur(ui.BlurStyle.normal, shadowBlur);
        
        final RRect shadowRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            padding,
            padding,
            size.width,
            size.height,
          ),
          Radius.circular(radius),
        );
        canvas.drawRRect(shadowRect, shadowPaint);
      }
      
      // Create a clip path for rounded corners
      final Path clipPath = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              padding,
              padding,
              size.width,
              size.height,
            ),
            Radius.circular(radius),
          ),
        );
      canvas.save();
      canvas.clipPath(clipPath);
      
      // Draw the image (clipped to rounded corners)
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(
          padding,
          padding,
          size.width,
          size.height,
        ),
        Paint(),
      );
      
      // Restore canvas to draw border on top
      canvas.restore();
      
      // Draw border on top of the image
      if (borderWidth > 0) {
        final Paint borderPaint = Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;
        
        final RRect borderRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            padding,
            padding,
            size.width,
            size.height,
          ),
          Radius.circular(radius),
        );
        canvas.drawRRect(borderRect, borderPaint);
      }
      
      // Convert canvas to image
      final ui.Picture picture = pictureRecorder.endRecording();
      final ui.Image finalImage = await picture.toImage(
        canvasWidth.toInt(),
        canvasHeight.toInt(),
      );
      
      // Convert image to bytes
      final ByteData? byteData = await finalImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Create BitmapDescriptor from bytes
      return BitmapDescriptor.bytes(pngBytes);
    } catch (e) {
      debugPrint('Error creating custom marker icon: $e');
      // Fallback to default marker if image loading fails
      return BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
    }
  }
}

