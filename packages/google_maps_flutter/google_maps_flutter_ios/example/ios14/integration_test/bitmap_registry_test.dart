import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:integration_test/integration_test.dart';
import 'package:maps_example_dart/example_google_map.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  GoogleMapsFlutterPlatform.instance.enableDebugInspection();

  testWidgets('Add bitmap to cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    final int mapId = await _pumpMap(tester);
    await GoogleMapsFlutterPlatform.instance.registerBitmap(1, bitmap);
    expect(
      await GoogleMapsInspectorPlatform.instance!.hasRegisteredMapBitmap(
        mapId: mapId,
        bitmapId: 1,
      ),
      isTrue,
    );
  });

  testWidgets('Remove bitmap from cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    final int mapId = await _pumpMap(tester);
    await GoogleMapsFlutterPlatform.instance.registerBitmap(1, bitmap);
    expect(
      await GoogleMapsInspectorPlatform.instance!.hasRegisteredMapBitmap(
        mapId: mapId,
        bitmapId: 1,
      ),
      isTrue,
    );

    await GoogleMapsFlutterPlatform.instance.unregisterBitmap(1);
    expect(
      await GoogleMapsInspectorPlatform.instance!.hasRegisteredMapBitmap(
        mapId: mapId,
        bitmapId: 1,
      ),
      isFalse,
    );
  });

  testWidgets('Clear bitmap cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    final int mapId = await _pumpMap(tester);
    await GoogleMapsFlutterPlatform.instance.clearBitmapCache();
    await GoogleMapsFlutterPlatform.instance.registerBitmap(1, bitmap);
    expect(
      await GoogleMapsInspectorPlatform.instance!.hasRegisteredMapBitmap(
        mapId: mapId,
        bitmapId: 1,
      ),
      isTrue,
    );

    await GoogleMapsFlutterPlatform.instance.clearBitmapCache();
    expect(
      await GoogleMapsInspectorPlatform.instance!.hasRegisteredMapBitmap(
        mapId: mapId,
        bitmapId: 1,
      ),
      isFalse,
    );
  });
}

// Pump a map and return the map ID.
Future<int> _pumpMap(WidgetTester tester) async {
  final Completer<ExampleGoogleMapController> controllerCompleter =
      Completer<ExampleGoogleMapController>();

  await tester.pumpWidget(Directionality(
    textDirection: TextDirection.ltr,
    child: ExampleGoogleMap(
      initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
      onMapCreated: (ExampleGoogleMapController googleMapController) {
        controllerCompleter.complete(googleMapController);
      },
    ),
  ));

  final ExampleGoogleMapController controller =
      await controllerCompleter.future;
  return controller.mapId;
}
