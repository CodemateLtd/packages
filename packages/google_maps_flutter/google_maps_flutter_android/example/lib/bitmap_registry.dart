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

// The name of the bitmap to use for the markers.
const String _bitmapName = 'assets/checkers.png';

class _BitmapRegistryBody extends StatefulWidget {
  const _BitmapRegistryBody();

  @override
  State<_BitmapRegistryBody> createState() => _BitmapRegistryBodyState();
}

class _BitmapRegistryBodyState extends State<_BitmapRegistryBody> {
  final Set<Marker> markers = <Marker>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 2 / 3,
            child: ExampleGoogleMap(
              markers: markers,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 1.0,
              ),
            ),
          ),
          MaterialButton(
            onPressed: _addMarkersWithoutRegistry,
            child: const Text('Add $_numberOfMarkers markers, no registry'),
          ),
          MaterialButton(
            onPressed: _addMarkersWithRegistry,
            child: const Text('Add $_numberOfMarkers markers using registry'),
          ),
        ],
      ),
    );
  }

  /// Add markers to the map with a custom bitmap as the icon.
  ///
  /// To show potential performance issues:
  /// * large original image is used (800x600px, ~330KB)
  /// * bitmap is scaled down to 64x64px
  /// * bitmap is created once and reused for all markers. This doesn't help
  /// much because the bitmap is still sent to the platform side for each
  /// marker.
  ///
  /// Adding many markers may result in a performance hit, out of memory errors
  /// or even app crashes.
  Future<void> _addMarkersWithoutRegistry() async {
    final ByteData byteData = await rootBundle.load(_bitmapName);
    final Uint8List bytes = byteData.buffer.asUint8List();
    final BytesMapBitmap bitmap = BitmapDescriptor.bytes(
      bytes,
      width: 64,
      height: 64,
    );
    _updateMarkers(bitmap);
  }

  /// Add markers to the map with a custom bitmap as the icon placed in the
  /// bitmap registry beforehand.
  ///
  /// Similarly to [_addMarkersWithoutRegistry], this method uses the same
  /// technique to show potential performance issues, however the bitmap is
  /// registered in the bitmap registry before creating the markers.
  Future<void> _addMarkersWithRegistry() async {
    final ByteData byteData = await rootBundle.load(_bitmapName);
    final Uint8List bytes = byteData.buffer.asUint8List();
    final BytesMapBitmap bytesBitmap = BitmapDescriptor.bytes(
      bytes,
      width: 64,
      height: 64,
    );
    const int registeredBitmapId = 0;
    await GoogleMapsFlutterPlatform.instance.registerBitmap(0, bytesBitmap);
    const RegisteredMapBitmap registeredBitmap =
        RegisteredMapBitmap(id: registeredBitmapId);
    _updateMarkers(registeredBitmap);
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
      markers
        ..clear()
        ..addAll(newMarkers);
    });
  }
}
