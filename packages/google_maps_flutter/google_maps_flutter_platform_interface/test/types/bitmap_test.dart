// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$BitmapDescriptor', () {
    test('toJson / fromJson', () {
      final BitmapDescriptor descriptor =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

      final Object expected = <Object>[
        'defaultMarker',
        BitmapDescriptor.hueCyan
      ];
      expect(descriptor.toJson(), equals(expected)); // Same JSON
    });

    group('createFromAsset constructor', () {
      test('without mipmaps', () async {
        final BitmapDescriptor descriptor =
            await BitmapDescriptor.createFromAsset(
                ImageConfiguration.empty, 'path_to_asset_image',
                mipmaps: false);
        expect(descriptor, isA<BitmapDescriptor>());
        expect(
            descriptor.toJson(),
            equals(<Object>[
              'asset',
              'path_to_asset_image',
              BitmapDescriptor.bitmapAutoScaling,
              1.0
            ]));
      });
      test('with mipmaps', () async {
        final BitmapDescriptor descriptor =
            await BitmapDescriptor.createFromAsset(
                ImageConfiguration.empty, 'path_to_asset_image',
                // ignore: avoid_redundant_argument_values
                mipmaps: true);
        expect(descriptor, isA<BitmapDescriptor>());
        expect(
            descriptor.toJson(),
            equals(<Object>[
              'asset',
              'path_to_asset_image',
              BitmapDescriptor.bitmapAutoScaling,
              1.0
            ]));
      });
      test('with size and without mipmaps', () async {
        final double devicePixelRatio = WidgetsBinding
            .instance.platformDispatcher.views.first.devicePixelRatio;
        const Size size = Size(100, 200);
        final ImageConfiguration imageConfiguration =
            ImageConfiguration(size: size, devicePixelRatio: devicePixelRatio);
        final BitmapDescriptor descriptor =
            await BitmapDescriptor.createFromAsset(
                imageConfiguration, 'path_to_asset_image',
                mipmaps: false);

        expect(descriptor, isA<BitmapDescriptor>());
        expect(
            descriptor.toJson(),
            equals(<Object>[
              'asset',
              'path_to_asset_image',
              BitmapDescriptor.bitmapAutoScaling,
              devicePixelRatio,
              <double>[size.width, size.height]
            ]));
      });

      test('with size and mipmaps', () async {
        final double devicePixelRatio = WidgetsBinding
            .instance.platformDispatcher.views.first.devicePixelRatio;
        const Size size = Size(100, 200);
        final ImageConfiguration imageConfiguration =
            ImageConfiguration(size: size, devicePixelRatio: devicePixelRatio);
        final BitmapDescriptor descriptor =
            await BitmapDescriptor.createFromAsset(
                imageConfiguration, 'path_to_asset_image',
                // ignore: avoid_redundant_argument_values
                mipmaps: true);

        expect(descriptor, isA<BitmapDescriptor>());
        expect(
            descriptor.toJson(),
            equals(<Object>[
              'asset',
              'path_to_asset_image',
              BitmapDescriptor.bitmapAutoScaling,
              1.0,
              <double>[size.width, size.height]
            ]));
      });
    });

    group('createFromBytes constructor', () {
      test('with empty byte array, throws assertion error', () {
        expect(() {
          BitmapDescriptor.createFromBytes(Uint8List.fromList(<int>[]));
        }, throwsAssertionError);
      });

      test('with bytes', () {
        final BitmapDescriptor descriptor = BitmapDescriptor.createFromBytes(
          Uint8List.fromList(<int>[1, 2, 3]),
        );
        expect(descriptor, isA<BitmapDescriptor>());
        expect(
            descriptor.toJson(),
            equals(<Object>[
              'bytes',
              <int>[1, 2, 3],
              BitmapDescriptor.bitmapAutoScaling,
              1.0
            ]));
      });

      test('with size', () {
        final BitmapDescriptor descriptor = BitmapDescriptor.createFromBytes(
          Uint8List.fromList(<int>[1, 2, 3]),
          size: const Size(40, 20),
        );

        expect(
            descriptor.toJson(),
            equals(<Object>[
              'bytes',
              <int>[1, 2, 3],
              BitmapDescriptor.bitmapAutoScaling,
              1.0,
              <int>[40, 20],
            ]));
      }, skip: !kIsWeb);
    });

    group('fromJson validation', () {
      group('type validation', () {
        test('correct type', () {
          expect(BitmapDescriptor.fromJson(<dynamic>['defaultMarker']),
              isA<BitmapDescriptor>());
        });
        test('wrong type', () {
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['bogusType']);
          }, throwsAssertionError);
        });
      });
      group('defaultMarker', () {
        test('hue is null', () {
          expect(BitmapDescriptor.fromJson(<dynamic>['defaultMarker']),
              isA<BitmapDescriptor>());
        });
        test('hue is number', () {
          expect(BitmapDescriptor.fromJson(<dynamic>['defaultMarker', 158]),
              isA<BitmapDescriptor>());
        });
        test('hue is not number', () {
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['defaultMarker', 'nope']);
          }, throwsAssertionError);
        });
        test('hue is out of range', () {
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['defaultMarker', -1]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['defaultMarker', 361]);
          }, throwsAssertionError);
        });
      });
      group('fromBytes', () {
        test('with bytes', () {
          expect(
              BitmapDescriptor.fromJson(<dynamic>[
                'fromBytes',
                Uint8List.fromList(<int>[1, 2, 3])
              ]),
              isA<BitmapDescriptor>());
        });
        test('without bytes', () {
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['fromBytes', null]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['fromBytes', <dynamic>[]]);
          }, throwsAssertionError);
        });
      });
      group('fromAsset', () {
        test('name is passed', () {
          expect(
              BitmapDescriptor.fromJson(
                  <dynamic>['fromAsset', 'some/path.png']),
              isA<BitmapDescriptor>());
        });
        test('name cannot be null or empty', () {
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['fromAsset', null]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['fromAsset', '']);
          }, throwsAssertionError);
        });
        test('package is passed', () {
          expect(
              BitmapDescriptor.fromJson(
                  <dynamic>['fromAsset', 'some/path.png', 'some_package']),
              isA<BitmapDescriptor>());
        });
        test('package cannot be null or empty', () {
          expect(() {
            BitmapDescriptor.fromJson(
                <dynamic>['fromAsset', 'some/path.png', null]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(
                <dynamic>['fromAsset', 'some/path.png', '']);
          }, throwsAssertionError);
        });
      });
      group('fromAssetImage', () {
        test('name and dpi passed', () {
          expect(
              BitmapDescriptor.fromJson(
                  <dynamic>['fromAssetImage', 'some/path.png', 1.0]),
              isA<BitmapDescriptor>());
        });

        test('mipmaps determines dpi', () async {
          const ImageConfiguration imageConfiguration = ImageConfiguration(
            devicePixelRatio: 3,
          );

          final BitmapDescriptor mip = await BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            'red_square.png',
          );
          final BitmapDescriptor scaled = await BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            'red_square.png',
            mipmaps: false,
          );

          expect((mip.toJson() as List<dynamic>)[2], 1);
          expect((scaled.toJson() as List<dynamic>)[2], 3);
        });

        test('name cannot be null or empty', () {
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['fromAssetImage', null, 1.0]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>['fromAssetImage', '', 1.0]);
          }, throwsAssertionError);
        });
        test('dpi must be number', () {
          expect(() {
            BitmapDescriptor.fromJson(
                <dynamic>['fromAssetImage', 'some/path.png', null]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(
                <dynamic>['fromAssetImage', 'some/path.png', 'one']);
          }, throwsAssertionError);
        });
        test('with optional [width, height] List', () {
          expect(
              BitmapDescriptor.fromJson(<dynamic>[
                'fromAssetImage',
                'some/path.png',
                1.0,
                <dynamic>[640, 480]
              ]),
              isA<BitmapDescriptor>());
        });
        test(
            'optional [width, height] List cannot be null or not contain 2 elements',
            () {
          expect(() {
            BitmapDescriptor.fromJson(
                <dynamic>['fromAssetImage', 'some/path.png', 1.0, null]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(
                <dynamic>['fromAssetImage', 'some/path.png', 1.0, <dynamic>[]]);
          }, throwsAssertionError);
          expect(() {
            BitmapDescriptor.fromJson(<dynamic>[
              'fromAssetImage',
              'some/path.png',
              1.0,
              <dynamic>[640, 480, 1024]
            ]);
          }, throwsAssertionError);
        });
      });
    });
  });
}
