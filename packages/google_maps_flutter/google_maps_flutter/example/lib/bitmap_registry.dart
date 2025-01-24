// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

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
const int _numberOfMarkers = 5000;

class _BitmapRegistryBody extends StatefulWidget {
  const _BitmapRegistryBody();

  @override
  State<_BitmapRegistryBody> createState() => _BitmapRegistryBodyState();
}

class _BitmapRegistryBodyState extends State<_BitmapRegistryBody> {
  final Set<Marker> markers = <Marker>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GoogleMap(
            markers: markers,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 1.0,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () async {
            final AssetMapBitmap bitmap = await BitmapDescriptor.asset(
              ImageConfiguration.empty,
              'assets/red_rectangle.png',
            );

            _updateMarkers(bitmap);
          },
          child: const Text('Test 1 (asset), no registry'),
        ),
        MaterialButton(
          onPressed: () async {
            final AssetMapBitmap asset = await BitmapDescriptor.asset(
              ImageConfiguration.empty,
              'assets/red_rectangle.png',
            );
            final RegisteredMapBitmap registeredBitmap =
                await GoogleMapBitmapRegistry.instance.register(asset);
            _updateMarkers(registeredBitmap);
          },
          child: const Text('Test 1 (asset), with registry'),
        ),
        const Divider(),
        MaterialButton(
          onPressed: () async {
            final ByteData byteData =
                await rootBundle.load('assets/red_rectangle.png');
            final Uint8List bytes = byteData.buffer.asUint8List();
            final BytesMapBitmap bitmap = BitmapDescriptor.bytes(bytes);
            _updateMarkers(bitmap);
          },
          child: const Text('Test 2 (bytes), no registry'),
        ),
        MaterialButton(
          onPressed: () async {
            final ByteData byteData =
                await rootBundle.load('assets/red_rectangle.png');
            final Uint8List bytes = byteData.buffer.asUint8List();
            final BytesMapBitmap bytesBitmap = BitmapDescriptor.bytes(bytes);
            final RegisteredMapBitmap registeredBitmap =
                await GoogleMapBitmapRegistry.instance.register(bytesBitmap);
            _updateMarkers(registeredBitmap);
          },
          child: const Text('Test 2 (bytes), with registry'),
        ),
      ],
    );
  }

  Marker _createMarker(int id, BitmapDescriptor bitmap) {
    return Marker(
      markerId: MarkerId('$id'),
      icon: bitmap,
      position: LatLng(
        Random().nextDouble() * 100 - 50,
        Random().nextDouble() * 100 - 50,
      ),
    );
  }

  void _updateMarkers(BitmapDescriptor bitmap) {
    final List<Marker> newMarkers = List<Marker>.generate(
      _numberOfMarkers,
      (int i) => _createMarker(i, bitmap),
    );

    setState(() {
      markers
        ..clear()
        ..addAll(newMarkers);
    });
  }
}
