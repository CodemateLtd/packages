// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

#import "messages.g.h"

// Defines ground overlay controllable by Flutter.
@interface FLTGoogleMapGroundOverlayController : NSObject
- (instancetype)initWithGroundOverlay:(GMSGroundOverlay *)groundOverlay
                        identifier:(NSString *)identifier
                        mapView:(GMSMapView *)mapView;
- (void)removeGroundOverlay;
@end

@interface FLTGroundOverlaysController : NSObject
- (instancetype)initWithMapView:(GMSMapView *)mapView
                callbackHandler:(FGMMapsCallbackApi *)callbackHandler
                      registrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (void)addGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToAdd;
- (void)changeGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToChange;
- (void)removeGroundOverlaysWithIdentifiers:(NSArray<NSString *> *)identifiers;
- (void)didTapGroundOverlayWithIdentifier:(NSString *)identifier;
- (bool)hasGroundOverlaysWithIdentifier:(NSString *)identifier;
@end
