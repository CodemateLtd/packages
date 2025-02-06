import 'package:flutter_test/flutter_test.dart';
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

    await GoogleMapsFlutterPlatform.instance.registerBitmap(1, bitmap);
  });

  testWidgets('Remove bitmap from cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    await GoogleMapsFlutterPlatform.instance.registerBitmap(1, bitmap);
    await GoogleMapsFlutterPlatform.instance.unregisterBitmap(1);
  });

  testWidgets('Clear bitmap cache', (WidgetTester tester) async {
    final AssetMapBitmap bitmap = AssetMapBitmap(
      'assets/red_square.png',
      imagePixelRatio: 1.0,
    );

    await GoogleMapsFlutterPlatform.instance.clearBitmapCache();
    await GoogleMapsFlutterPlatform.instance.registerBitmap(1, bitmap);
    await GoogleMapsFlutterPlatform.instance.clearBitmapCache();
  });
}
