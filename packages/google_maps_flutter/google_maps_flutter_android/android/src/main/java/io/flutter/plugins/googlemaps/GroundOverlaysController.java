// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import android.content.res.AssetManager;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import io.flutter.plugins.googlemaps.Messages.MapsCallbackApi;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class GroundOverlaysController {
  @VisibleForTesting final Map<String, GroundOverlayController> groundOverlayIdToController;
  private final HashMap<String, String> googleMapsGroundOverlayIdToDartGroundOverlayId;
  private final MapsCallbackApi flutterApi;
  private GoogleMap googleMap;
  private final AssetManager assetManager;
  private final float density;

  GroundOverlaysController(MapsCallbackApi flutterApi, AssetManager assetManager, float density) {
    this.groundOverlayIdToController = new HashMap<>();
    this.googleMapsGroundOverlayIdToDartGroundOverlayId = new HashMap<>();
    this.flutterApi = flutterApi;
    this.assetManager = assetManager;
    this.density = density;
  }

  void setGoogleMap(GoogleMap googleMap) {
    this.googleMap = googleMap;
  }

  void addGroundOverlays(@NonNull List<Messages.PlatformGroundOverlay> groundOverlaysToAdd) {
    for (Messages.PlatformGroundOverlay groundOverlayToAdd : groundOverlaysToAdd) {
      addGroundOverlay(groundOverlayToAdd);
    }
  }

  void changeGroundOverlays(@NonNull List<Messages.PlatformGroundOverlay> groundOverlaysToChange) {
    for (Messages.PlatformGroundOverlay groundOverlayToChange : groundOverlaysToChange) {
      changeGroundOverlay(groundOverlayToChange);
    }
  }

  void removeGroundOverlays(List<String> groundOverlayIdsToRemove) {
    if (groundOverlayIdsToRemove == null) {
      return;
    }
    for (String groundOverlayId : groundOverlayIdsToRemove) {
      if (groundOverlayId == null) {
        continue;
      }
      removeGroundOverlay(groundOverlayId);
    }
  }

  @Nullable
  GroundOverlay getGroundOverlay(String groundOverlayId) {
    if (groundOverlayId == null) {
      return null;
    }
    GroundOverlayController groundOverlayController =
        groundOverlayIdToController.get(groundOverlayId);
    if (groundOverlayController == null) {
      return null;
    }
    return groundOverlayController.getGroundOverlay();
  }

  private void addGroundOverlay(@NonNull Messages.PlatformGroundOverlay platformGroundOverlay) {
    GroundOverlayBuilder groundOverlayOptionsBuilder = new GroundOverlayBuilder();
    String groundOverlayId =
        Convert.interpretGroundOverlayOptions(
            platformGroundOverlay, groundOverlayOptionsBuilder, assetManager, density);
    GroundOverlayOptions options = groundOverlayOptionsBuilder.build();
    final GroundOverlay groundOverlay = googleMap.addGroundOverlay(options);
    GroundOverlayController groundOverlayController = new GroundOverlayController(groundOverlay);
    groundOverlayIdToController.put(groundOverlayId, groundOverlayController);
    googleMapsGroundOverlayIdToDartGroundOverlayId.put(groundOverlay.getId(), groundOverlayId);
  }

  private void changeGroundOverlay(@NonNull Messages.PlatformGroundOverlay platformGroundOverlay) {
    String groundOverlayId = platformGroundOverlay.getGroundOverlayId();
    GroundOverlayController groundOverlayController =
        groundOverlayIdToController.get(groundOverlayId);
    if (groundOverlayController != null) {
      Convert.interpretGroundOverlayOptions(
          platformGroundOverlay, groundOverlayController, assetManager, density);
    }
  }

  private void removeGroundOverlay(String groundOverlayId) {
    GroundOverlayController groundOverlayController =
        groundOverlayIdToController.get(groundOverlayId);
    if (groundOverlayController != null) {
      groundOverlayController.remove();
      groundOverlayIdToController.remove(groundOverlayId);
      googleMapsGroundOverlayIdToDartGroundOverlayId.remove(
          groundOverlayController.getGoogleMapsGroundOverlayId());
    }
  }

  void onGroundOverlayTap(String googleGroundOverlayId) {
    String groundOverlayId =
        googleMapsGroundOverlayIdToDartGroundOverlayId.get(googleGroundOverlayId);
    if (groundOverlayId == null) {
      return;
    }
    flutterApi.onGroundOverlayTap(groundOverlayId, new NoOpVoidResult());
  }
}
