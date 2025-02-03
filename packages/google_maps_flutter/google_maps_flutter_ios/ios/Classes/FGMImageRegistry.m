// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FGMImageRegistry.h"
#import "GoogleMapMarkerController.h"

@interface FGMImageRegistry ()

/// A dictionary that stores all registered image IDs and corresponding images.
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIImage *> *registry;

/// A registration context of this plugin.
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;

@end

@implementation FGMImageRegistry

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
           _registrar = registrar;
           _registry = [[NSMutableDictionary alloc] init];
       }
    return self;
}

- (instancetype)init {
    return [self initWithRegistrar:nil];
}

- (void)addBitmapToCacheId:(NSInteger)id bitmap:(nonnull FGMPlatformBitmap *)bitmap error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"PUT BITMAP");
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    UIImage *image = [FLTGoogleMapMarkerController iconFromBitmap:bitmap
                                                        registrar:_registrar
                                                      screenScale:screenScale
                                                    imageRegistry:self];
    NSNumber *idNumber = [NSNumber numberWithInteger:id];
    [self.registry setObject:image forKey:idNumber];
}

- (void)removeBitmapFromCacheId:(NSInteger)id error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"REMOBE BITMAP");
    NSNumber *idNumber = [NSNumber numberWithInteger:id];
    [self.registry removeObjectForKey:idNumber];
}

- (void)clearBitmapCacheWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"CLEAR BITMAP");
    [self.registry removeAllObjects];
}

- (UIImage *)getBitmap:(NSNumber *)identifier {
//    NSLog(@"get BITMAP %@", identifier);
    return self.registry[identifier];
}

@end
