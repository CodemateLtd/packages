// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMSMarker (Userdata)

/**
 * Sets MarkerId to GMSMarker UserData.
 *
 * @param markerIdentifier Identifier of the marker.
 */
- (void)setMarkerIdentifier:(NSString *)markerIdentifier;

/**
 * Sets MarkerId and ClusterManagerId to GMSMarker UserData.
 *
 * @param markerIdentifier Identifier of marker.
 * @param clusterManagerIdentifier Identifier of cluster manager.
 */
- (void)setMarkerIdentifier:(NSString *)markerIdentifier andClusterManagerIdentifier:(NSString *)clusterManagerIdentifier;

/**
 * Get MarkerIdentifier from GMSMarker UserData.
 *
 * @return NSString if found otherwise nil.
 */
- (NSString *)getMarkerIdentifier;

/**
 * Get ClusterManagerIdentifier from GMSMarker UserData.
 *
 * @return NSString if found otherwise nil.
 */
- (NSString *)getClusterManagerIdentifier;

@end

NS_ASSUME_NONNULL_END
