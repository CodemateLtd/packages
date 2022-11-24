library google_maps_routes_api;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'src/types/index.dart';

/// A service used to calculate a route between two points
class RoutesService {
  const RoutesService({required this.apiKey});

  final String apiKey;

  static const String _routesApiUrl = 'https://routes.googleapis.com/';

  Future<RoutesResponse> computeRoute(
    RoutesRequest body, {
    String? fields,
    Map<String, String>? headers,
  }) async {
    const String url = '$_routesApiUrl/directions/v2:computeRoutes';
    final Map<String, String> defaultHeaders = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-Fieldmask': fields ?? 'routes.duration, routes.distanceMeters',
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {...defaultHeaders, ...?headers},
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final RoutesResponse? result =
        RoutesResponse.fromJson(json.decode(response.body));
    return Future<RoutesResponse>.value(result);
  }

  Future<List<RouteMatrix>> computeRouteMatrix(RouteMatrixRequest body,
      {String? fields, Map<String, String>? headers}) async {
    const String url = '$_routesApiUrl/distanceMatrix/v2:computeRouteMatrix';
    final Map<String, String> defaultHeaders = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-Fieldmask': fields ?? 'duration, distanceMeters',
      'Content-Type': 'application/json',
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {...defaultHeaders, ...?headers},
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List<RouteMatrix> result = List<RouteMatrix>.from(
        json.decode(response.body).map((model) => RouteMatrix.fromJson(model)));
    return Future<List<RouteMatrix>>.value(result);
  }
}
