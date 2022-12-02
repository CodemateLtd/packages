import 'package:google_maps_routes_api/routes_service.dart';
import 'package:google_maps_routes_api/src/types/index.dart';
import 'package:google_maps_routes_api/src/types/waypoint.dart';

void main() async {
  final ComputeRoutesResponse? routes = await _computeRoutes();
  print('ROUTES FETCHED:');
  print(routes?.toJson());
  print('\n\n');
  final List<RouteMatrixElement>? matrixes = await _computeRouteMatrix();
  print('ROUTE MATRIX FETCHED:');
  print(matrixes?.map((RouteMatrixElement matrix) => matrix.toJson()));
}

Future<ComputeRoutesResponse?> _computeRoutes() async {
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
  final ComputeRoutesRequest body = ComputeRoutesRequest(
    origin: origin,
    destination: destination,
    travelMode: RouteTravelMode.DRIVE,
    polylineEncoding: PolylineEncoding.GEO_JSON_LINESTRING,
  );

  const String fields =
      'routes.legs,routes.duration,routes.distanceMeters,routes.polyline,routes.warnings,routes.description,routes.viewport,routes.routeLabels';

  try {
    final ComputeRoutesResponse response =
        await routesService.computeRoute(body, fields: fields);
    return response;
  } catch (error) {
    print(error);
    return null;
  }
}

Future<List<RouteMatrixElement>?> _computeRouteMatrix() async {
  const String API_KEY =
      String.fromEnvironment('GOOGLE_API_KEY', defaultValue: 'GOOGLE_API_KEY');

  const RoutesService routesService = RoutesService(apiKey: API_KEY);
  final List<RouteMatrixOrigin> origins = <RouteMatrixOrigin>[
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
  final List<RouteMatrixDestination> destinations = <RouteMatrixDestination>[
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

  final ComputeRouteMatrixRequest body = ComputeRouteMatrixRequest(
    origins: origins,
    destinations: destinations,
    travelMode: RouteTravelMode.DRIVE,
    routingPreference: RoutingPreference.TRAFFIC_AWARE,
  );

  try {
    final List<RouteMatrixElement> response =
        await routesService.computeRouteMatrix(body, fields: fields);

    return response;
  } catch (error) {
    print(error);
    return null;
  }
}
