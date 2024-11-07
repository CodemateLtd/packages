// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'example_google_map.dart';
import 'page.dart';

class AnimateCameraPage extends GoogleMapExampleAppPage {
  const AnimateCameraPage({Key? key})
      : super(const Icon(Icons.map), 'Camera control, animated', key: key);

  @override
  Widget build(BuildContext context) {
    return const AnimateCamera();
  }
}

class AnimateCamera extends StatefulWidget {
  const AnimateCamera({super.key});
  @override
  State createState() => AnimateCameraState();
}

// Animation duration for a animation configuration.
const int _durationSeconds = 10;

class AnimateCameraState extends State<AnimateCamera> {
  ExampleGoogleMapController? mapController;
  CameraUpdateAnimationConfiguration? _cameraUpdateAnimationConfiguration;

  // ignore: use_setters_to_change_properties
  void _onMapCreated(ExampleGoogleMapController controller) {
    mapController = controller;
  }

  void _toggleAnimationConfiguration() {
    setState(() {
      _cameraUpdateAnimationConfiguration =
          _cameraUpdateAnimationConfiguration != null
              ? null
              : const CameraUpdateAnimationConfiguration(
                  duration: Duration(seconds: _durationSeconds));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: ExampleGoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  const CameraPosition(target: LatLng(0.0, 0.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.newCameraPosition(
                        const CameraPosition(
                          bearing: 270.0,
                          target: LatLng(51.5160895, -0.1294527),
                          tilt: 30.0,
                          zoom: 17.0,
                        ),
                      ),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('newCameraPosition'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.newLatLng(
                        const LatLng(56.1725505, 10.1850512),
                      ),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('newLatLng'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.newLatLngBounds(
                        LatLngBounds(
                          southwest: const LatLng(-38.483935, 113.248673),
                          northeast: const LatLng(-8.982446, 153.823821),
                        ),
                        10.0,
                      ),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('newLatLngBounds'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        const LatLng(37.4231613, -122.087159),
                        11.0,
                      ),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('newLatLngZoom'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.scrollBy(150.0, -225.0),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('scrollBy'),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.zoomBy(
                        -0.5,
                        const Offset(30.0, 20.0),
                      ),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('zoomBy with focus'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.zoomBy(-0.5),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('zoomBy'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.zoomIn(),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('zoomIn'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.zoomOut(),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('zoomOut'),
                ),
                TextButton(
                  onPressed: () {
                    mapController?.animateCamera(
                      CameraUpdate.zoomTo(16.0),
                      configuration: _cameraUpdateAnimationConfiguration,
                    );
                  },
                  child: const Text('zoomTo'),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'With configuration\n(10 second duration)',
              textAlign: TextAlign.right,
            ),
            const SizedBox(width: 5),
            Switch(
              value: _cameraUpdateAnimationConfiguration != null,
              onChanged: (bool value) {
                _toggleAnimationConfiguration();
              },
            ),
          ],
        ),
      ],
    );
  }
}
