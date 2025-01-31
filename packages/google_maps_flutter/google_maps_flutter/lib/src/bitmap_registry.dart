part of '../google_maps_flutter.dart';

/// A bitmap registry.
///
/// Bitmaps can be created before they are used in markers and then registered
/// with the registry. This allows for more efficient rendering of markers
/// on the map. For example, if multiple markers use the same bitmap, bitmap
/// can be registered once and then reused. This eliminates the need to
/// transfer the bitmap data multiple times to the platform side.
///
/// Using bitmap registry is optional.
///
/// Bitmap registry can be used after the map is initialized and displayed
/// on the screen. On Android registry can be also used after map renderer is
/// initialized without map being displayed on the screen.
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
  ///
  /// Returns a unique identifier for the registered bitmap.
  Future<int> register(MapBitmap bitmap) async {
    _imageCount++;
    final int id = _imageCount;
    await GoogleMapsFlutterPlatform.instance.registerBitmap(id, bitmap);
    return id;
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
