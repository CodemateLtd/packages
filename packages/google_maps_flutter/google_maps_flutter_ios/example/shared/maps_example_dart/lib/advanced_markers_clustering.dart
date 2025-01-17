// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'clustering.dart';
import 'page.dart';

/// Page for demonstrating advanced marker clustering support.
/// Same as [ClusteringPage] but works with [AdvancedMarker].
class AdvancedMarkersClusteringPage extends GoogleMapExampleAppPage {
  /// Default constructor.
  const AdvancedMarkersClusteringPage({Key? key, required this.mapId})
      : super(
          key: key,
          const Icon(Icons.place_outlined),
          'Manage clusters of advanced markers',
        );

  /// Map ID to use for the GoogleMap.
  final String? mapId;

  @override
  Widget build(BuildContext context) {
    return _AdvancedMarkerClusteringBody(mapId: mapId);
  }
}

/// Same as [ClusteringBody] but works with [AdvancedMarker].
class _AdvancedMarkerClusteringBody extends ClusteringBody {
  const _AdvancedMarkerClusteringBody({required super.mapId});

  @override
  Marker createMarker({
    required MarkerId markerId,
    required ClusterManagerId clusterManagerId,
    required LatLng position,
    required InfoWindow infoWindow,
    required VoidCallback onTap,
  }) {
    return AdvancedMarker(
      markerId: markerId,
      clusterManagerId: clusterManagerId,
      position: position,
      infoWindow: infoWindow,
      onTap: onTap,
      icon: BitmapDescriptor.pinConfig(
        backgroundColor: Colors.white,
        borderColor: Colors.blue,
        glyph: const CircleGlyph(color: Colors.blue),
      ),
    );
  }

  @override
  Marker copyWithSelectedState(Marker marker, bool isSelected) {
    assert(marker is AdvancedMarker);
    return (marker as AdvancedMarker).copyWith(
      iconParam: isSelected
          ? BitmapDescriptor.pinConfig(
              backgroundColor: Colors.blue,
              borderColor: Colors.white,
              glyph: const CircleGlyph(color: Colors.white),
            )
          : BitmapDescriptor.pinConfig(
              backgroundColor: Colors.white,
              borderColor: Colors.blue,
              glyph: const CircleGlyph(color: Colors.blue),
            ),
    );
  }
}
