import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'fake_google_maps_flutter_platform.dart';

void main() {
  late FakeGoogleMapsFlutterPlatform platform;

  setUp(() {
    platform = FakeGoogleMapsFlutterPlatform();
    GoogleMapsFlutterPlatform.instance = platform;
  });

  test('Adding bitmap to registry', () async {
    final BytesMapBitmap bitmap = BytesMapBitmap(Uint8List(20));
    final int id = await GoogleMapBitmapRegistry.instance.register(bitmap);
    expect(id, 1);
    expect(
      platform.bitmapRegistryRecorder.bitmaps,
      <String>['REGISTER $id $bitmap'],
    );
  });

  test('Removing bitmap from registry', () async {
    final BytesMapBitmap bitmap = BytesMapBitmap(Uint8List(20));
    final int id = await GoogleMapBitmapRegistry.instance.register(bitmap);
    await GoogleMapBitmapRegistry.instance.unregister(id);
    expect(
      platform.bitmapRegistryRecorder.bitmaps,
      <String>['REGISTER $id $bitmap', 'UNREGISTER $id'],
    );
  });

  test('Clearing bitmap registry', () async {
    final BytesMapBitmap bitmap = BytesMapBitmap(Uint8List(20));
    final int id1 = await GoogleMapBitmapRegistry.instance.register(bitmap);
    final int id2 = await GoogleMapBitmapRegistry.instance.register(bitmap);
    expect(
      platform.bitmapRegistryRecorder.bitmaps,
      <String>['REGISTER $id1 $bitmap', 'REGISTER $id2 $bitmap'],
    );

    await GoogleMapBitmapRegistry.instance.clear();
    expect(
      platform.bitmapRegistryRecorder.bitmaps,
      <String>['REGISTER $id1 $bitmap', 'REGISTER $id2 $bitmap', 'CLEAR CACHE'],
    );
  });

  test('Bitmap ID is incremental', () async {
    final BytesMapBitmap bitmap = BytesMapBitmap(Uint8List(20));
    final int id1 = await GoogleMapBitmapRegistry.instance.register(bitmap);
    final int id2 = await GoogleMapBitmapRegistry.instance.register(bitmap);
    final int id3 = await GoogleMapBitmapRegistry.instance.register(bitmap);
    final int id4 = await GoogleMapBitmapRegistry.instance.register(bitmap);
    expect(id2, id1 + 1);
    expect(id3, id1 + 2);
    expect(id4, id1 + 3);
  });
}
