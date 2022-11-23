import 'package:google_maps_routes_api/routes_service.dart';
import 'package:google_maps_routes_api/src/types/index.dart';

void main() async {
  RoutesResponse routes = await _computeRoutes();
  print('ROUTES FETCHED:');
  print(routes.toJson());
  print('\n\n');
  List<RouteMatrix> matrixes = await _computeRouteMatrix();
  print('ROUTE MATRIX FETCHED:');
  print(matrixes.map((matrix) => matrix.toJson()));
}

Future<RoutesResponse> _computeRoutes() async {
  const API_KEY =
      String.fromEnvironment('GOOGLE_API_KEY', defaultValue: 'GOOGLE_API_KEY');

  RoutesService routesService = const RoutesService(apiKey: API_KEY);
  const origin = Waypoint(
    location: Location(
      latLng: LatLng(37.419734, -122.0827784),
    ),
  );
  const destination = Waypoint(
    location: Location(
      latLng: LatLng(37.417670, -122.079595),
    ),
  );
  RoutesRequest body = RoutesRequest(
    origin: origin,
    destination: destination,
    travelMode: RouteTravelMode.DRIVE,
  );

  const fields =
      'routes.legs,routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline,routes.warnings,routes.description';
  RoutesResponse response =
      await routesService.computeRoute(body, fields: fields);
  return response;
}

Future<List<RouteMatrix>> _computeRouteMatrix() async {
  const API_KEY =
      String.fromEnvironment('GOOGLE_API_KEY', defaultValue: 'GOOGLE_API_KEY');

  RoutesService routesService = const RoutesService(apiKey: API_KEY);
  List<RouteMatrixOrigin> origins = [
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
  List<RouteMatrixDestination> destinations = [
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

  const fields =
      'status,originIndex,destinationIndex,condition,distanceMeters,duration';

  RouteMatrixRequest body = RouteMatrixRequest(
    origins: origins,
    destinations: destinations,
    travelMode: RouteTravelMode.DRIVE,
    routingPreference: RoutingPreference.TRAFFIC_AWARE,
  );
  List<RouteMatrix> response =
      await routesService.computeRouteMatrix(body, fields: fields);

  return response;
}
