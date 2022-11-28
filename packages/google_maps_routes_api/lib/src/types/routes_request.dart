import 'enums.dart';
import 'waypoint.dart';

class RoutesRequest {
  RoutesRequest({
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
  List<Waypoint>? intermediates;
  RouteTravelMode? travelMode;
  RoutingPreference? routingPreference;
  PolylineQuality? polylineQuality;
  PolylineEncoding? polylineEncoding;
  String? departureTime;
  bool? computeAlternativeRoutes;
  RouteModifiers? routeModifiers;
  String? languageCode;
  Units? units;
  ReferenceRoute? requestedReferenceRoutes;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'intermediates':
          intermediates?.map((Waypoint waypoint) => waypoint.toJson()).toList(),
      'travelMode': travelMode?.name,
      'routingPreference': routingPreference?.name,
      'polylineQuality': polylineQuality?.name,
      'polylineEncoding': polylineEncoding?.name,
      'departureTime': departureTime,
      'computeAlternativeRoutes': computeAlternativeRoutes,
      'routeModifiers': routeModifiers?.toJson(),
      'languageCode': languageCode,
      'units': units?.name,
      'requestedReferenceRoutes': requestedReferenceRoutes?.name
    };

    json.removeWhere((String key, value) => value == null);
    return json;
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
    final Map<String, dynamic> json = <String, dynamic>{
      'avoidTolls': avoidTolls,
      'avoidHighways': avoidHighways,
      'avoidFerries': avoidFerries,
      'avoidIndoor': avoidIndoor,
      'vehicleInfo': vehicleInfo?.toJson(),
      'tollPasses': tollPasses as List<String>,
    };
    json.removeWhere((String key, value) => value == null);
    return json;
  }
}

class VehicleInfo {
  const VehicleInfo({required this.emissionType});

  final VehicleEmissionType emissionType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'emissionType': emissionType.name};
  }
}
