import 'package:google_maps_routes_api/src/types/enums.dart';

class TollInfo {
  const TollInfo({required this.estimatedPrice});
  final List<Money> estimatedPrice;

  static TollInfo? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    List<Money> estimatedPrice = List<Money>.from(
        data['estimatedPrice'].map((model) => Money.fromJson(model)));

    return TollInfo(estimatedPrice: estimatedPrice);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'estimatedPrice': estimatedPrice.map((price) => price.toJson()).toList(),
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class Money {
  const Money(
      {required this.currencyCode, required this.units, required this.nanos});

  final String currencyCode;
  final String units;
  final int nanos;

  static Money? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return Money(
      currencyCode: data['currencyCode'],
      units: data['units'],
      nanos: data['nanos'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'estimatedPrice': currencyCode,
      'units': units,
      'nanos': nanos,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class SpeedReadingInterval {
  const SpeedReadingInterval({
    this.speed,
    this.startPolylinePointIndex,
    this.endPolylinePointIndex,
  });

  final Speed? speed;
  final int? startPolylinePointIndex;
  final int? endPolylinePointIndex;

  static SpeedReadingInterval? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return SpeedReadingInterval(
      speed: data['speed'] != null ? Speed.values.byName(data['speed']) : null,
      startPolylinePointIndex: data['startPolylinePointIndex'],
      endPolylinePointIndex: data['endPolylinePointIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'speed': speed?.name,
      'startPolylinePointIndex': startPolylinePointIndex,
      'endPolylinePointIndex': endPolylinePointIndex,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}