// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "GMSMarker+Userdata.h"

@implementation GMSMarker (Userdata)

const int markerIdentifierIndex = 0;
const int clusterManagerIdentifierIndex = 1;

- (void)setMarkerIdentifier:(NSString *)markerIdentifier {
  self.userData = @[ markerIdentifier ];
}

- (void)setMarkerIdentifier:(NSString *)markerIdentifier andClusterManagerIdentifier:(NSString *)clusterManagerIdentifier {
  self.userData = @[ markerIdentifier, clusterManagerIdentifier ];
}

- (NSString *)getMarkerIdentifier {
  if ([self.userData count] <= markerIdentifierIndex) {
    return nil;
  }
  return self.userData[markerIdentifierIndex];
}

- (NSString *)getClusterManagerIdentifier {
  if ([self.userData count] != 2) {
    return nil;
  }

  NSString *clusterManagerIdentifier = self.userData[clusterManagerIdentifierIndex];
  if (clusterManagerIdentifier == (id)[NSNull null]) {
    return nil;
  }
  return clusterManagerIdentifier;
}
@end
