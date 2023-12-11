// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "GMSMarker+Userdata.h"

@implementation GMSMarker (Userdata)

- (void)setMarkerIdentifier:(NSString *)markerIdentifier {
  self.userData = @[ markerIdentifier ];
}

- (void)setMarkerIdentifier:(NSString *)markerIdentifier andClusterManagerIdentifier:(NSString *)clusterManagerIdentifier {
  self.userData = @[ markerIdentifier, clusterManagerIdentifier ];
}

- (NSString *)getMarkerIdentifier {
  if ([self.userData count] == 0) {
    return nil;
  }
  return self.userData[0];
}

- (NSString *)getClusterManagerIdentifier {
  if ([self.userData count] != 2) {
    return nil;
  }

  NSString *clusterManagerIdentifier = self.userData[1];
  if (clusterManagerIdentifier == (id)[NSNull null]) {
    return nil;
  }
  return clusterManagerIdentifier;
}
@end
