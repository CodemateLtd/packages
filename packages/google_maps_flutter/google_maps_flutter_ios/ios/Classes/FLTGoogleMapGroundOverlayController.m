// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTGoogleMapGroundOverlayController.h"
#import "FLTGoogleMapJSONConversions.h"

@interface FLTGoogleMapGroundOverlayController ()

@property(strong, nonatomic) GMSGroundOverlay *groundOverlay;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGoogleMapGroundOverlayController

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

- (void)setIcon:(UIImage *)icon {
  self.groundOverlay.icon = icon;
}

- (void)updateFromPlatformGroundOverlay:(FGMPlatformGroundOverlay *)groundOverlay
                        registrar:(NSObject<FlutterPluginRegistrar> *)registrar
                            screenScale:(CGFloat)screenScale{
  NSAssert(groundOverlay.position == nil, @"Ground overlay position is not supported on iOS");
  [self setConsumeTapEvents:groundOverlay.clickable];
  [self setVisible:groundOverlay.visible];
  [self setZIndex:(int)groundOverlay.zIndex];
  [self setAnchor:CGPointMake(groundOverlay.anchor.x, groundOverlay.anchor.y)];
  UIImage *image = [self iconFromBitmap:groundOverlay.image
                              registrar:registrar
                            screenScale:screenScale];
  [self setIcon:image];
  [self setBearing:groundOverlay.bearing];
  [self setTransparency:groundOverlay.transparency];
  [self setPositionFromBounds:[[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(groundOverlay.bounds.northeast.latitude, groundOverlay.bounds.northeast.longitude) coordinate:CLLocationCoordinate2DMake(groundOverlay.bounds.southwest.latitude, groundOverlay.bounds.southwest.longitude)]];
}

- (UIImage *)iconFromBitmap:(FGMPlatformBitmap *)platformBitmap
                  registrar:(NSObject<FlutterPluginRegistrar> *)registrar
                screenScale:(CGFloat)screenScale {
  NSAssert(screenScale > 0, @"Screen scale must be greater than 0");
  // See comment in messages.dart for why this is so loosely typed. See also
  // https://github.com/flutter/flutter/issues/117819.
  id bitmap = platformBitmap.bitmap;
  UIImage *image;
  if ([bitmap isKindOfClass:[FGMPlatformBitmapDefaultMarker class]]) {
    FGMPlatformBitmapDefaultMarker *bitmapDefaultMarker = bitmap;
    CGFloat hue = bitmapDefaultMarker.hue.doubleValue;
    image = [GMSMarker markerImageWithColor:[UIColor colorWithHue:hue / 360.0
                                                       saturation:1.0
                                                       brightness:0.7
                                                            alpha:1.0]];
  } else if ([bitmap isKindOfClass:[FGMPlatformBitmapAsset class]]) {
    // Deprecated: This message handling for 'fromAsset' has been replaced by 'asset'.
    // Refer to the flutter google_maps_flutter_platform_interface package for details.
    FGMPlatformBitmapAsset *bitmapAsset = bitmap;
    if (bitmapAsset.pkg) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:bitmapAsset.name
                                                   fromPackage:bitmapAsset.pkg]];
    } else {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:bitmapAsset.name]];
    }
  } else if ([bitmap isKindOfClass:[FGMPlatformBitmapAssetImage class]]) {
    // Deprecated: This message handling for 'fromAssetImage' has been replaced by 'asset'.
    // Refer to the flutter google_maps_flutter_platform_interface package for details.
    FGMPlatformBitmapAssetImage *bitmapAssetImage = bitmap;
    image = [UIImage imageNamed:[registrar lookupKeyForAsset:bitmapAssetImage.name]];
    image = [self scaleImage:image by:bitmapAssetImage.scale];
  } else if ([bitmap isKindOfClass:[FGMPlatformBitmapBytes class]]) {
    // Deprecated: This message handling for 'fromBytes' has been replaced by 'bytes'.
    // Refer to the flutter google_maps_flutter_platform_interface package for details.
    FGMPlatformBitmapBytes *bitmapBytes = bitmap;
    @try {
      CGFloat mainScreenScale = [[UIScreen mainScreen] scale];
      image = [UIImage imageWithData:bitmapBytes.byteData.data scale:mainScreenScale];
    } @catch (NSException *exception) {
      @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                     reason:@"Unable to interpret bytes as a valid image."
                                   userInfo:nil];
    }
  } else if ([bitmap isKindOfClass:[FGMPlatformBitmapAssetMap class]]) {
    FGMPlatformBitmapAssetMap *bitmapAssetMap = bitmap;

    image = [UIImage imageNamed:[registrar lookupKeyForAsset:bitmapAssetMap.assetName]];

    if (bitmapAssetMap.bitmapScaling == FGMPlatformMapBitmapScalingAuto) {
      NSNumber *width = bitmapAssetMap.width;
      NSNumber *height = bitmapAssetMap.height;
      if (width || height) {
        image = [FLTGoogleMapGroundOverlayController scaledImage:image withScale:screenScale];
        image = [FLTGoogleMapGroundOverlayController scaledImage:image
                                                withWidth:width
                                                   height:height
                                              screenScale:screenScale];
      } else {
        image = [FLTGoogleMapGroundOverlayController scaledImage:image
                                                withScale:bitmapAssetMap.imagePixelRatio];
      }
    }
  } else if ([bitmap isKindOfClass:[FGMPlatformBitmapBytesMap class]]) {
    FGMPlatformBitmapBytesMap *bitmapBytesMap = bitmap;
    FlutterStandardTypedData *bytes = bitmapBytesMap.byteData;

    @try {
      image = [UIImage imageWithData:bytes.data scale:screenScale];
      if (bitmapBytesMap.bitmapScaling == FGMPlatformMapBitmapScalingAuto) {
        NSNumber *width = bitmapBytesMap.width;
        NSNumber *height = bitmapBytesMap.height;

        if (width || height) {
          // Before scaling the image, image must be in screenScale.
          image = [FLTGoogleMapGroundOverlayController scaledImage:image withScale:screenScale];
          image = [FLTGoogleMapGroundOverlayController scaledImage:image
                                                  withWidth:width
                                                     height:height
                                                screenScale:screenScale];
        } else {
          image = [FLTGoogleMapGroundOverlayController scaledImage:image
                                                  withScale:bitmapBytesMap.imagePixelRatio];
        }
      } else {
        // No scaling, load image from bytes without scale parameter.
        image = [UIImage imageWithData:bytes.data];
      }
    } @catch (NSException *exception) {
      @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                     reason:@"Unable to interpret bytes as a valid image."
                                   userInfo:nil];
    }
  }

  return image;
}

/// This method is deprecated within the context of `BitmapDescriptor.fromBytes` handling in the
/// flutter google_maps_flutter_platform_interface package which has been replaced by 'bytes'
/// message handling. It will be removed when the deprecated image bitmap description type
/// 'fromBytes' is removed from the platform interface.
- (UIImage *)scaleImage:(UIImage *)image by:(double)scale {
  if (fabs(scale - 1) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
  }
  return image;
}

/// Creates a scaled version of the provided UIImage based on a specified scale factor. If the
/// scale factor differs from the image's current scale by more than a small epsilon-delta (to
/// account for minor floating-point inaccuracies), a new UIImage object is created with the
/// specified scale. Otherwise, the original image is returned.
///
/// @param image The UIImage to scale.
/// @param scale The factor by which to scale the image.
/// @return UIImage Returns the scaled UIImage.
+ (UIImage *)scaledImage:(UIImage *)image withScale:(CGFloat)scale {
  if (fabs(scale - image.scale) > DBL_EPSILON) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:scale
                         orientation:(image.imageOrientation)];
  }
  return image;
}

/// Scales an input UIImage to a specified size. If the aspect ratio of the input image
/// closely matches the target size, indicated by a small epsilon-delta, the image's scale
/// property is updated instead of resizing the image. If the aspect ratios differ beyond this
/// threshold, the method redraws the image at the target size.
///
/// @param image The UIImage to scale.
/// @param size The target CGSize to scale the image to.
/// @return UIImage Returns the scaled UIImage.
+ (UIImage *)scaledImage:(UIImage *)image withSize:(CGSize)size {
  CGFloat originalPixelWidth = image.size.width * image.scale;
  CGFloat originalPixelHeight = image.size.height * image.scale;

  // Return original image if either original image size or target size is so small that
  // image cannot be resized or displayed.
  if (originalPixelWidth <= 0 || originalPixelHeight <= 0 || size.width <= 0 || size.height <= 0) {
    return image;
  }

  // Check if the image's size, accounting for scale, matches the target size.
  if (fabs(originalPixelWidth - size.width) <= DBL_EPSILON &&
      fabs(originalPixelHeight - size.height) <= DBL_EPSILON) {
    // No need for resizing, return the original image
    return image;
  }

  // Check if the aspect ratios are approximately equal.
  CGSize originalPixelSize = CGSizeMake(originalPixelWidth, originalPixelHeight);
  if ([FLTGoogleMapGroundOverlayController isScalableWithScaleFactorFromSize:originalPixelSize
                                                               toSize:size]) {
    // Scaled image has close to same aspect ratio,
    // updating image scale instead of resizing image.
    CGFloat factor = originalPixelWidth / size.width;
    return [FLTGoogleMapGroundOverlayController scaledImage:image withScale:(image.scale * factor)];
  } else {
    // Aspect ratios differ significantly, resize the image.
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
    format.scale = 1.0;
    format.opaque = NO;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size
                                                                               format:format];
    UIImage *newImage =
    [renderer imageWithActions:^(UIGraphicsImageRendererContext *_Nonnull context) {
      [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];

    // Return image with proper scaling.
    return [FLTGoogleMapGroundOverlayController scaledImage:newImage withScale:image.scale];
  }
}

/// Scales an input UIImage to a specified width and height preserving aspect ratio if both
/// widht and height are not given..
///
/// @param image The UIImage to scale.
/// @param width The target width to scale the image to.
/// @param height The target height to scale the image to.
/// @param screenScale The current screen scale.
/// @return UIImage Returns the scaled UIImage.
+ (UIImage *)scaledImage:(UIImage *)image
               withWidth:(NSNumber *)width
                  height:(NSNumber *)height
             screenScale:(CGFloat)screenScale {
  if (!width && !height) {
    return image;
  }

  CGFloat targetWidth = width ? width.doubleValue : image.size.width;
  CGFloat targetHeight = height ? height.doubleValue : image.size.height;

  if (width && !height) {
    // Calculate height based on aspect ratio if only width is provided.
    double aspectRatio = image.size.height / image.size.width;
    targetHeight = round(targetWidth * aspectRatio);
  } else if (!width && height) {
    // Calculate width based on aspect ratio if only height is provided.
    double aspectRatio = image.size.width / image.size.height;
    targetWidth = round(targetHeight * aspectRatio);
  }

  CGSize targetSize =
  CGSizeMake(round(targetWidth * screenScale), round(targetHeight * screenScale));
  return [FLTGoogleMapGroundOverlayController scaledImage:image withSize:targetSize];
}

+ (BOOL)isScalableWithScaleFactorFromSize:(CGSize)originalSize toSize:(CGSize)targetSize {
  // Select the scaling factor based on the longer side to have good precision.
  CGFloat scaleFactor = (originalSize.width > originalSize.height)
  ? (targetSize.width / originalSize.width)
  : (targetSize.height / originalSize.height);

  // Calculate the scaled dimensions.
  CGFloat scaledWidth = originalSize.width * scaleFactor;
  CGFloat scaledHeight = originalSize.height * scaleFactor;

  // Check if the scaled dimensions are within a one-pixel
  // threshold of the target dimensions.
  BOOL widthWithinThreshold = fabs(scaledWidth - targetSize.width) <= 1.0;
  BOOL heightWithinThreshold = fabs(scaledHeight - targetSize.height) <= 1.0;

  // The image is considered scalable with scale factor
  // if both dimensions are within the threshold.
  return widthWithinThreshold && heightWithinThreshold;
}

@end

@interface FLTGroundOverlaysController ()
@property(strong, nonatomic) NSMutableDictionary<NSString *, FLTGoogleMapGroundOverlayController *> *groundOverlayIdentifierToController;
@property(strong, nonatomic) FGMMapsCallbackApi *callbackHandler;
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;
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
    GMSGroundOverlay *gmsOverlay = [[GMSGroundOverlay alloc] init];
    FLTGoogleMapGroundOverlayController *controller = [[FLTGoogleMapGroundOverlayController alloc] initWithGroundOverlay:gmsOverlay identifier:identifier mapView:self.mapView];
    [controller updateFromPlatformGroundOverlay:groundOverlay registrar:self.registrar screenScale:[self getScreenScale]];
    self.groundOverlayIdentifierToController[identifier] = controller;
  }
}

- (void)changeGroundOverlays:(NSArray<FGMPlatformGroundOverlay *> *)groundOverlaysToChange {
  for (FGMPlatformGroundOverlay *groundOverlay in groundOverlaysToChange) {
    NSString *identifier = groundOverlay.groundOverlayId;
    FLTGoogleMapGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
    [controller updateFromPlatformGroundOverlay:groundOverlay registrar:self.registrar screenScale:[self getScreenScale]];
  }
}

- (void)removeGroundOverlaysWithIdentifiers:(NSArray<NSString *> *)identifiers {
  for (NSString *identifier in identifiers) {
    FLTGoogleMapGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
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
  FLTGoogleMapGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
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
