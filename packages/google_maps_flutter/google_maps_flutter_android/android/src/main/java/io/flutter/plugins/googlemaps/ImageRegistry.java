package io.flutter.plugins.googlemaps;

import android.content.res.AssetManager;
import androidx.annotation.NonNull;
import io.flutter.plugins.googlemaps.Convert.BitmapDescriptorFactoryWrapper;
import io.flutter.plugins.googlemaps.Messages.ImageRegistryApi;
import io.flutter.plugins.googlemaps.Messages.PlatformBitmap;
import com.google.android.gms.maps.model.BitmapDescriptor;
import java.util.HashMap;

class ImageRegistry implements ImageRegistryApi {
  final AssetManager assetManager;
  final BitmapDescriptorFactoryWrapper bitmapDescriptorFactoryWrapper;
  final float density;

  private final HashMap<Long, BitmapDescriptor> registry = new HashMap<>();

  ImageRegistry(
      AssetManager assetManager,
      BitmapDescriptorFactoryWrapper bitmapDescriptorFactoryWrapper,
      float density
  ) {
    this.assetManager = assetManager;
    this.bitmapDescriptorFactoryWrapper = bitmapDescriptorFactoryWrapper;
    this.density = density;
  }

  @Override
  public void addBitmapToCache(@NonNull Long id, PlatformBitmap bitmap) {
    if (!(bitmap.getBitmap() instanceof Messages.PlatformBitmapAsset) &&
        !(bitmap.getBitmap() instanceof Messages.PlatformBitmapAssetMap) &&
        !(bitmap.getBitmap() instanceof Messages.PlatformBitmapBytesMap)) {
      throw new IllegalArgumentException("PlatformBitmap must contain a supported subtype.");
    }

    final BitmapDescriptor bitmapDescriptor =
        Convert.toBitmapDescriptor(bitmap, assetManager, density, bitmapDescriptorFactoryWrapper, this);
    registry.put(id, bitmapDescriptor);
  }

  @Override
  public void removeBitmapFromCache(@NonNull Long id) {
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
