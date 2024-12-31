// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../google_maps_flutter_web.dart';

/// This class manages all the [GroundOverlayController]s associated to a [GoogleMapController].
class GroundOverlaysController extends GeometryController {
  GroundOverlaysController({
    required StreamController<MapEvent<Object?>> stream,
  })  : _streamController = stream,
        _groundOverlayIdToController =
            <GroundOverlayId, GroundOverlayController>{};

  final Map<GroundOverlayId, GroundOverlayController>
      _groundOverlayIdToController;

  // The stream over which polylines broadcast their events
  final StreamController<MapEvent<Object?>> _streamController;

  /// Adds new [GroundOverlay]s to this controller.
  ///
  /// Wraps the [GroundOverlay]s in corresponding [GroundOverlayController]s.
  void addGroundOverlays(Set<GroundOverlay> groundOverlaysToAdd) {
    groundOverlaysToAdd.forEach(_addGroundOverlay);
  }

  void _addGroundOverlay(GroundOverlay groundOverlay) {
    assert(groundOverlay.bounds != null,
        'On Web polatform, bounds must be provided for GroundOverlay');
    if (groundOverlay.bounds == null) {
      return;
    }

    final gmaps.LatLngBounds bounds =
        latLngBoundsToGmlatLngBounds(groundOverlay.bounds!);

    final gmaps.GroundOverlayOptions groundOverlayOptions =
        gmaps.GroundOverlayOptions()
          ..opacity = 1.0 - groundOverlay.transparency
          ..clickable = groundOverlay.clickable
          ..map = googleMap;

    final gmaps.GroundOverlay overlay = gmaps.GroundOverlay(
        urlFromBitmapDescriptor(groundOverlay.image),
        bounds,
        groundOverlayOptions);

    final GroundOverlayController controller = GroundOverlayController(
      groundOverlay: overlay,
      onTap: () {
        _onGroundOverlayTap(groundOverlay.groundOverlayId);
      },
    );

    _groundOverlayIdToController[groundOverlay.groundOverlayId] = controller;
  }

  /// Updates [GroundOverlay]s with new options.
  void changeGroundOverlays(Set<GroundOverlay> groundOverlays) {
    groundOverlays.forEach(_changeGroundOverlay);
  }

  void _changeGroundOverlay(GroundOverlay groundOverlay) {
    final GroundOverlayController? controller =
        _groundOverlayIdToController[groundOverlay.groundOverlayId];

    if (controller == null) {
      return;
    }

    assert(groundOverlay.bounds != null,
        'On Web polatform, bounds must be provided for GroundOverlay');
    if (groundOverlay.bounds == null) {
      return;
    }

    controller.groundOverlay.opacity = 1.0 - groundOverlay.transparency;
  }

  /// Removes the ground overlays associated with the given [GroundOverlayId]s.
  void removeGroundOverlays(Set<GroundOverlayId> groundOverlayIds) {
    groundOverlayIds.forEach(_removeGroundOverlay);
  }

  void _removeGroundOverlay(GroundOverlayId groundOverlayId) {
    final GroundOverlayController? controller =
        _groundOverlayIdToController.remove(groundOverlayId);
    if (controller != null) {
      controller.remove();
    }
  }

  // Handle internal events
  void _onGroundOverlayTap(GroundOverlayId groundOverlayId) {
    _streamController.add(GroundOverlayTapEvent(mapId, groundOverlayId));
  }
}