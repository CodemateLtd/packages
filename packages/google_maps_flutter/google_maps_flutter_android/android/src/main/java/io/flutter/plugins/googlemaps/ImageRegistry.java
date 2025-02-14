package io.flutter.plugins.googlemaps;

import android.content.res.AssetManager;
import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;
import com.google.android.gms.maps.model.BitmapDescriptor;
import io.flutter.plugins.googlemaps.Convert.BitmapDescriptorFactoryWrapper;
import io.flutter.plugins.googlemaps.Convert.FlutterInjectorWrapper;
import io.flutter.plugins.googlemaps.Messages.ImageRegistryApi;
import io.flutter.plugins.googlemaps.Messages.PlatformBitmap;
import java.util.HashMap;

/**
 * A registry for BitmapDescriptors.
 *
 * <p>BitmapDescriptors are created from PlatformBitmaps and stored in the registry. The registry
 * allows for the retrieval of BitmapDescriptors by their unique identifier.
 */
class ImageRegistry implements ImageRegistryApi {
  private final AssetManager assetManager;
  private final BitmapDescriptorFactoryWrapper bitmapDescriptorFactoryWrapper;
  private final float density;

  @VisibleForTesting private FlutterInjectorWrapper flutterInjectorWrapper;

  private final HashMap<Long, BitmapDescriptor> registry = new HashMap<>();

  ImageRegistry(
      AssetManager assetManager,
      BitmapDescriptorFactoryWrapper bitmapDescriptorFactoryWrapper,
      float density) {
    this.assetManager = assetManager;
    this.bitmapDescriptorFactoryWrapper = bitmapDescriptorFactoryWrapper;
    this.density = density;
  }

  @Override
  public void addBitmapToCache(@NonNull Long id, PlatformBitmap bitmap) {
    if (!(bitmap.getBitmap() instanceof Messages.PlatformBitmapAsset)
        && !(bitmap.getBitmap() instanceof Messages.PlatformBitmapAssetMap)
        && !(bitmap.getBitmap() instanceof Messages.PlatformBitmapBytesMap)) {
      throw new IllegalArgumentException("PlatformBitmap must contain a supported subtype.");
    }

    final BitmapDescriptor bitmapDescriptor =
        Convert.toBitmapDescriptor(
            bitmap,
            assetManager,
            density,
            bitmapDescriptorFactoryWrapper,
            this,
            flutterInjectorWrapper);
    registry.put(id, bitmapDescriptor);
  }

  @VisibleForTesting
  public void setFlutterInjectorWrapper(FlutterInjectorWrapper flutterInjectorWrapper) {
    this.flutterInjectorWrapper = flutterInjectorWrapper;
  }

  @Override
  public void removeBitmapFromCache(@NonNull Long id) {
    registry.remove(id);
  }

  @Override
  public void clearBitmapCache() {
    registry.clear();
  }

  /**
   * Retrieves a BitmapDescriptor from the registry using the provided ID.
   *
   * @param id unique identifier of a previously registered BitmapDescriptor.
   * @return the BitmapDescriptor associated with the given ID, or null if no such object exists.
   */
  public BitmapDescriptor getBitmap(Long id) {
    return registry.get(id);
  }
}
