import 'location.dart';

/// Encapsulates an encoded [Polyline].
class Polyline {
  /// Creates a [Polyline].
  const Polyline({this.encodedPolyline, this.geoJsonLinestring});

  /// The [String] encoding of the [Polyline] using the polyline encoding algorithm.
  ///
  /// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  final String? encodedPolyline;

  /// Specifies a [Polyline] using the [GeoJsonLinestring] format
  final GeoJsonLinestring? geoJsonLinestring;

  /// Decodes a JSON object to a [Polyline].
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

  /// Returns a JSON representation of the [Polyline].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'encodedPolyline': encodedPolyline,
      'geoJsonLinestring': geoJsonLinestring?.toJson(),
    };

    json.removeWhere((String key, dynamic value) => value == null);
    return json;
  }
}

/// Encapsulates information for a [Polyline] with an array of two or more positions.
///
/// https://www.rfc-editor.org/rfc/rfc7946#section-3.1.4
class GeoJsonLinestring {
  /// Creates a [GeoJsonLinestring].
  const GeoJsonLinestring({required this.coordinates, required this.type});

  /// The type for [GeoJsonLinestring] is always "LineString".
  final String type;

  /// Array of two or more positions represented as [LatLng] objects.
  final List<LatLng> coordinates;

  /// Decodes a JSON object to a [GeoJsonLinestring].
  static GeoJsonLinestring? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return GeoJsonLinestring(
      type: data['type'],
      coordinates: List<LatLng>.from(
        data['coordinates']
            .map((List<Object?> coordinate) => LatLng.fromJson(coordinate)),
      ),
    );
  }

  /// Returns a JSON representation of the [GeoJsonLinestring].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'type': type,
      'coordinates':
          coordinates.map((LatLng coordinate) => coordinate.toJson()).toList(),
    };

    json.removeWhere((String key, dynamic value) => value == null);
    return json;
  }
}
