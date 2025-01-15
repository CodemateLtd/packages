// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

enum _GroundOverlayPlacing { position, bounds }

class GroundOverlayPage extends GoogleMapExampleAppPage {
  const GroundOverlayPage({Key? key})
      : super(const Icon(Icons.map), 'Ground overlay', key: key);

  @override
  Widget build(BuildContext context) {
    return const GroundOverlayBody();
  }
}

class GroundOverlayBody extends StatefulWidget {
  const GroundOverlayBody({super.key});

  @override
  State<StatefulWidget> createState() => GroundOverlayBodyState();
}

class GroundOverlayBodyState extends State<GroundOverlayBody> {
  GroundOverlayBodyState();

  GoogleMapController? controller;
  GroundOverlay? _groundOverlay;

  final LatLng _mapCenter = const LatLng(37.422026, -122.085329);

  _GroundOverlayPlacing _placingType = _GroundOverlayPlacing.bounds;

  // Positions for demonstranting placing ground overlays with position, and
  // changing positions.
  final LatLng _groundOverlayPos1 = const LatLng(37.422026, -122.085329);
  final LatLng _groundOverlayPos2 = const LatLng(37.42, -122.08);
  late LatLng _currentGroundOverlayPos;

  // Bounds for demonstranting placing ground overlays with bounds, and
  // changing bounds.
  final LatLngBounds _groundOverlayBounds1 = LatLngBounds(
      southwest: const LatLng(37.42, -122.09),
      northeast: const LatLng(37.423, -122.084));
  final LatLngBounds _groundOverlayBounds2 = LatLngBounds(
      southwest: const LatLng(37.421, -122.091),
      northeast: const LatLng(37.424, -122.08));
  late LatLngBounds _currentGroundOverlayBounds;

  Offset _anchor = const Offset(0.5, 0.5);

  Offset _dimensions = const Offset(1000, 1000);

  // Index to be used as identifier for the ground overlay.
  // If position is changed to bounds and vice versa, the ground overlay will
  // be removed and added again with the new type. Also anchor can be given only
  // when the ground overlay is created with position and cannot be changed
  // after the ground overlay is created.
  int _groundOverlayIndex = 0;

  @override
  void initState() {
    _currentGroundOverlayPos = _groundOverlayPos1;
    _currentGroundOverlayBounds = _groundOverlayBounds1;
    super.initState();
  }

  // ignore: use_setters_to_change_properties
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  void _removeGroundOverlay() {
    setState(() {
      _groundOverlay = null;
    });
  }

  Future<void> _addGroundOverlay() async {
    final AssetMapBitmap assetMapBitmap = await AssetMapBitmap.create(
      createLocalImageConfiguration(context),
      'assets/red_square.png',
      bitmapScaling: MapBitmapScaling.none,
    );

    _groundOverlayIndex += 1;

    final GroundOverlayId id =
        GroundOverlayId('ground_overlay_$_groundOverlayIndex');

    final GroundOverlay groundOverlay = switch (_placingType) {
      _GroundOverlayPlacing.position => GroundOverlay.fromPosition(
          groundOverlayId: id,
          image: assetMapBitmap,
          position: _currentGroundOverlayPos,
          width: _dimensions.dx, // Android only
          height: _dimensions.dy, // Android only
          zoomLevel: 14.0, // iOS only
          anchor: _anchor,
          onTap: () {
            _onGroundOverlayTapped();
          },
        ),
      _GroundOverlayPlacing.bounds => GroundOverlay.fromBounds(
          groundOverlayId: id,
          image: assetMapBitmap,
          bounds: _currentGroundOverlayBounds,
          anchor: _anchor,
          onTap: () {
            _onGroundOverlayTapped();
          },
        ),
    };

    setState(() {
      _groundOverlay = groundOverlay;
    });
  }

  void _onGroundOverlayTapped() {
    _changePosition();
  }

  void _setBearing() {
    assert(_groundOverlay != null);
    setState(() {
      _groundOverlay = _groundOverlay!.copyWith(
          bearingParam: _groundOverlay!.bearing >= 350
              ? 0
              : _groundOverlay!.bearing + 10);
    });
  }

  void _changeTransparency() {
    assert(_groundOverlay != null);
    setState(() {
      final double transparency =
          _groundOverlay!.transparency == 0.0 ? 0.5 : 0.0;
      _groundOverlay =
          _groundOverlay!.copyWith(transparencyParam: transparency);
    });
  }

  Future<void> _changeDimensions() async {
    assert(_groundOverlay != null);
    assert(_placingType == _GroundOverlayPlacing.position);
    setState(() {
      _dimensions = _dimensions == const Offset(1000, 1000)
          ? const Offset(1500, 500)
          : const Offset(1000, 1000);
    });

    // Re-add the ground overlay to apply the new position, as the position
    // cannot be changed after the ground overlay is created on all platforms.
    await _addGroundOverlay();
  }

  Future<void> _changePosition() async {
    assert(_groundOverlay != null);
    assert(_placingType == _GroundOverlayPlacing.position);
    setState(() {
      _currentGroundOverlayPos = _currentGroundOverlayPos == _groundOverlayPos1
          ? _groundOverlayPos2
          : _groundOverlayPos1;
    });

    // Re-add the ground overlay to apply the new position, as the position
    // cannot be changed after the ground overlay is created on all platforms.
    await _addGroundOverlay();
  }

  Future<void> _changeBounds() async {
    assert(_groundOverlay != null);
    assert(_placingType == _GroundOverlayPlacing.bounds);
    setState(() {
      _currentGroundOverlayBounds =
          _currentGroundOverlayBounds == _groundOverlayBounds1
              ? _groundOverlayBounds2
              : _groundOverlayBounds1;
    });

    // Re-add the ground overlay to apply the new bounds as the bounds cannot be
    // changed after the ground overlay is created on all platforms.
    await _addGroundOverlay();
  }

  void _toggleVisible() {
    assert(_groundOverlay != null);
    setState(() {
      _groundOverlay =
          _groundOverlay!.copyWith(visibleParam: !_groundOverlay!.visible);
    });
  }

  void _changeZIndex() {
    assert(_groundOverlay != null);
    final double current = _groundOverlay!.zIndex;
    final double zIndex = current == 12.0 ? 0.0 : current + 1.0;
    setState(() {
      _groundOverlay = _groundOverlay!.copyWith(zIndexParam: zIndex);
    });
  }

  Future<void> _changeType() async {
    setState(() {
      _placingType = _placingType == _GroundOverlayPlacing.position
          ? _GroundOverlayPlacing.bounds
          : _GroundOverlayPlacing.position;
    });

    // Re-add the ground overlay to change the positioning type.
    await _addGroundOverlay();
  }

  Future<void> _changeAnchor() async {
    assert(_groundOverlay != null);
    setState(() {
      _anchor = _groundOverlay!.anchor == const Offset(0.5, 0.5)
          ? const Offset(1.0, 1.0)
          : const Offset(0.5, 0.5);
    });

    // Re-add the ground overlay to apply the new anchor as the anchor cannot be
    // changed after the ground overlay is created.
    await _addGroundOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final Set<GroundOverlay> overlays = <GroundOverlay>{
      if (_groundOverlay != null) _groundOverlay!,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _mapCenter,
              zoom: 14.0,
            ),
            groundOverlays: overlays,
            onMapCreated: _onMapCreated,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: _addGroundOverlay,
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: _removeGroundOverlay,
              child: const Text('Remove'),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed:
                  _groundOverlay == null ? null : () => _changeTransparency(),
              child: const Text('change transparency'),
            ),
            if (!kIsWeb)
              TextButton(
                onPressed: _groundOverlay == null ? null : () => _setBearing(),
                child: const Text('change bearing'),
              ),
            TextButton(
              onPressed: _groundOverlay == null ? null : () => _toggleVisible(),
              child: const Text('toggle visible'),
            ),
            if (!kIsWeb)
              TextButton(
                onPressed:
                    _groundOverlay == null ? null : () => _changeZIndex(),
                child: const Text('change zIndex'),
              ),
            if (!kIsWeb)
              TextButton(
                onPressed:
                    _groundOverlay == null ? null : () => _changeAnchor(),
                child: const Text('change anchor'),
              ),
            if (!kIsWeb)
              TextButton(
                onPressed: _groundOverlay == null ? null : () => _changeType(),
                child: Text(_placingType == _GroundOverlayPlacing.position
                    ? 'use bounds'
                    : 'use position'),
              ),
            if (!kIsWeb)
              TextButton(
                onPressed: _placingType != _GroundOverlayPlacing.position ||
                        _groundOverlay == null
                    ? null
                    : () => _changePosition(),
                child: const Text('change position'),
              ),
            if (!kIsWeb)
              TextButton(
                onPressed: _placingType != _GroundOverlayPlacing.position ||
                        _groundOverlay == null
                    ? null
                    : () => _changeDimensions(),
                child: const Text('change dimensions'),
              ),
            TextButton(
              onPressed: _placingType != _GroundOverlayPlacing.bounds ||
                      _groundOverlay == null
                  ? null
                  : () => _changeBounds(),
              child: const Text('change bounds'),
            ),
          ],
        ),
      ],
    );
  }
}
