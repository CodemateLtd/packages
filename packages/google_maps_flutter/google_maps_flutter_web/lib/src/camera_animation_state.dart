// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../google_maps_flutter_web.dart';

/// Camera animation state used with camera animations
class CameraAnimationState {
  /// Creates a new [CameraAnimationState] object.
  CameraAnimationState({
    required this.target,
    required this.zoom,
    required this.tilt,
    required this.heading,
    required this.bounds,
    required this.padding,
  });

  /// Creates a new [CameraAnimationState] object from the specified map.
  factory CameraAnimationState.fromMap(gmaps.Map map) {
    return CameraAnimationState(
      target: map.isCenterDefined() ? map.center : gmaps.LatLng(0, 0),
      zoom: map.isZoomDefined() ? map.zoom : null,
      tilt: map.isTiltDefined() ? map.tilt : null,
      heading: map.isHeadingDefined() ? map.heading : null,
      bounds: map.bounds,
      padding: 0,
    );
  }

  /// Camera target
  final gmaps.LatLng target;

  /// Camera zoom
  final num? zoom;

  /// Camera tilt
  final num? tilt;

  /// Camera bearing
  final num? heading;

  /// Camera bounds
  final gmaps.LatLngBounds? bounds;

  /// Camera bounds padding
  final double? padding;

  /// Creates a new [CameraAnimationState] object whose values are the same as
  /// this instance, unless overwritten by the specified parameters.
  CameraAnimationState copyWith({
    gmaps.LatLng? target,
    num? zoom,
    num? tilt,
    num? heading,
    gmaps.LatLngBounds? bounds,
    double? padding,
  }) {
    return CameraAnimationState(
      target: target ?? this.target,
      zoom: zoom ?? this.zoom,
      tilt: tilt ?? this.tilt,
      heading: heading ?? this.heading,
      bounds:
          bounds, // Always use given value to avoid animating bounds when null.
      padding: padding ?? this.padding,
    );
  }

  /// Applies the camera animation state to the given map.
  void apply({required gmaps.Map map}) {
    map.moveCamera(
      gmaps.CameraOptions(
        center: target,
        zoom: zoom,
        //tilt: tilt,
        //heading: heading,
      ),
    );
    if (bounds != null) {
      map.fitBounds(bounds!);
    }
  }
}

/// Tween for camera animation state
class CameraStateTween extends Tween<CameraAnimationState> {
  /// Creates a new [CameraStateTween] object.
  CameraStateTween({
    required CameraAnimationState begin,
    required CameraAnimationState end,
  }) : super(begin: begin, end: end);

  @override
  CameraAnimationState lerp(double t) {
    return CameraAnimationState(
      target: gmaps.LatLng(
        lerpDouble(begin!.target.lat, end!.target.lat, t)!,
        lerpDouble(begin!.target.lng, end!.target.lng, t)!,
      ),
      zoom: _lerpZoom(t, begin!.zoom, end!.zoom, begin!.target, end!.target),
      tilt: lerpDouble(begin!.tilt, end!.tilt, t),
      heading: lerpDouble(begin!.heading, end!.heading, t),
      bounds: end!.bounds != null
          ? gmaps.LatLngBounds(
              gmaps.LatLng(
                lerpDouble(begin!.bounds?.southWest.lat,
                    end!.bounds?.southWest.lat, t)!,
                lerpDouble(begin!.bounds?.southWest.lng,
                    end!.bounds?.southWest.lng, t)!,
              ),
              gmaps.LatLng(
                lerpDouble(begin!.bounds?.northEast.lat,
                    end!.bounds?.northEast.lat, t)!,
                lerpDouble(begin!.bounds?.northEast.lng,
                    end!.bounds?.northEast.lng, t)!,
              ),
            )
          : null,
      padding: lerpDouble(begin!.padding, end!.padding, t),
    );
  }

  /// Helper method to calculate interpolated zoom value.
  num? _lerpZoom(double t, num? beginZoom, num? endZoom,
      gmaps.LatLng beginTarget, gmaps.LatLng endTarget) {
    if (beginZoom == null ||
        endZoom == null ||
        (beginTarget.lat == endTarget.lat &&
            beginTarget.lng == endTarget.lng)) {
      return null;
    }

    // If the zoom levels are the same, zoom out while camera transitions.
    if (beginZoom == endZoom) {
      final double zoomCurve = Curves.slowMiddle.transform(t);

      final double distance = _calculateDistance(
          beginTarget.lat.toDouble(),
          beginTarget.lng.toDouble(),
          endTarget.lat.toDouble(),
          endTarget.lng.toDouble());

      // TODO: improve this logic to make it work better with
      //       different distances.
      final double zoomOutAmout = (distance / 2).clamp(0, 10);
      return max(
        0,
        lerpDouble(beginZoom, endZoom, t)! -
            zoomOutAmout * 2 * (.5 - (zoomCurve - .5).abs()),
      );
    }

    // Otherwise, simply interpolate between beginZoom and endZoom.
    return lerpDouble(beginZoom, endZoom, t);
  }

  /// Calculates the distance between two points (latitude and longitude) on the Earth using the Haversine formula.
  ///
  /// [lat1] and [lng1] are the coordinates of the first point in decimal degrees.
  /// [lat2] and [lng2] are the coordinates of the second point in decimal degrees.
  ///
  /// Returns the distance between the two points in kilometers.
  double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Converts degrees to radians.
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
