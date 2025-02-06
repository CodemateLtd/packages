// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

#import "messages.g.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGMImageRegistry : NSObject<FGMImageRegistryApi>

- (instancetype)init;

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;

/// Returns registered image with the given identifier or null if registered image is not found.
///
/// @param identifier An identifier of the registered image.
- (nullable UIImage *)getBitmap:(NSNumber *)identifier;

@end

NS_ASSUME_NONNULL_END
