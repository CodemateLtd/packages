import 'package:google_maps/google_maps.dart' as gmaps;
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../google_maps_flutter_web.dart';

/// Manages mapping between registered bitmap IDs and [gmaps.Icon] objects.
class ImageRegistry {
  /// Default constructor.
  ImageRegistry._();

  /// The singleton instance of [ImageRegistry].
  static final ImageRegistry instance = ImageRegistry._();

  final Map<int, gmaps.Icon> _registry = <int, gmaps.Icon>{};

  /// Registers a [bitmap] with the given [id].
  Future<void> addBitmapToCache(int id, MapBitmap bitmap) async {
    final gmaps.Icon? convertedBitmap =
        await gmIconFromBitmapDescriptor(bitmap);
    if (convertedBitmap != null) {
      _registry[id] = convertedBitmap;
    }
  }

  /// Unregisters a bitmap with the given [id].
  void removeBitmapFromCache(int id) {
    _registry.remove(id);
  }

  /// Unregisters all previously registered bitmaps and clears the cache.
  void clearBitmapCache() {
    _registry.clear();
  }

  /// Returns the [gmaps.Icon] object associated with the given [id].
  gmaps.Icon? getBitmap(int id) {
    return _registry[id];
  }
}
