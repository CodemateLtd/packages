// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import androidx.annotation.Nullable;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

class GroundOverlayController implements GroundOverlaySink {
  private final GroundOverlay groundOverlay;
  private final String googleMapsGroundOverlayId;

  GroundOverlayController(GroundOverlay groundOverlay) {
    this.groundOverlay = groundOverlay;
    this.googleMapsGroundOverlayId = groundOverlay.getId();
  }

  void remove() {
    groundOverlay.remove();
  }

  GroundOverlay getGroundOverlay() {
    return groundOverlay;
  }

  @Override
  public void setTransparency(float transparency) {
    groundOverlay.setTransparency(transparency);
  }

  @Override
  public void setZIndex(float zIndex) {
    groundOverlay.setZIndex(zIndex);
  }

  @Override
  public void setVisible(boolean visible) {
    groundOverlay.setVisible(visible);
  }

  @Override
  public void setAnchor(float u, float v) {}

  @Override
  public void setBearing(float bearing) {
    groundOverlay.setBearing(bearing);
  }

  @Override
  public void setClickable(boolean clickable) {
    groundOverlay.setClickable(clickable);
  }

  @Override
  public void setImage(BitmapDescriptor imageDescriptor) {
    groundOverlay.setImage(imageDescriptor);
  }

  @Override
  public void setPosition(LatLng location, Float width, @Nullable Float height) {
    groundOverlay.setPosition(location);
    if (height == null) {
      groundOverlay.setDimensions(width);
    } else {
      groundOverlay.setDimensions(width, height);
    }
  }

  @Override
  public void setPositionFromBounds(LatLngBounds bounds) {
    groundOverlay.setPositionFromBounds(bounds);
  }

  String getGoogleMapsGroundOverlayId() {
    return googleMapsGroundOverlayId;
  }
}
