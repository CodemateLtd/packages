// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "FGMConstants.h"

@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Provide the GoogleMaps API key.
  NSString *mapsApiKey = [[NSProcessInfo processInfo] environment][@"MAPS_API_KEY"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"YOUR KEY HERE";
  }
  [GMSServices provideAPIKey:mapsApiKey];
  
  NSString *attributionId = [NSString stringWithFormat:@"gmp_flutter_googlemapsflutter_v%sandroid", PREFIX_PLUGIN_VERSION];
  [GMSServices addInternalUsageAttributionID:attributionId];

  // Register Flutter plugins.
  [GeneratedPluginRegistrant registerWithRegistry:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
