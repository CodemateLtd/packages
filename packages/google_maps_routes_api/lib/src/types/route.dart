import 'package:google_maps_routes_api/src/types/location.dart';
import 'package:google_maps_routes_api/src/types/route_leg.dart';
import 'package:google_maps_routes_api/src/types/toll_info.dart';

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
  final RouteLegTravelAdvisory? travelAdvisory;
  final String? routeToken;

  static Route? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    List<RouteLabel> routeLabels = List<RouteLabel>.from(
        data['routeLabels'].map((label) => RouteLabel.values.byName(label)));

    List<RouteLeg> legs = List<RouteLeg>.from(
        data['legs'].map((model) => RouteLeg.fromJson(model)));

    return Route(
      routeLabels: routeLabels,
      legs: legs,
      distanceMeters: data['distanceMeters'],
      duration: data['duration'],
      staticDuration: data['staticDuration'],
      polyline: Polyline.fromJson(data['polyline']),
      description: data['description'],
      warnings: (data['warnings'] as List<dynamic>).cast<String>(),
      viewport: Viewport.fromJson(data['viewport']),
      travelAdvisory: RouteLegTravelAdvisory.fromJson(data['travelAdvisory']),
      routeToken: data['routeToken'],
    );
  }
}


class Polyline {
  const Polyline({required this.encodedPolyLine});

  final String encodedPolyLine;

  static Polyline? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return Polyline(encodedPolyLine: data['encodedPolyline']);
  }
}

class RouteLegTravelAdvisory {
  const RouteLegTravelAdvisory({this.tollInfo, this.speedReadingIntervals});

  final TollInfo? tollInfo;
  final List<SpeedReadingInterval>? speedReadingIntervals;

  static RouteLegTravelAdvisory? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    List<SpeedReadingInterval> speedReadingIntervals =
        List<SpeedReadingInterval>.from(data['speedReadingIntervals']
            .map((model) => SpeedReadingInterval.fromJson(model)));

    return RouteLegTravelAdvisory(
        tollInfo: data['tollInfo'],
        speedReadingIntervals: speedReadingIntervals);
  }
}

class NavigationInstruction {
  const NavigationInstruction({this.maneuver, this.instructions});

  final Maneuver? maneuver;
  final String? instructions;

  static NavigationInstruction? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return NavigationInstruction(
        maneuver: Maneuver.values.byName(data['maneuver']),
        instructions: data['instructions']);
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
        high: LatLng.fromJson(data['high']));
  }
}

enum Maneuver {
  MANEUVER_UNSPECIFIED,
  TURN_SLIGHT_LEFT,
  TURN_SHARP_LEFT,
  UTURN_LEFT,
  TURN_LEFT,
  TURN_SLIGHT_RIGHT,
  TURN_SHARP_RIGHT,
  UTURN_RIGHT,
  TURN_RIGHT,
  STRAIGHT,
  RAMP_LEFT,
  RAMP_RIGHT,
  MERGE,
  FORK_LEFT,
  FORK_RIGHT,
  FERRY,
  FERRY_TRAIN,
  ROUNDABOUT_LEFT,
  ROUNDABOUT_RIGHT,
}

enum RouteLabel {
  ROUTE_LABEL_UNSPECIFIED,
  DEFAULT_ROUTE,
  DEFAULT_ROUTE_ALTERNATE,
  FUEL_EFFICIENT,
}
