// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'example_google_map.dart';
import 'page.dart';

class BitmapRegistryPage extends GoogleMapExampleAppPage {
  const BitmapRegistryPage({Key? key})
      : super(const Icon(Icons.speed), 'Bitmap registry', key: key);

  @override
  Widget build(BuildContext context) {
    return const _BitmapRegistryBody();
  }
}

// How many markers to place on the map.
const int _numberOfMarkers = 500;

class _BitmapRegistryBody extends StatefulWidget {
  const _BitmapRegistryBody();

  @override
  State<_BitmapRegistryBody> createState() => _BitmapRegistryBodyState();
}

class _BitmapRegistryBodyState extends State<_BitmapRegistryBody> {
  final Set<Marker> _markers = <Marker>{};
  int? _registeredBitmapId;

  @override
  void initState() {
    super.initState();

    _registerBitmap();
  }

  @override
  void dispose() {
    _unregisterBitmap();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ExampleGoogleMap(
              markers: _markers,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 1.0,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              // Add markers to the map with a custom bitmap as the icon.
              //
              // To show potential performance issues:
              // * large original image is used (800x600px, ~330KB)
              // * bitmap is scaled down to 64x64px
              // * bitmap is created once and reused for all markers. This
              // doesn't help much because the bitmap is still sent to the
              // platform side for each marker.
              //
              // Adding many markers may result in a performance hit,
              // out of memory errors or even app crashes.
              final BytesMapBitmap bitmap = await _getAssetBitmapDescriptor();
              _updateMarkers(bitmap);
            },
            child: const Text('Add $_numberOfMarkers markers, no registry'),
          ),
          MaterialButton(
            onPressed: _registeredBitmapId == null
                ? null
                : () {
                    // Add markers to the map with a custom bitmap as the icon
                    // placed in the bitmap registry beforehand.
                    final RegisteredMapBitmap registeredBitmap =
                        RegisteredMapBitmap(id: _registeredBitmapId!);
                    _updateMarkers(registeredBitmap);
                  },
            child: const Text('Add $_numberOfMarkers markers using registry'),
          ),
        ],
      ),
    );
  }

  /// Register a bitmap in the bitmap registry.
  Future<void> _registerBitmap() async {
    if (_registeredBitmapId != null) {
      return;
    }

    final BytesMapBitmap bitmap = await _getAssetBitmapDescriptor();
    const int registeredBitmapId = 1;
    await GoogleMapsFlutterPlatform.instance.registerBitmap(1, bitmap);

    // If the widget was disposed before the bitmap was registered, unregister
    // the bitmap.
    if (!mounted) {
      _unregisterBitmap();
      return;
    }

    setState(() {
      _registeredBitmapId = registeredBitmapId;
    });
  }

  /// Unregister the bitmap from the bitmap registry.
  void _unregisterBitmap() {
    if (_registeredBitmapId == null) {
      return;
    }

    GoogleMapsFlutterPlatform.instance.unregisterBitmap(_registeredBitmapId!);
    _registeredBitmapId = null;
  }

  // Create a set of markers with the given bitmap and update the state with new
  // markers.
  void _updateMarkers(BitmapDescriptor bitmap) {
    final List<Marker> newMarkers = List<Marker>.generate(
      _numberOfMarkers,
      (int id) {
        return Marker(
          markerId: MarkerId('$id'),
          icon: bitmap,
          position: LatLng(
            Random().nextDouble() * 100 - 50,
            Random().nextDouble() * 100 - 50,
          ),
        );
      },
    );

    setState(() {
      _markers
        ..clear()
        ..addAll(newMarkers);
    });
  }

  /// Load a bitmap from an asset and create a scaled [BytesMapBitmap] from it.
  Future<BytesMapBitmap> _getAssetBitmapDescriptor() async {
    final ByteData byteData = await rootBundle.load('assets/checkers.png');
    final Uint8List bytes = byteData.buffer.asUint8List();
    return BitmapDescriptor.bytes(
      bytes,
      width: 64,
      height: 64,
    );
  }
}
