import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Wrapper for Google Map Controller operations
class MapControllerWrapper {
  GoogleMapController? _controller;

  /// Sets the map controller
  void setController(GoogleMapController controller) {
    _controller = controller;
  }

  /// Animates camera to a new position
  Future<void> animateCameraToPosition(LatLng position) async {
    await _controller?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  /// Animates camera to a position with zoom
  Future<void> animateCameraToPositionWithZoom(
    LatLng position,
    double zoom,
  ) async {
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(position, zoom),
    );
  }

  /// Moves camera to a new position
  Future<void> moveCameraToPosition(LatLng position) async {
    await _controller?.moveCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  /// Disposes the controller
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  /// Checks if controller is initialized
  bool get isInitialized => _controller != null;
}

