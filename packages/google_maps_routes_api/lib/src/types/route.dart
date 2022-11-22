import 'package:google_maps_routes_api/src/types/location.dart';
import 'package:google_maps_routes_api/src/types/polyline.dart';
import 'package:google_maps_routes_api/src/types/route_leg.dart';
import 'package:google_maps_routes_api/src/types/enums.dart';
import 'package:google_maps_routes_api/src/types/travel_advisory.dart';

class Route {
  const Route({
    this.routeLabels,
    this.legs,
    this.distanceMeters,
    this.duration,
    this.staticDuration,
    this.polyline,
    this.description,
    this.warnings,
    this.viewport,
    this.travelAdvisory,
    this.routeToken,
  });

  final List<RouteLabel>? routeLabels;
  final List<RouteLeg>? legs;
  final int? distanceMeters;
  final String? duration;
  final String? staticDuration;
  final Polyline? polyline;
  final String? description;
  final List<String>? warnings;
  final Viewport? viewport;
  final RouteTravelAdvisory? travelAdvisory;
  final String? routeToken;

  static Route? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    List<RouteLabel>? routeLabels = data['routeLabels'] != null
        ? List<RouteLabel>.from(
            data['routeLabels'].map((label) => RouteLabel.values.byName(label)))
        : null;

    List<RouteLeg> legs = List<RouteLeg>.from(
        data['legs'].map((model) => RouteLeg.fromJson(model)));
    return Route(
      routeLabels: routeLabels,
      legs: legs,
      distanceMeters: data['distanceMeters'],
      duration: data['duration'],
      staticDuration: data['staticDuration'],
      polyline:
          data['polyline'] != null ? Polyline.fromJson(data['polyline']) : null,
      description: data['description'],
      warnings: data['warnings'] == null
          ? []
          : (data['warnings'] as List<dynamic>).cast<String>(),
      viewport:
          data['viewport'] != null ? Viewport.fromJson(data['viewport']) : null,
      travelAdvisory: data['travelAdvisory'] == null
          ? null
          : RouteTravelAdvisory.fromJson(data['travelAdvisory']),
      routeToken: data['routeToken'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'routeLabels': routeLabels?.map((label) => label.name).toList(),
      'legs': legs?.map((leg) => leg.toJson()).toList(),
      'distanceMeters': distanceMeters,
      'duration': duration,
      'staticDuration': staticDuration,
      'polyline': polyline?.toJson(),
      'description': description,
      'warnings': warnings,
      'viewport': viewport?.toJson(),
      'travelAdvisory': travelAdvisory?.toJson(),
      'routeToken': routeToken,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class Viewport {
  const Viewport({this.low, this.high});

  final LatLng? low;
  final LatLng? high;

  static Viewport? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return Viewport(
      low: LatLng.fromJson(data['low']),
      high: LatLng.fromJson(data['high']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'low': low?.toMap(),
      'high': high?.toMap(),
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}
