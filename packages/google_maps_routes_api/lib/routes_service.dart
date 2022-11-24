library google_maps_routes_api;

import 'dart:convert';
import 'package:google_maps_routes_api/src/types/index.dart';
import 'package:http/http.dart' as http;

/// A service used to calculate a route between two points
class RoutesService {
  const RoutesService({required this.apiKey});

  final String apiKey;

  static const _routesApiUrl = 'https://routes.googleapis.com/';

  Future<RoutesResponse> computeRoute(
    RoutesRequest body, {
    String? fields,
    Map<String, String>? headers,
  }) async {
    const url = '$_routesApiUrl/directions/v2:computeRoutes';
    Map<String, String> defaultHeaders = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-Fieldmask': fields ?? 'routes.duration, routes.distanceMeters',
      "Content-Type": "application/json",
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(body),
        headers: {...defaultHeaders, ...?headers});

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    
    final result = RoutesResponse.fromJson(json.decode(response.body));
    return Future<RoutesResponse>.value(result);
  }

  Future<List<RouteMatrix>> computeRouteMatrix(RouteMatrixRequest body,
      {String? fields, Map<String, String>? headers}) async {
    const url = '$_routesApiUrl/distanceMatrix/v2:computeRouteMatrix';
    Map<String, String> defaultHeaders = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-Fieldmask': fields ?? 'duration, distanceMeters',
      "Content-Type": "application/json",
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(body),
        headers: {...defaultHeaders, ...?headers});

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    List<RouteMatrix> result = List<RouteMatrix>.from(
        json.decode(response.body).map((model) => RouteMatrix.fromJson(model)));
    return Future<List<RouteMatrix>>.value(result);
  }
}
