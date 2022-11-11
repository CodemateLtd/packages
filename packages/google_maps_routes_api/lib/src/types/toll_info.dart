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
      speed: Speed.values.byName(data['speed']),
      startPolylinePointIndex: data['startPolylinePointIndex'],
      endPolylinePointIndex: data['endPolylinePointIndex'],
    );
  }
}

enum Speed {
  SPEED_UNSPECIFIED,
  NORMAL,
  SLOW,
  TRAFFIC_JAM,
}
