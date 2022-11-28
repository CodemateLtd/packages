import 'enums.dart';
import 'routes_request.dart';
import 'waypoint.dart';

class RouteMatrixRequest {
  RouteMatrixRequest({
    required this.origins,
    required this.destinations,
    this.travelMode,
    this.routingPreference,
    this.departureTime,
  });

  final List<RouteMatrixOrigin> origins;
  final List<RouteMatrixDestination> destinations;
  RouteTravelMode? travelMode;
  RoutingPreference? routingPreference;
  String? departureTime;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'origins':
          origins.map((RouteMatrixOrigin origin) => origin.toJson()).toList(),
      'destinations': destinations
          .map((RouteMatrixDestination destination) => destination.toJson())
          .toList(),
      'travelMode': travelMode?.name,
      'routingPreference': routingPreference?.name,
      'departureTime': departureTime,
    };

    json.removeWhere((String key, value) => value == null);
    return json;
  }
}

class RouteMatrixOrigin {
  RouteMatrixOrigin({
    required this.waypoint,
    this.routeModifiers,
  });

  final Waypoint waypoint;
  RouteModifiers? routeModifiers;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'waypoint': waypoint.toJson(),
      'routeModifiers': routeModifiers?.toJson(),
    };

    json.removeWhere((String key, value) => value == null);
    return json;
  }
}

class RouteMatrixDestination {
  RouteMatrixDestination({
    required this.waypoint,
  });

  final Waypoint waypoint;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'waypoint': waypoint.toJson(),
    };
  }
}
