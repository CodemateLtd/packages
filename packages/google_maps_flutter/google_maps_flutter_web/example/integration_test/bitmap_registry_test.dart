import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  GoogleMapsFlutterPlatform.instance.enableDebugInspection();

  testWidgets('Add bitmap to cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    await GoogleMapBitmapRegistry.instance.register(bitmap);
  });

  testWidgets('Remove bitmap from cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    final int id = await GoogleMapBitmapRegistry.instance.register(bitmap);
    await GoogleMapBitmapRegistry.instance.unregister(id);
  });

  testWidgets('Clear bitmap cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    await GoogleMapBitmapRegistry.instance.clear();
    await GoogleMapBitmapRegistry.instance.register(bitmap);
    await GoogleMapBitmapRegistry.instance.clear();
  });
}
