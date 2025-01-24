part of '../google_maps_flutter.dart';

/// A bitmap registry. Bitmaps can be created before they are used in markers
/// and then registered with the registry. This allows for more efficient
/// rendering of markers on the map. For example, if multiple markers use the
/// same bitmap, bitmap can be registered once and then reused.
///
/// Using bitmap registry is optional.
///
/// Example:
/// ```dart
/// // Register a bitmap
/// final registeredBitmap = await GoogleMapBitmapRegistry.instance.register(
///   Bitmap.fromAsset('assets/image.png'),
/// );
///
/// // Use the registered bitmap as marker icon
/// Marker(
///   markerId: MarkerId('markerId'),
///   icon: registeredBitmap,
///   position: LatLng(0, 0)
///   ),
/// )
/// ```
class GoogleMapBitmapRegistry {
  GoogleMapBitmapRegistry._();

  /// The singleton instance of [GoogleMapBitmapRegistry].
  static final GoogleMapBitmapRegistry instance = GoogleMapBitmapRegistry._();

  // The number of registered images. Also used as a unique identifier for each
  // registered image.
  int _imageCount = 0;

  /// Registers a [bitmap] with the registry.
  Future<RegisteredMapBitmap> register(MapBitmap bitmap) async {
    _imageCount++;
    final int id = _imageCount;
    await GoogleMapsFlutterPlatform.instance.registerBitmap(id, bitmap);
    return RegisteredMapBitmap(id: id);
  }

  /// Unregisters a bitmap with the given [id].
  Future<void> unregister(int id) {
    return GoogleMapsFlutterPlatform.instance.unregisterBitmap(id);
  }

  /// Unregister all previously registered bitmaps and clear the cache.
  Future<void> clear() {
    return GoogleMapsFlutterPlatform.instance.clearBitmapCache();
  }
}
