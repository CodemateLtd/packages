import 'package:google_maps_routes_api/routes_service.dart';
import 'package:google_maps_routes_api/src/types/index.dart';
import 'package:google_maps_routes_api/src/types/waypoint.dart';

void main() async {
  final RoutesResponse routes = await _computeRoutes();
  print('ROUTES FETCHED:');
  print(routes.toJson());
  print('\n\n');
  final List<RouteMatrix> matrixes = await _computeRouteMatrix();
  print('ROUTE MATRIX FETCHED:');
  print(matrixes.map((RouteMatrix matrix) => matrix.toJson()));
}

Future<RoutesResponse> _computeRoutes() async {
  const String API_KEY =
      String.fromEnvironment('GOOGLE_API_KEY', defaultValue: 'GOOGLE_API_KEY');

  const RoutesService routesService = RoutesService(apiKey: API_KEY);
  const Waypoint origin = Waypoint(
    location: Location(
      latLng: LatLng(37.419734, -122.0827784),
    ),
  );
  const Waypoint destination = Waypoint(
    location: Location(
      latLng: LatLng(37.417670, -122.079595),
    ),
  );
  final RoutesRequest body = RoutesRequest(
    origin: origin,
    destination: destination,
    travelMode: RouteTravelMode.DRIVE,
    polylineEncoding: PolylineEncoding.GEO_JSON_LINESTRING,
  );

  const String fields =
      'routes.legs,routes.duration,routes.distanceMeters,routes.polyline,routes.warnings,routes.description';
  final RoutesResponse response =
      await routesService.computeRoute(body, fields: fields);
  return response;
}

Future<List<RouteMatrix>> _computeRouteMatrix() async {
  const String API_KEY =
      String.fromEnvironment('GOOGLE_API_KEY', defaultValue: 'GOOGLE_API_KEY');

  const RoutesService routesService = RoutesService(apiKey: API_KEY);
  final List<RouteMatrixOrigin> origins = [
    RouteMatrixOrigin(
      waypoint: const Waypoint(
        location: Location(
          latLng: LatLng(37.420761, -122.081356),
        ),
      ),
    ),
    RouteMatrixOrigin(
      waypoint: const Waypoint(
        location: Location(
          latLng: LatLng(37.403184, -122.097371),
        ),
      ),
    ),
  ];
  final List<RouteMatrixDestination> destinations = [
    RouteMatrixDestination(
      waypoint: const Waypoint(
        location: Location(
          latLng: LatLng(37.420761, -122.081356),
        ),
      ),
    ),
    RouteMatrixDestination(
      waypoint: const Waypoint(
        location: Location(
          latLng: LatLng(37.383047, -122.044651),
        ),
      ),
    ),
  ];

  const String fields =
      'status,originIndex,destinationIndex,condition,distanceMeters,duration';

  final RouteMatrixRequest body = RouteMatrixRequest(
    origins: origins,
    destinations: destinations,
    travelMode: RouteTravelMode.DRIVE,
    routingPreference: RoutingPreference.TRAFFIC_AWARE,
  );
  final List<RouteMatrix> response =
      await routesService.computeRouteMatrix(body, fields: fields);

  return response;
}
