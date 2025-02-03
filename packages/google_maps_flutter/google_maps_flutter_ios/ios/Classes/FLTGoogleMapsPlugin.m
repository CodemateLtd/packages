// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTGoogleMapsPlugin.h"

#pragma mark - GoogleMaps plugin implementation

@implementation FLTGoogleMapsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FGMImageRegistry *imageRegistry = [[FGMImageRegistry alloc] initWithRegistrar:registrar];
  SetUpFGMImageRegistryApi(registrar.messenger, imageRegistry);
  FLTGoogleMapFactory *googleMapFactory = [[FLTGoogleMapFactory alloc] initWithRegistrar:registrar
                                                                           imageRegistry:imageRegistry];
  [registrar registerViewFactory:googleMapFactory
                                withId:@"plugins.flutter.dev/google_maps_ios"
      gestureRecognizersBlockingPolicy:
          FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];
}

@end
