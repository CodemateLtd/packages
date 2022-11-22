class Polyline {
  const Polyline({required this.encodedPolyline});

  final String encodedPolyline;
  // TODO: Support for GeoJsonLinestring
  static Polyline? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return Polyline(encodedPolyline: data['encodedPolyline']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'encodedPolyline': encodedPolyline,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}