package io.flutter.plugins.googlemaps;

import static org.junit.Assert.fail;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyFloat;
import static org.mockito.Mockito.when;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Build;
import android.util.Base64;
import com.google.android.gms.maps.model.BitmapDescriptor;
import io.flutter.plugins.googlemaps.Convert.BitmapDescriptorFactoryWrapper;
import io.flutter.plugins.googlemaps.Convert.FlutterInjectorWrapper;
import java.io.ByteArrayOutputStream;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

@RunWith(RobolectricTestRunner.class)
@Config(minSdk = Build.VERSION_CODES.LOLLIPOP)
public class ImageRegistryTest {

  @Mock
  private AssetManager assetManager;

  @Mock
  private BitmapDescriptorFactoryWrapper bitmapDescriptorFactoryWrapper;

  @Mock
  private BitmapDescriptor mockBitmapDescriptor;

  @Mock
  private BitmapDescriptor mockBitmapDescriptor2;

  @Mock
  private FlutterInjectorWrapper flutterInjectorWrapper;

  AutoCloseable mockCloseable;

  @Before
  public void before() {
    mockCloseable = MockitoAnnotations.openMocks(this);
  }

  @After
  public void tearDown() throws Exception {
    mockCloseable.close();
  }

  @Test
  public void AddBitmapToCacheRegistersABitmap() {
    final ImageRegistry imageRegistry = new ImageRegistry(assetManager,
        bitmapDescriptorFactoryWrapper, 1L);
    Assert.assertNull(imageRegistry.getBitmap(1L));

    byte[] bmpData = Base64.decode(generateBase64Image(Color.BLACK), Base64.DEFAULT);
    Messages.PlatformBitmapBytesMap bitmap =
        new Messages.PlatformBitmapBytesMap.Builder()
            .setBitmapScaling(Messages.PlatformMapBitmapScaling.AUTO)
            .setImagePixelRatio(2.0)
            .setByteData(bmpData)
            .build();
    Messages.PlatformBitmap platformBitmap = new Messages.PlatformBitmap.Builder()
        .setBitmap(bitmap)
        .build();

    when(bitmapDescriptorFactoryWrapper.fromBitmap(any())).thenReturn(mockBitmapDescriptor);
    imageRegistry.addBitmapToCache(1L, platformBitmap);

    Assert.assertEquals(imageRegistry.getBitmap(1L), mockBitmapDescriptor);
  }

  @Test
  public void AddBitmapToCacheReplacesExistingBitmap() {
    final ImageRegistry imageRegistry = new ImageRegistry(assetManager,
        bitmapDescriptorFactoryWrapper, 1L);

    // Add bitmap 1
    byte[] bmpData = Base64.decode(generateBase64Image(Color.BLACK), Base64.DEFAULT);
    Messages.PlatformBitmapBytesMap bitmap =
        new Messages.PlatformBitmapBytesMap.Builder()
            .setBitmapScaling(Messages.PlatformMapBitmapScaling.AUTO)
            .setImagePixelRatio(2.0)
            .setByteData(bmpData)
            .build();
    Messages.PlatformBitmap platformBitmap = new Messages.PlatformBitmap.Builder()
        .setBitmap(bitmap)
        .build();
    when(bitmapDescriptorFactoryWrapper.fromBitmap(any())).thenReturn(mockBitmapDescriptor);
    imageRegistry.addBitmapToCache(1L, platformBitmap);
    Assert.assertEquals(imageRegistry.getBitmap(1L), mockBitmapDescriptor);

    // Add bitmap 2
    bmpData = Base64.decode(generateBase64Image(Color.RED), Base64.DEFAULT);
    bitmap =
        new Messages.PlatformBitmapBytesMap.Builder()
            .setBitmapScaling(Messages.PlatformMapBitmapScaling.AUTO)
            .setImagePixelRatio(2.0)
            .setByteData(bmpData)
            .build();
    platformBitmap = new Messages.PlatformBitmap.Builder()
        .setBitmap(bitmap)
        .build();
    when(bitmapDescriptorFactoryWrapper.fromBitmap(any())).thenReturn(mockBitmapDescriptor2);
    imageRegistry.addBitmapToCache(1L, platformBitmap);
    Assert.assertNotEquals(imageRegistry.getBitmap(1L), mockBitmapDescriptor);
    Assert.assertEquals(imageRegistry.getBitmap(1L), mockBitmapDescriptor2);
  }

  @Test
  public void RemoveBitmapFromCacheRemovesBitmap() {
    final ImageRegistry imageRegistry = new ImageRegistry(assetManager,
        bitmapDescriptorFactoryWrapper, 1L);
    byte[] bmpData = Base64.decode(generateBase64Image(Color.BLACK), Base64.DEFAULT);
    Messages.PlatformBitmapBytesMap bitmap =
        new Messages.PlatformBitmapBytesMap.Builder()
            .setBitmapScaling(Messages.PlatformMapBitmapScaling.AUTO)
            .setImagePixelRatio(2.0)
            .setByteData(bmpData)
            .build();
    Messages.PlatformBitmap platformBitmap = new Messages.PlatformBitmap.Builder()
        .setBitmap(bitmap)
        .build();
    when(bitmapDescriptorFactoryWrapper.fromBitmap(any())).thenReturn(mockBitmapDescriptor);
    imageRegistry.addBitmapToCache(1L, platformBitmap);
    Assert.assertEquals(imageRegistry.getBitmap(1L), mockBitmapDescriptor);

    imageRegistry.removeBitmapFromCache(1L);
    Assert.assertNull(imageRegistry.getBitmap(1L));
  }

  @Test
  public void ClearBitmapCacheRemovesAllSavedBitmaps() {
    final ImageRegistry imageRegistry = new ImageRegistry(assetManager,
        bitmapDescriptorFactoryWrapper, 1L);
    byte[] bmpData = Base64.decode(generateBase64Image(Color.BLACK), Base64.DEFAULT);
    Messages.PlatformBitmapBytesMap bitmap =
        new Messages.PlatformBitmapBytesMap.Builder()
            .setBitmapScaling(Messages.PlatformMapBitmapScaling.AUTO)
            .setImagePixelRatio(2.0)
            .setByteData(bmpData)
            .build();
    Messages.PlatformBitmap platformBitmap = new Messages.PlatformBitmap.Builder()
        .setBitmap(bitmap)
        .build();
    when(bitmapDescriptorFactoryWrapper.fromBitmap(any())).thenReturn(mockBitmapDescriptor);

    imageRegistry.addBitmapToCache(1L, platformBitmap);
    imageRegistry.addBitmapToCache(2L, platformBitmap);
    imageRegistry.addBitmapToCache(3L, platformBitmap);
    Assert.assertEquals(imageRegistry.getBitmap(1L), mockBitmapDescriptor);
    Assert.assertEquals(imageRegistry.getBitmap(2L), mockBitmapDescriptor);
    Assert.assertEquals(imageRegistry.getBitmap(3L), mockBitmapDescriptor);

    imageRegistry.clearBitmapCache();
    Assert.assertNull(imageRegistry.getBitmap(1L));
    Assert.assertNull(imageRegistry.getBitmap(2L));
    Assert.assertNull(imageRegistry.getBitmap(3L));
  }

  @Test
  public void GetBitmapReturnsNullIfBitmapIsNotAvailable() {
    final ImageRegistry imageRegistry = new ImageRegistry(assetManager,
        bitmapDescriptorFactoryWrapper, 1L);
    Assert.assertNull(imageRegistry.getBitmap(0L));
  }

  @Test
  public void GetBitmapReturnsRegisteredBitmap() {
    final ImageRegistry imageRegistry = new ImageRegistry(assetManager,
        bitmapDescriptorFactoryWrapper, 1L);
    byte[] bmpData = Base64.decode(generateBase64Image(Color.BLACK), Base64.DEFAULT);
    Messages.PlatformBitmapBytesMap bitmap =
        new Messages.PlatformBitmapBytesMap.Builder()
            .setBitmapScaling(Messages.PlatformMapBitmapScaling.AUTO)
            .setImagePixelRatio(2.0)
            .setByteData(bmpData)
            .build();
    Messages.PlatformBitmap platformBitmap = new Messages.PlatformBitmap.Builder()
        .setBitmap(bitmap)
        .build();
    when(bitmapDescriptorFactoryWrapper.fromBitmap(any())).thenReturn(mockBitmapDescriptor);

    Assert.assertNull(imageRegistry.getBitmap(1L));
    imageRegistry.addBitmapToCache(1L, platformBitmap);
    Assert.assertEquals(imageRegistry.getBitmap(1L), mockBitmapDescriptor);
  }

  @Test(expected = IllegalArgumentException.class)
  public void AddBitmapToCacheThrowsOnWrongBitmapType() {
    ImageRegistry imageRegistry =
        new ImageRegistry(assetManager, bitmapDescriptorFactoryWrapper, 1L);
    Messages.PlatformBitmapRegisteredMapBitmap registeredMapBitmap =
        new Messages.PlatformBitmapRegisteredMapBitmap.Builder()
            .setId(0L)
            .build();
    Messages.PlatformBitmap platformBitmap = new Messages.PlatformBitmap.Builder()
        .setBitmap(registeredMapBitmap)
        .build();
    try {
      imageRegistry.addBitmapToCache(0L, platformBitmap);
    } catch (IllegalArgumentException e) {
      Assert.assertEquals(e.getMessage(), "PlatformBitmap must contain a supported subtype.");
      throw e;
    }

    fail("Expected an IllegalArgumentException to be thrown");
  }

  // Helper method to generate 1x1 pixel base64 encoded png test image
  private String generateBase64Image(int color) {
    int width = 1;
    int height = 1;
    Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
    Canvas canvas = new Canvas(bitmap);

    // Draw on the Bitmap
    Paint paint = new Paint();
    paint.setColor(color);
    canvas.drawRect(0, 0, width, height, paint);

    // Convert the Bitmap to PNG format
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);
    byte[] pngBytes = outputStream.toByteArray();

    // Encode the PNG bytes as a base64 string
    return Base64.encodeToString(pngBytes, Base64.DEFAULT);
  }
}
