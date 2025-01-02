// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

#import "messages.g.h"

/// Controller of a single ground overlay  on the map.
@interface FGMGroundOverlayController : NSObject

/// Initializes an instance of this class with a GMSGroundOverlay, a map view, and identifier.
- (instancetype)initWithGroundOverlay:(GMSGroundOverlay *)groundOverlay
                        identifier:(NSString *)identifier
                        mapView:(GMSMapView *)mapView;

/// Removes this ground overlay from the map.
- (void)removeGroundOverlay;
@end

/// Controller of multiple ground overlays on the map.
@interface FLTGroundOverlaysController : NSObject

/// Initializes the controller with a GMSMapView, callback handler and registrar.
- (instancetype)initWithMapView:(GMSMapView *)mapView
                callbackHandler:(FGMMapsCallbackApi *)callbackHandler
                      registrar:(NSObject<FlutterPluginRegistrar> *)registrar;

/// Adds ground overlays to the map.
- (void)addGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToAdd;

/// Updates ground overlays on the map.
- (void)changeGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToChange;

/// Removes ground overlays from the map.
- (void)removeGroundOverlaysWithIdentifiers:(NSArray<NSString *> *)identifiers;

/// Called when a ground overlay is tapped on the map.
- (void)didTapGroundOverlayWithIdentifier:(NSString *)identifier;

/// Returns true if a ground overlay with the given identifier exists on the map.
- (bool)hasGroundOverlaysWithIdentifier:(NSString *)identifier;
@end