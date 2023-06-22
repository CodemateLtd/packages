// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "GoogleMapMarkerController.h"
#import "FLTGoogleMapJSONConversions.h"

@interface FLTGoogleMapMarkerController ()

@property(strong, nonatomic) GMSMarker *marker;
@property(weak, nonatomic) GMSMapView *mapView;
@property(assign, nonatomic, readwrite) BOOL consumeTapEvents;

@end

@implementation FLTGoogleMapMarkerController

- (instancetype)initMarkerWithPosition:(CLLocationCoordinate2D)position
                            identifier:(NSString *)identifier
                               mapView:(GMSMapView *)mapView {
  self = [super init];
  if (self) {
    _marker = [GMSMarker markerWithPosition:position];
    _mapView = mapView;
    _marker.userData = @[ identifier ];
  }
  return self;
}

- (void)showInfoWindow {
  self.mapView.selectedMarker = self.marker;
}

- (void)hideInfoWindow {
  if (self.mapView.selectedMarker == self.marker) {
    self.mapView.selectedMarker = nil;
  }
}

- (BOOL)isInfoWindowShown {
  return self.mapView.selectedMarker == self.marker;
}

- (void)removeMarker {
  self.marker.map = nil;
}

- (void)setAlpha:(float)alpha {
  self.marker.opacity = alpha;
}

- (void)setAnchor:(CGPoint)anchor {
  self.marker.groundAnchor = anchor;
}

- (void)setDraggable:(BOOL)draggable {
  self.marker.draggable = draggable;
}

- (void)setFlat:(BOOL)flat {
  self.marker.flat = flat;
}

- (void)setIcon:(UIImage *)icon {
  self.marker.icon = icon;
}

- (void)setInfoWindowAnchor:(CGPoint)anchor {
  self.marker.infoWindowAnchor = anchor;
}

- (void)setInfoWindowTitle:(NSString *)title snippet:(NSString *)snippet {
  self.marker.title = title;
  self.marker.snippet = snippet;
}

- (void)setPosition:(CLLocationCoordinate2D)position {
  self.marker.position = position;
}

- (void)setRotation:(CLLocationDegrees)rotation {
  self.marker.rotation = rotation;
}

- (void)setVisible:(BOOL)visible {
  self.marker.map = visible ? self.mapView : nil;
}

- (void)setZIndex:(int)zIndex {
  self.marker.zIndex = zIndex;
}

- (void)interpretMarkerOptions:(NSDictionary *)data
                     registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSNumber *alpha = data[@"alpha"];
  if (alpha && alpha != (id)[NSNull null]) {
    [self setAlpha:[alpha floatValue]];
  }
  NSArray *anchor = data[@"anchor"];
  if (anchor && anchor != (id)[NSNull null]) {
    [self setAnchor:[FLTGoogleMapJSONConversions pointFromArray:anchor]];
  }
  NSNumber *draggable = data[@"draggable"];
  if (draggable && draggable != (id)[NSNull null]) {
    [self setDraggable:[draggable boolValue]];
  }
  NSArray *icon = data[@"icon"];
  if (icon && icon != (id)[NSNull null]) {
    UIImage *image = [self extractIconFromData:icon registrar:registrar];
    [self setIcon:image];
  }
  NSNumber *flat = data[@"flat"];
  if (flat && flat != (id)[NSNull null]) {
    [self setFlat:[flat boolValue]];
  }
  NSNumber *consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents && consumeTapEvents != (id)[NSNull null]) {
    [self setConsumeTapEvents:[consumeTapEvents boolValue]];
  }
  [self interpretInfoWindow:data];
  NSArray *position = data[@"position"];
  if (position && position != (id)[NSNull null]) {
    [self setPosition:[FLTGoogleMapJSONConversions locationFromLatLong:position]];
  }
  NSNumber *rotation = data[@"rotation"];
  if (rotation && rotation != (id)[NSNull null]) {
    [self setRotation:[rotation doubleValue]];
  }
  NSNumber *visible = data[@"visible"];
  if (visible && visible != (id)[NSNull null]) {
    [self setVisible:[visible boolValue]];
  }
  NSNumber *zIndex = data[@"zIndex"];
  if (zIndex && zIndex != (id)[NSNull null]) {
    [self setZIndex:[zIndex intValue]];
  }
}

- (void)interpretInfoWindow:(NSDictionary *)data {
  NSDictionary *infoWindow = data[@"infoWindow"];
  if (infoWindow && infoWindow != (id)[NSNull null]) {
    NSString *title = infoWindow[@"title"];
    NSString *snippet = infoWindow[@"snippet"];
    if (title && title != (id)[NSNull null]) {
      [self setInfoWindowTitle:title snippet:snippet];
    }
    NSArray *infoWindowAnchor = infoWindow[@"infoWindowAnchor"];
    if (infoWindowAnchor && infoWindowAnchor != (id)[NSNull null]) {
      [self setInfoWindowAnchor:[FLTGoogleMapJSONConversions pointFromArray:infoWindowAnchor]];
    }
  }
}

- (UIImage *)extractIconFromData:(NSArray *)iconData
                       registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  UIImage *image;
  if ([iconData.firstObject isEqualToString:@"defaultMarker"]) {
    CGFloat hue = (iconData.count == 1) ? 0.0f : [iconData[1] doubleValue];
    image = [GMSMarker markerImageWithColor:[UIColor colorWithHue:hue / 360.0
                                                       saturation:1.0
                                                       brightness:0.7
                                                            alpha:1.0]];
  } else if ([iconData.firstObject isEqualToString:@"fromAssetImage"]) {
    NSAssert((iconData.count == 3), @"'fromAssetImage' should have exactly 3 arguments. Got: %lu",
             (unsigned long)iconData.count);
    image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
    id scaleParam = iconData[2];
    image = [self scaleImage:image by:scaleParam];
  } else if ([iconData[0] isEqualToString:@"fromBytes"]) {
    NSAssert(iconData.count == 2,
             @"'fromBytes' should have exactly 2 arguments, the bytes. Got: %lu",
             (unsigned long)iconData.count);
    @try {
      FlutterStandardTypedData *byteData = iconData[1];
      CGFloat screenScale = [[UIScreen mainScreen] scale];
      image = [UIImage imageWithData:[byteData data] scale:screenScale];
    } @catch (NSException *exception) {
      @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                     reason:@"Unable to interpret bytes as a valid image."
                                   userInfo:nil];
    }
  } else if ([iconData.firstObject isEqualToString:@"asset"]) {
    NSAssert((iconData.count > 2), @"'asset' should have at least 3 parameters. Got: %lu",
             (unsigned long)iconData.count);
    image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
    if ([iconData[2] isEqualToString:@"auto"]) {
      NSAssert((iconData.count == 4 || iconData.count == 5),

               @"'asset' with auto setting should have exactly 4 or 5 arguments. Got: %lu",
               (unsigned long)iconData.count);
      if (iconData.count == 4) {
        // Update proper scale information for image object.
        CGFloat imageScale = [iconData[3] doubleValue];
        image = [self scaleImage:image withScale:imageScale];
      } else if (iconData.count == 5) {
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        // Update proper scale information for image object.
        image = [self scaleImage:image withScale:screenScale];
        // Create resized image.
        CGSize size_param = [FLTGoogleMapJSONConversions sizeFromArray:iconData[4]];
        CGSize size = [self scaleSizeToInt:size_param withScale:screenScale];
        image = [self scaleImage:image toSize:size];
      }
    }

  } else if ([iconData[0] isEqualToString:@"bytes"]) {
    NSAssert((iconData.count > 2), @"'bytes' should have at least 3 parameters. Got: %lu",
             (unsigned long)iconData.count);
    @try {
      FlutterStandardTypedData *byteData = iconData[1];
      if ([iconData[2] isEqualToString:@"auto"]) {
        NSAssert((iconData.count == 4 || iconData.count == 5),

                 @"'bytes' with auto setting should have exactly 4 or 5 arguments, Got: %lu",
                 (unsigned long)iconData.count);
        if (iconData.count == 4) {
          CGFloat imageScale = [iconData[3] doubleValue];
          // Scale parameter given, use it as scale factor
          image = [UIImage imageWithData:[byteData data] scale:imageScale];
        } else if (iconData.count == 5) {
          CGFloat screenScale = [[UIScreen mainScreen] scale];
          // Size parameter is given, scale image to exact size.
          // Update proper scale information for image object.
          image = [UIImage imageWithData:[byteData data] scale:screenScale];
          // Create resized image.
          CGSize size_param = [FLTGoogleMapJSONConversions sizeFromArray:iconData[4]];
          CGSize size = [self scaleSizeToInt:size_param withScale:screenScale];
          image = [self scaleImage:image toSize:size];
        }
      } else {
        // No scaling, load image from bytes without scale parameter.
        image = [UIImage imageWithData:[byteData data]];
      }
    } @catch (NSException *exception) {
      @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                     reason:@"Unable to interpret bytes as a valid image."
                                   userInfo:nil];
    }
  }

  return image;
}

// Used by deprecated fromBytes functionality.
// Can be removed when deprecated image bitmap types are removed from platform interface.
- (UIImage *)scaleImage:(UIImage *)image by:(id)scaleParam {
  double scale = 1.0;
  if ([scaleParam isKindOfClass:[NSNumber class]]) {
    scale = [scaleParam doubleValue];
  }
  if (fabs(scale - 1) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
  }
  return image;
}

/**
 * Scales an input UIImage by a specified scale factor. If the scale factor is significantly different 
 * from the image's current scale, a new UIImage object is created with the specified scale. 
 * Otherwise, the original image is returned.
 * 
 * @param image The UIImage to scale.
 * @param scale The factor by which to scale the image.
 * @return UIImage Returns the scaled UIImage.
 */
- (UIImage *)scaleImage:(UIImage *)image withScale:(CGFloat)scale {
  if (fabs(scale - image.scale) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:scale
                         orientation:(image.imageOrientation)];
  }
  return image;
}

/**
 * Scales an input UIImage to a specified size. If the aspect ratio of the input image
 * is similar to the target size, the image's scale property is updated rather than resizing the
 * image. If the aspect ratios significantly differ, the method redraws the image at the target size.
 *
 * @param image The UIImage to scale.
 * @param size The target CGSize to scale the image to.
 * @return UIImage Returns the scaled UIImage.
 */
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
  if (fabs(((int)image.size.width * image.scale) - size.width) > 0 ||
      fabs(((int)image.size.height * image.scale) - size.height) > 0) {
    if (fabs(image.size.width / image.size.height - size.width / size.height) < 1e-2) {
      // Scaled image has close to same aspect ratio, updating image scale instead of resizing
      // image.
      return [self scaleImage:image
                        scale:(image.scale * (size.width / (image.size.width * image.scale)))];
    } else {
      UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
      [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
      UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      // Return image with proper scaling
      return [self scaleImage:newImage scale:image.scale];
    }
  }
  return image;
}

/**
 * Scales the input CGSize by a specified scale factor and truncates the floating point values to integers.
 *  
 * @param size The CGSize to scale.
 * @param scale The scale factor to apply to the width and height of the CGSize.
 * @return CGSize Returns the scaled CGSize with width and height as integers.
 */
- (CGSize)scaleSizeToInt:(CGSize)size withScale:(CGFloat)scale {
    return CGSizeMake((int)(size.width * scale), (int)(size.height * scale));
}

@end

@interface FLTMarkersController ()

@property(strong, nonatomic) NSMutableDictionary *markerIdentifierToController;
@property(strong, nonatomic) FlutterMethodChannel *methodChannel;
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTMarkersController

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel
                              mapView:(GMSMapView *)mapView
                            registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  if (self) {
    _methodChannel = methodChannel;
    _mapView = mapView;
    _markerIdentifierToController = [[NSMutableDictionary alloc] init];
    _registrar = registrar;
  }
  return self;
}

- (void)addMarkers:(NSArray *)markersToAdd {
  for (NSDictionary *marker in markersToAdd) {
    CLLocationCoordinate2D position = [FLTMarkersController getPosition:marker];
    NSString *identifier = marker[@"markerId"];
    FLTGoogleMapMarkerController *controller =
        [[FLTGoogleMapMarkerController alloc] initMarkerWithPosition:position
                                                          identifier:identifier
                                                             mapView:self.mapView];
    [controller interpretMarkerOptions:marker registrar:self.registrar];
    self.markerIdentifierToController[identifier] = controller;
  }
}

- (void)changeMarkers:(NSArray *)markersToChange {
  for (NSDictionary *marker in markersToChange) {
    NSString *identifier = marker[@"markerId"];
    FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
    if (!controller) {
      continue;
    }
    [controller interpretMarkerOptions:marker registrar:self.registrar];
  }
}

- (void)removeMarkersWithIdentifiers:(NSArray *)identifiers {
  for (NSString *identifier in identifiers) {
    FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
    if (!controller) {
      continue;
    }
    [controller removeMarker];
    [self.markerIdentifierToController removeObjectForKey:identifier];
  }
}

- (BOOL)didTapMarkerWithIdentifier:(NSString *)identifier {
  if (!identifier) {
    return NO;
  }
  FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
  if (!controller) {
    return NO;
  }
  [self.methodChannel invokeMethod:@"marker#onTap" arguments:@{@"markerId" : identifier}];
  return controller.consumeTapEvents;
}

- (void)didStartDraggingMarkerWithIdentifier:(NSString *)identifier
                                    location:(CLLocationCoordinate2D)location {
  if (!identifier) {
    return;
  }
  FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
  if (!controller) {
    return;
  }
  [self.methodChannel invokeMethod:@"marker#onDragStart"
                         arguments:@{
                           @"markerId" : identifier,
                           @"position" : [FLTGoogleMapJSONConversions arrayFromLocation:location]
                         }];
}

- (void)didDragMarkerWithIdentifier:(NSString *)identifier
                           location:(CLLocationCoordinate2D)location {
  if (!identifier) {
    return;
  }
  FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
  if (!controller) {
    return;
  }
  [self.methodChannel invokeMethod:@"marker#onDrag"
                         arguments:@{
                           @"markerId" : identifier,
                           @"position" : [FLTGoogleMapJSONConversions arrayFromLocation:location]
                         }];
}

- (void)didEndDraggingMarkerWithIdentifier:(NSString *)identifier
                                  location:(CLLocationCoordinate2D)location {
  FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
  if (!controller) {
    return;
  }
  [self.methodChannel invokeMethod:@"marker#onDragEnd"
                         arguments:@{
                           @"markerId" : identifier,
                           @"position" : [FLTGoogleMapJSONConversions arrayFromLocation:location]
                         }];
}

- (void)didTapInfoWindowOfMarkerWithIdentifier:(NSString *)identifier {
  if (identifier && self.markerIdentifierToController[identifier]) {
    [self.methodChannel invokeMethod:@"infoWindow#onTap" arguments:@{@"markerId" : identifier}];
  }
}

- (void)showMarkerInfoWindowWithIdentifier:(NSString *)identifier result:(FlutterResult)result {
  FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
  if (controller) {
    [controller showInfoWindow];
    result(nil);
  } else {
    result([FlutterError errorWithCode:@"Invalid markerId"
                               message:@"showInfoWindow called with invalid markerId"
                               details:nil]);
  }
}

- (void)hideMarkerInfoWindowWithIdentifier:(NSString *)identifier result:(FlutterResult)result {
  FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
  if (controller) {
    [controller hideInfoWindow];
    result(nil);
  } else {
    result([FlutterError errorWithCode:@"Invalid markerId"
                               message:@"hideInfoWindow called with invalid markerId"
                               details:nil]);
  }
}

- (void)isInfoWindowShownForMarkerWithIdentifier:(NSString *)identifier
                                          result:(FlutterResult)result {
  FLTGoogleMapMarkerController *controller = self.markerIdentifierToController[identifier];
  if (controller) {
    result(@([controller isInfoWindowShown]));
  } else {
    result([FlutterError errorWithCode:@"Invalid markerId"
                               message:@"isInfoWindowShown called with invalid markerId"
                               details:nil]);
  }
}

+ (CLLocationCoordinate2D)getPosition:(NSDictionary *)marker {
  NSArray *position = marker[@"position"];
  return [FLTGoogleMapJSONConversions locationFromLatLong:position];
}

@end
