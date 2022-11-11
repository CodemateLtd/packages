import 'dart:convert';

import 'package:google_maps_routes_api/src/types/enums.dart';
import 'package:google_maps_routes_api/src/types/waypoint.dart';

class RoutesRequest {
  const RoutesRequest({
    required this.origin,
    required this.destination,
    this.intermediates,
    this.travelMode,
    this.routingPreference,
    this.polylineQuality,
    this.polylineEncoding,
    this.departureTime,
    this.computeAlternativeRoutes,
    this.routeModifiers,
    this.languageCode,
    this.units,
    this.requestedReferenceRoutes,
  });

  final Waypoint origin;
  final Waypoint destination;
  final List<Waypoint>? intermediates;
  final RouteTravelMode? travelMode;
  final RoutingPreference? routingPreference;
  final PolylineQuality? polylineQuality;
  final PolylineEncoding? polylineEncoding;
  final String? departureTime;
  final bool? computeAlternativeRoutes;
  final RouteModifiers? routeModifiers;
  final String? languageCode;
  final Units? units;
  final ReferenceRoute? requestedReferenceRoutes;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'origin': jsonEncode(origin),
      'destination': jsonEncode(destination),
      'intermediates': jsonEncode(intermediates),
      'travelMode':  travelMode?.toString(),
      'routingPreference': routingPreference?.toString(),
      'polylineQuality': polylineQuality?.toString(),
      'polylineEncoding': polylineEncoding?.toString(),
      'departureTime': departureTime,
      'computeAlternativeRoutes': computeAlternativeRoutes,
      'routeModifiers': jsonEncode(routeModifiers),
      'languageCode': languageCode,
      'units': units?.toString(),
      'requestedReferenceRoutes': requestedReferenceRoutes?.toString()
    };
  }
}

class RouteModifiers {
  const RouteModifiers({
    this.avoidTolls,
    this.avoidHighways,
    this.avoidFerries,
    this.avoidIndoor,
    this.vehicleInfo,
    this.tollPasses,
  });

  final bool? avoidTolls;
  final bool? avoidHighways;
  final bool? avoidFerries;
  final bool? avoidIndoor;
  final VehicleInfo? vehicleInfo;
  final List<TollPass>? tollPasses;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'avoidTolls': avoidTolls,
      'avoidHighways': avoidHighways,
      'avoidFerries': avoidFerries,
      'avoidIndoor': avoidIndoor,
      'vehicleInfo': vehicleInfo?.toJson(),
      'tollPasses': tollPasses as List<String>,
    };

  }
}

class VehicleInfo {
  const VehicleInfo({required this.emissionType});

  final VehicleEmissionType emissionType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'emissionType': emissionType.toString()
    };
  }
}
