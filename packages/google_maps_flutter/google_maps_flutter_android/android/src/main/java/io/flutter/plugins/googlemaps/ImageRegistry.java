package io.flutter.plugins.googlemaps;

import android.content.Context;
import android.content.res.AssetManager;
import io.flutter.plugins.googlemaps.Messages.ImageRegistryApi;
import io.flutter.plugins.googlemaps.Messages.PlatformBitmap;
import com.google.android.gms.maps.model.BitmapDescriptor;
import java.util.HashMap;

class ImageRegistry implements ImageRegistryApi {
  final Context context;
  final AssetManager assetManager;
  final float density;

  private final HashMap<Long, BitmapDescriptor> registry = new HashMap<>();

  ImageRegistry(Context context) {
    this.context = context;
    this.assetManager = context.getAssets();
    this.density = context.getResources().getDisplayMetrics().density;
  }

  @Override
  public void addBitmapToCache(Long id, PlatformBitmap bitmap) {
    if (!(bitmap.getBitmap() instanceof Messages.PlatformBitmapAsset) &&
        !(bitmap.getBitmap() instanceof Messages.PlatformBitmapAssetMap) &&
        !(bitmap.getBitmap() instanceof Messages.PlatformBitmapBytesMap)) {
      throw new IllegalArgumentException("PlatformBitmap must contain a supported subtype.");
    }

    final BitmapDescriptor bitmapDescriptor =
        Convert.toBitmapDescriptor(bitmap, assetManager, density, this);
    registry.put(id, bitmapDescriptor);
  }

  @Override
  public void removeBitmapFromCache(Long id) {
    registry.remove(id);
  }

  @Override
  public void clearBitmapCache() {
    registry.clear();
  }

  public BitmapDescriptor getBitmap(Long id) {
    return registry.get(id);
  }
}
