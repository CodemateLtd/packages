// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FGMGroundOverlayController.h"
#import "FLTGoogleMapJSONConversions.h"
#import "FGMUtils.h"

@interface FGMGroundOverlayController ()

/// The ground overlay this controller handles.
@property(strong, nonatomic) GMSGroundOverlay *groundOverlay;

/// The GMSMapView to which the ground overlays are added.
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FGMGroundOverlayController

- (instancetype)initWithGroundOverlay:(GMSGroundOverlay *)groundOverlay
                           identifier:(NSString *)identifier
                              mapView:(GMSMapView *)mapView {
  self = [super init];
  if (self) {
    _groundOverlay = groundOverlay;
    _mapView = mapView;
    _groundOverlay.userData = @[ identifier ];
  }
  return self;
}

- (void)removeGroundOverlay {
  self.groundOverlay.map = nil;
}

- (void)setConsumeTapEvents:(BOOL)consumes {
  self.groundOverlay.tappable = consumes;
}

- (void)setVisible:(BOOL)visible {
  self.groundOverlay.map = visible ? self.mapView : nil;
}

- (void)setZIndex:(int)zIndex {
  self.groundOverlay.zIndex = zIndex;
}

- (void)setAnchor:(CGPoint)anchor {
  self.groundOverlay.anchor = anchor;
}

- (void)setBearing:(CLLocationDirection)bearing {
  self.groundOverlay.bearing = bearing;
}

- (void)setTransparency:(float)transparency {
  float opacity = 1.0 - transparency;
  self.groundOverlay.opacity = opacity;
}

- (void)setPositionFromBounds:(GMSCoordinateBounds *)bounds {
  self.groundOverlay.bounds = bounds;
}

- (void)setPositionFromCoordinates:(CLLocationCoordinate2D)coordinates {
  self.groundOverlay.position = coordinates;
}

- (void)setIcon:(UIImage *)icon {
  self.groundOverlay.icon = icon;
}

- (void)updateFromPlatformGroundOverlay:(FGMPlatformGroundOverlay *)groundOverlay
                        registrar:(NSObject<FlutterPluginRegistrar> *)registrar
                            screenScale:(CGFloat)screenScale {
  [self setConsumeTapEvents:groundOverlay.clickable];
  [self setVisible:groundOverlay.visible];
  [self setZIndex:(int)groundOverlay.zIndex];
  [self setAnchor:CGPointMake(groundOverlay.anchor.x, groundOverlay.anchor.y)];
  UIImage *image = [FGMUtils iconFromBitmap:groundOverlay.image
                              registrar:registrar
                            screenScale:screenScale];
  [self setIcon:image];
  [self setBearing:groundOverlay.bearing];
  [self setTransparency:groundOverlay.transparency];
  if (groundOverlay.position == nil) {
    [self setPositionFromBounds:[[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(groundOverlay.bounds.northeast.latitude, groundOverlay.bounds.northeast.longitude) coordinate:CLLocationCoordinate2DMake(groundOverlay.bounds.southwest.latitude, groundOverlay.bounds.southwest.longitude)]];
  } else {
    [self setPositionFromCoordinates:CLLocationCoordinate2DMake(groundOverlay.position.latitude, groundOverlay.position.longitude)];
  }
}

@end

@interface FLTGroundOverlaysController ()

/// A map from ground overlay id to the controller that manages it.
@property(strong, nonatomic) NSMutableDictionary<NSString *, FGMGroundOverlayController *> *groundOverlayIdentifierToController;

/// A callback api for the map interactions.
@property(strong, nonatomic) FGMMapsCallbackApi *callbackHandler;

/// Flutter Plugin Registrar used to load images.
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;

/// The map view used to generate the controllers.
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGroundOverlaysController

- (instancetype)initWithMapView:(GMSMapView *)mapView
                callbackHandler:(FGMMapsCallbackApi *)callbackHandler
                      registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  if (self) {
    _callbackHandler = callbackHandler;
    _mapView = mapView;
    _groundOverlayIdentifierToController = [[NSMutableDictionary alloc] init];
    _registrar = registrar;
  }
  return self;
}

- (void)addGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToAdd {
  for (FGMPlatformGroundOverlay *groundOverlay in groundOverlaysToAdd) {
    NSString *identifier = groundOverlay.groundOverlayId;
    GMSGroundOverlay *gmsOverlay;
    if (groundOverlay.position == nil) {
      NSAssert(groundOverlay.bounds != nil, @"If ground overlay is initialized without position, bounds are required");
      gmsOverlay = [GMSGroundOverlay groundOverlayWithBounds:
                     [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(groundOverlay.bounds.northeast.latitude, groundOverlay.bounds.northeast.longitude) coordinate:CLLocationCoordinate2DMake(groundOverlay.bounds.southwest.latitude, groundOverlay.bounds.southwest.longitude)]
                  icon: [FGMUtils iconFromBitmap:groundOverlay.image
                                                                  registrar:self.registrar
                                                                             screenScale:[self getScreenScale]]];
    } else {
      NSAssert(groundOverlay.zoomLevel != nil, @"If ground overlay is initialized with position, zoomLevel is required");
      gmsOverlay = [GMSGroundOverlay
                                      groundOverlayWithPosition:CLLocationCoordinate2DMake(groundOverlay.position.latitude, groundOverlay.position.longitude)
                                      icon:[FGMUtils iconFromBitmap:groundOverlay.image
                                                                registrar:self.registrar
                                                              screenScale:[self getScreenScale]]
                    zoomLevel:[groundOverlay.zoomLevel doubleValue]];
    }
    FGMGroundOverlayController *controller = [[FGMGroundOverlayController alloc] initWithGroundOverlay:gmsOverlay identifier:identifier mapView:self.mapView];
    [controller updateFromPlatformGroundOverlay:groundOverlay registrar:self.registrar screenScale:[self getScreenScale]];
    self.groundOverlayIdentifierToController[identifier] = controller;
  }
}

- (void)changeGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToChange {
  for (FGMPlatformGroundOverlay *groundOverlay in groundOverlaysToChange) {
    NSString *identifier = groundOverlay.groundOverlayId;
    FGMGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
    [controller updateFromPlatformGroundOverlay:groundOverlay registrar:self.registrar screenScale:[self getScreenScale]];
  }
}

- (void)removeGroundOverlaysWithIdentifiers:(NSArray<NSString *> *)identifiers {
  for (NSString *identifier in identifiers) {
    FGMGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
    if (!controller) {
      continue;
    }
    [controller removeGroundOverlay];
    [self.groundOverlayIdentifierToController removeObjectForKey:identifier];
  }
}

- (void)didTapGroundOverlayWithIdentifier:(NSString *)identifier {
  if (!identifier) {
    return;
  }
  FGMGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
  if (!controller) {
    return;
  }
  [self.callbackHandler didTapGroundOverlayWithIdentifier:identifier
                                         completion:^(FlutterError *_Nullable _){
  }];
}

- (bool)hasGroundOverlaysWithIdentifier:(NSString *)identifier {
  if (!identifier) {
    return false;
  }
  return self.groundOverlayIdentifierToController[identifier] != nil;
}

- (CGFloat)getScreenScale {
  // TODO(jokerttu): This method is called on marker creation, which, for initial markers, is done
  // before the view is added to the view hierarchy. This means that the traitCollection values may
  // not be matching the right display where the map is finally shown. The solution should be
  // revisited after the proper way to fetch the display scale is resolved for platform views. This
  // should be done under the context of the following issue:
  // https://github.com/flutter/flutter/issues/125496.
  return self.mapView.traitCollection.displayScale;
}

@end