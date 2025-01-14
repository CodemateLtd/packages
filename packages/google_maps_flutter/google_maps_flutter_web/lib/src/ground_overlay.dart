// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../google_maps_flutter_web.dart';

/// This wraps a [GroundOverlay] in a [gmaps.MapType].
class GroundOverlayController {
  /// Creates a [GroundOverlayController] that wraps a
  /// [gmaps.GroundOverlay] object.
  GroundOverlayController({
    required gmaps.GroundOverlay groundOverlay,
    VoidCallback? onTap,
  }) {
    _groundOverlay = groundOverlay;
    if (onTap != null) {
      _groundOverlay.onClick.listen((gmaps.MapMouseEvent event) {
        onTap.call();
      });
    }
  }

  /// The [GroundOverlay] providing data for this controller.
  gmaps.GroundOverlay get groundOverlay => _groundOverlay;
  late gmaps.GroundOverlay _groundOverlay;

  /// Removes the [GroundOverlay] from the map.
  void remove() {
    _groundOverlay.map = null;
  }
}
