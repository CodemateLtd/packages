// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show Offset;
import 'package:flutter/foundation.dart';

import '../../google_maps_flutter_platform_interface.dart';

/// Marks a geographical location on the map.
///
/// Extends [Marker] and provides additional features.
@immutable
class AdvancedMarker extends Marker {
  /// Creates a set of marker configuration options.
  ///
  /// Specifies a marker with a given [collisionBehavior]. Default is
  /// [MarkerCollisionBehavior.required].
  const AdvancedMarker({
    required super.markerId,
    super.alpha,
    super.anchor,
    super.consumeTapEvents,
    super.draggable,
    super.flat,
    super.icon,
    super.infoWindow,
    super.position,
    super.rotation,
    super.visible,
    super.zIndex,
    super.clusterManagerId,
    super.onTap,
    super.onDrag,
    super.onDragStart,
    super.onDragEnd,
    this.collisionBehavior = MarkerCollisionBehavior.required,
  });

  /// Indicates how the marker behaves when it collides with other markers.
  final MarkerCollisionBehavior collisionBehavior;

  /// Creates a new [AdvancedMarker] object whose values are the same as this
  /// instance, unless overwritten by the specified parameters.
  @override
  AdvancedMarker copyWith({
    double? alphaParam,
    Offset? anchorParam,
    bool? consumeTapEventsParam,
    bool? draggableParam,
    bool? flatParam,
    BitmapDescriptor? iconParam,
    InfoWindow? infoWindowParam,
    LatLng? positionParam,
    double? rotationParam,
    bool? visibleParam,
    double? zIndexParam,
    VoidCallback? onTapParam,
    ValueChanged<LatLng>? onDragStartParam,
    ValueChanged<LatLng>? onDragParam,
    ValueChanged<LatLng>? onDragEndParam,
    ClusterManagerId? clusterManagerIdParam,
    MarkerCollisionBehavior? collisionBehaviorParam,
    double? altitudeParam,
  }) {
    return AdvancedMarker(
      markerId: markerId,
      alpha: alphaParam ?? alpha,
      anchor: anchorParam ?? anchor,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      draggable: draggableParam ?? draggable,
      flat: flatParam ?? flat,
      icon: iconParam ?? icon,
      infoWindow: infoWindowParam ?? infoWindow,
      position: positionParam ?? position,
      rotation: rotationParam ?? rotation,
      visible: visibleParam ?? visible,
      zIndex: zIndexParam ?? zIndex,
      onTap: onTapParam ?? onTap,
      onDragStart: onDragStartParam ?? onDragStart,
      onDrag: onDragParam ?? onDrag,
      onDragEnd: onDragEndParam ?? onDragEnd,
      clusterManagerId: clusterManagerIdParam ?? clusterManagerId,
      collisionBehavior: collisionBehaviorParam ?? collisionBehavior,
    );
  }

  /// Converts this object to something serializable in JSON.
  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('markerId', markerId.value);
    addIfPresent('alpha', alpha);
    addIfPresent('anchor', offsetToJson(anchor));
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('draggable', draggable);
    addIfPresent('flat', flat);
    addIfPresent('icon', icon.toJson());
    addIfPresent('infoWindow', infoWindow.toJson());
    addIfPresent('position', position.toJson());
    addIfPresent('rotation', rotation);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    addIfPresent('clusterManagerId', clusterManagerId?.value);
    addIfPresent('collisionBehavior', collisionBehavior.index);
    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AdvancedMarker &&
        markerId == other.markerId &&
        alpha == other.alpha &&
        anchor == other.anchor &&
        consumeTapEvents == other.consumeTapEvents &&
        draggable == other.draggable &&
        flat == other.flat &&
        icon == other.icon &&
        infoWindow == other.infoWindow &&
        position == other.position &&
        rotation == other.rotation &&
        visible == other.visible &&
        zIndex == other.zIndex &&
        clusterManagerId == other.clusterManagerId &&
        collisionBehavior == other.collisionBehavior;
  }

  @override
  int get hashCode => markerId.hashCode;

  @override
  String toString() {
    return 'AdvancedMarker{markerId: $markerId, alpha: $alpha, anchor: $anchor, '
        'consumeTapEvents: $consumeTapEvents, draggable: $draggable, flat: $flat, '
        'icon: $icon, infoWindow: $infoWindow, position: $position, rotation: $rotation, '
        'visible: $visible, zIndex: $zIndex, onTap: $onTap, onDragStart: $onDragStart, '
        'onDrag: $onDrag, onDragEnd: $onDragEnd, clusterManagerId: $clusterManagerId, '
        'collisionBehavior: $collisionBehavior}';
  }
}

/// Indicates how the marker behaves when it collides with other markers.
enum MarkerCollisionBehavior {
  /// (default) Always display the marker regardless of collision.
  required,

  /// Display the marker only if it does not overlap with other markers.
  /// If two markers of this type would overlap, the one with the higher zIndex
  /// is shown. If they have the same zIndex, the one with the lower vertical
  /// screen position is shown.
  optionalAndHidesLowerPriority,

  /// Always display the marker regardless of collision, and hide any
  /// [optionalAndHidesLowerPriority] markers or labels that would overlap with
  /// the marker.
  requiredAndHidesOptional,
}
