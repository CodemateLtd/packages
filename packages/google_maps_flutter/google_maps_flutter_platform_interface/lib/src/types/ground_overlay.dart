// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart' show immutable;

import 'types.dart';

/// Uniquely identifies a [GroundOverlay] among [GoogleMap] ground overlays.
@immutable
class GroundOverlayId extends MapsObjectId<GroundOverlay> {
  /// Creates an immutable identifier for a [GroundOverlay].
  const GroundOverlayId(super.value);
}

/// Ground overlay to be drawn on the map.
///
/// A ground overlay is an image that is fixed to a map. Unlike markers, ground
/// overlays are oriented against the Earth's surface rather than the screen,
/// so rotating, tilting or zooming the map will change the orientation of the
/// image. Ground overlays are useful when you wish to fix a single image at
/// one area on the map. If you want to add extensive imagery that covers a
/// large portion of the map, you should consider a [TileOverlay].
///
/// As ground overlay is automatically scaled to fit to the given [position],
/// [width] and [height], or [bounds], the bitmapScaling should be set to
/// [MapBitmapScaling.none], for [image] to avoid unnecessary scaling.
///
/// To create a ground overlay use either [GroundOverlay.fromBounds] or
/// [GroundOverlay.fromPosition] methods.
///
/// Example of creating a ground overlay from an asset using
/// [GroundOverlay.fromBounds] method:
///
/// ```dart
/// GroundOverlay.bounds(
///   groundOverlayId: const GroundOverlayId('overlay_id'),
///   image: await AssetMapBitmap.create(
///     createLocalImageConfiguration(context),
///     'assets/red_square.png',
///     bitmapScaling: MapBitmapScaling.none,
///   ),
///   bounds: LatLngBounds(
///     southwest: LatLng(37.42, -122.08),
///     northeast: LatLng(37.43, -122.09),
///   ),
/// );
/// ```
///
/// Example of creating a ground overlay from an asset using
/// [GroundOverlay.fromPosition] method:
/// ```dart
/// GroundOverlay.position(
///   groundOverlayId: const GroundOverlayId('overlay_id'),
///   image: await AssetMapBitmap.create(
///     createLocalImageConfiguration(context),
///     'assets/red_square.png',
///     bitmapScaling: MapBitmapScaling.none,
///   ),
///   position: LatLng(37.42, -122.08),
///   width: 100,
///   height: 100,
/// );
/// ```
@immutable
class GroundOverlay implements MapsObject<GroundOverlay> {
  /// Creates an immutable representation of a [GroundOverlay] to
  /// draw on [GoogleMap].
  const GroundOverlay._({
    required this.groundOverlayId,
    required this.image,
    this.position,
    this.bounds,
    this.width,
    this.height,
    this.anchor,
    this.transparency = 0.0,
    this.bearing = 0.0,
    this.zIndex = 0.0,
    this.visible = true,
    this.clickable = true,
    this.onTap,
  })  : assert(transparency >= 0.0 && transparency <= 1.0),
        assert(bearing >= 0.0 && bearing <= 360.0),
        assert((position == null) != (bounds == null),
            'Either position or bounds must be given, but not both'),
        assert(position == null || (width != null && width > 0),
            'Width must be specified and mut be greater than 0 when position is used'),
        assert(position == null || (height == null || height > 0),
            'Height must be null or greater than 0 when position is used');

  /// Creates a [GroundOverlay] to given [bounds] with the given [image].
  ///
  /// Example of creating a ground overlay from an asset using
  /// [GroundOverlay.fromBounds] method:
  ///
  /// ```dart
  /// GroundOverlay.bounds(
  ///   groundOverlayId: const GroundOverlayId('overlay_id'),
  ///   image: await AssetMapBitmap.create(
  ///     createLocalImageConfiguration(context),
  ///     'assets/red_square.png',
  ///     bitmapScaling: MapBitmapScaling.none,
  ///   ),
  ///   bounds: LatLngBounds(
  ///     southwest: LatLng(37.42, -122.08),
  ///     northeast: LatLng(37.43, -122.09),
  ///   ),
  /// );
  factory GroundOverlay.fromBounds({
    required GroundOverlayId groundOverlayId,
    required BitmapDescriptor image,
    required LatLngBounds bounds,
    double bearing = 0.0,
    double transparency = 0.0,
    double zIndex = 0.0,
    bool visible = true,
    bool clickable = true,
    VoidCallback? onTap,
  }) {
    return GroundOverlay._(
      groundOverlayId: groundOverlayId,
      image: image,
      bounds: bounds,
      bearing: bearing,
      transparency: transparency,
      zIndex: zIndex,
      visible: visible,
      clickable: clickable,
      onTap: onTap,
    );
  }

  /// Creates a [GroundOverlay] to given [position] with the given [image].
  ///
  /// Example of creating a ground overlay from an asset using
  /// [GroundOverlay.fromPosition] method:
  /// ```dart
  /// GroundOverlay.position(
  ///   groundOverlayId: const GroundOverlayId('overlay_id'),
  ///   image: await AssetMapBitmap.create(
  ///     createLocalImageConfiguration(context),
  ///     'assets/red_square.png',
  ///     bitmapScaling: MapBitmapScaling.none,
  ///   ),
  ///   position: LatLng(37.42, -122.08),
  ///   width: 100,
  ///   height: 100,
  /// );
  /// ```
  factory GroundOverlay.fromPosition({
    required GroundOverlayId groundOverlayId,
    required BitmapDescriptor image,
    required LatLng position,
    required double width,
    double? height,
    Offset anchor = const Offset(0.5, 0.5),
    double bearing = 0.0,
    double transparency = 0.0,
    double zIndex = 0.0,
    bool visible = true,
    bool clickable = true,
    VoidCallback? onTap,
  }) {
    return GroundOverlay._(
      groundOverlayId: groundOverlayId,
      image: image,
      position: position,
      width: width,
      height: height,
      anchor: anchor,
      bearing: bearing,
      transparency: transparency,
      zIndex: zIndex,
      visible: visible,
      clickable: clickable,
      onTap: onTap,
    );
  }

  /// Uniquely identifies a [GroundOverlay].
  final GroundOverlayId groundOverlayId;

  @override
  GroundOverlayId get mapsId => groundOverlayId;

  /// A description of the bitmap used to draw the ground overlay.
  ///
  /// To create ground overlay from assets, use [AssetMapBitmap],
  /// [AssetMapBitmap.create] or [BitmapDescriptor.asset].
  ///
  /// To create ground overlay from raw PNG data use [BytesMapBitmap]
  /// or [BitmapDescriptor.bytes].
  final BitmapDescriptor image;

  /// Geographical location to which the anchor will be fixed and the [width] of
  /// the overlay (in meters). The [anchor] is, by default, 50% from the top of
  /// the image and 50% from the left of the image. This can be changed by
  /// with the [anchor] parameter.
  /// You can optionally provide the [height] of the overlay (in meters).
  /// If you do not provide the [height] of the overlay, it will be
  /// automatically calculated to preserve the proportions of the image.
  /// If [position] is specified, [bounds] must be null.
  final LatLng? position;

  /// Width of the ground overlay (in meters).
  final double? width;

  /// Height of the ground overlay (in meters).
  final double? height;

  /// Bounds which will contain the image.
  /// If [bounds] is specified, [position] must be null.
  final LatLngBounds? bounds;

  /// The icon image point that will be placed at the [position] of the marker.
  ///
  /// The image point is specified in normalized coordinates: An anchor of
  /// (0.0, 0.0) means the top left corner of the image. An anchor
  /// of (1.0, 1.0) means the bottom right corner of the image.
  final Offset? anchor;

  /// The amount that the image should be rotated in a clockwise direction. The
  /// center of the rotation will be the image's anchor.
  /// The default bearing is 0, i.e., the image is aligned so that up is north.
  final double bearing;

  /// The transparency of the ground overlay. The default transparency is 0 (opaque).
  final double transparency;

  /// The tile overlay's zIndex, i.e., the order in which it will be drawn where
  /// overlays with larger values are drawn above those with lower values
  final double zIndex;

  /// The visibility for the tile overlay. The default visibility is true.
  final bool visible;

  /// Controls if click events are handled for this ground overlay.
  /// Default is true.
  final bool clickable;

  /// Callbacks to receive tap events for ground overlay placed on this map.
  final VoidCallback? onTap;

  /// Converts this object to something serializable in JSON.
  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('groundOverlayId', groundOverlayId.value);
    addIfPresent('image', image.toJson());
    addIfPresent('position', position?.toJson());
    addIfPresent('bounds', bounds?.toJson());
    addIfPresent('width', width);
    addIfPresent('height', height);
    addIfPresent(
        'anchor', anchor != null ? <Object>[anchor!.dx, anchor!.dy] : null);
    addIfPresent('bearing', bearing);
    addIfPresent('transparency', transparency);
    addIfPresent('zIndex', zIndex);
    addIfPresent('visible', visible);
    addIfPresent('clickable', clickable);

    return json;
  }

  /// Creates a new [GroundOverlay] object whose values are the same as this
  /// instance, unless overwritten by the specified parameters.
  GroundOverlay copyWith({
    BitmapDescriptor? imageParam,
    double? bearingParam,
    double? transparencyParam,
    double? zIndexParam,
    bool? visibleParam,
    bool? clickableParam,
    VoidCallback? onTapParam,
  }) {
    return GroundOverlay._(
      groundOverlayId: groundOverlayId,
      image: imageParam ?? image,
      bearing: bearingParam ?? bearing,
      transparency: transparencyParam ?? transparency,
      zIndex: zIndexParam ?? zIndex,
      visible: visibleParam ?? visible,
      clickable: clickableParam ?? clickable,
      onTap: onTapParam ?? onTap,
      position: position,
      bounds: bounds,
      width: width,
      height: height,
      anchor: anchor,
    );
  }

  @override
  GroundOverlay clone() => copyWith();

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GroundOverlay &&
        groundOverlayId == other.groundOverlayId &&
        image == other.image &&
        position == other.position &&
        bounds == other.bounds &&
        width == other.width &&
        height == other.height &&
        anchor == other.anchor &&
        bearing == other.bearing &&
        transparency == other.transparency &&
        zIndex == other.zIndex &&
        visible == other.visible &&
        clickable == other.clickable;
  }

  @override
  int get hashCode => Object.hash(groundOverlayId, image, position, bounds,
      width, height, anchor, bearing, transparency, zIndex, visible, clickable);
}