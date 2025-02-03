// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

#import "messages.g.h"

@interface FGMImageRegistry : NSObject<FGMImageRegistryApi>

- (instancetype)init;

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;

- (UIImage *)getBitmap:(NSNumber *)identifier;

@end
