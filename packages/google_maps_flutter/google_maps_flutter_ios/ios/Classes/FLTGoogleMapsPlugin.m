// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTGoogleMapsPlugin.h"
#import "FGMConstants.h"

#pragma mark - GoogleMaps plugin implementation

@implementation FLTGoogleMapsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FLTGoogleMapFactory *googleMapFactory = [[FLTGoogleMapFactory alloc] initWithRegistrar:registrar];
    
    Class gmssClass = [GMSServices class];
    SEL internalUsageAttributionIDSelector = @selector(addInternalUsageAttributionID:);

    if ([gmssClass respondsToSelector:internalUsageAttributionIDSelector]) {
      NSString *attributionId = [NSString stringWithFormat:@"gmp_flutter_googlemapsflutter_v%s_ios", FGM_PLUGIN_VERSION];
      [GMSServices performSelector:internalUsageAttributionIDSelector withObject:attributionId];
    }
    
  [registrar registerViewFactory:googleMapFactory
                                withId:@"plugins.flutter.dev/google_maps_ios"
      gestureRecognizersBlockingPolicy:
          FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];
}

@end
