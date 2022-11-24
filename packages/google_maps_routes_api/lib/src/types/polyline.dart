import 'package:google_maps_routes_api/src/types/location.dart';

class Polyline {
  const Polyline({this.encodedPolyline, this.geoJsonLinestring});

  final String? encodedPolyline;
  final GeoJsonLinestring? geoJsonLinestring;
  // TODO: Support for GeoJsonLinestring
  static Polyline? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return Polyline(
        encodedPolyline: data['encodedPolyline'],
        geoJsonLinestring: data['geoJsonLinestring'] != null
            ? GeoJsonLinestring.fromJson(data['geoJsonLinestring'])
            : null);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'encodedPolyline': encodedPolyline,
      'geoJsonLinestring': geoJsonLinestring?.toJson(),
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class GeoJsonLinestring {
  const GeoJsonLinestring({required this.coordinates, required this.type});

  final String type;
  final List<LatLng> coordinates;

  static GeoJsonLinestring? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return GeoJsonLinestring(
      type: data['type'],
      coordinates: List<LatLng>.from(
        data['coordinates'].map((coordinate) => LatLng.fromJson(coordinate)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'type': type,
      'coordinates':
          coordinates.map((coordinate) => coordinate.toJson()).toList(),
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}
