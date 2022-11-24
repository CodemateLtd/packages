import 'toll_info.dart';

class RouteTravelAdvisory {
  const RouteTravelAdvisory(
      {this.tollInfo,
      this.speedReadingIntervals,
      this.fuelConsumptionMicroliters});

  final TollInfo? tollInfo;
  final List<SpeedReadingInterval>? speedReadingIntervals;
  final String? fuelConsumptionMicroliters;

  static RouteTravelAdvisory? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    final List<SpeedReadingInterval>? speedReadingIntervals =
        data['speedReadingIntervals'] != null
            ? List<SpeedReadingInterval>.from(data['speedReadingIntervals']
                .map((model) => SpeedReadingInterval.fromJson(model)))
            : null;

    return RouteTravelAdvisory(
      tollInfo:
          data['tollInfo'] != null ? TollInfo.fromJson(data['tollInfo']) : null,
      speedReadingIntervals: speedReadingIntervals,
      fuelConsumptionMicroliters: data['fuelConsumptionMicroliters'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'tollInfo': tollInfo?.toJson(),
      'speedReadingIntervals': speedReadingIntervals
          ?.map((SpeedReadingInterval interval) => interval.toJson())
          .toList(),
      'fuelConsumptionMicroliters': fuelConsumptionMicroliters,
    };

    json.removeWhere((String key, value) => value == null);
    return json;
  }
}

class RouteLegTravelAdvisory {
  const RouteLegTravelAdvisory({this.tollInfo, this.speedReadingIntervals});

  final TollInfo? tollInfo;
  final List<SpeedReadingInterval>? speedReadingIntervals;

  static RouteLegTravelAdvisory? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    final List<SpeedReadingInterval>? speedReadingIntervals =
        data['speedReadingIntervals'] != null
            ? List<SpeedReadingInterval>.from(data['speedReadingIntervals']
                .map((model) => SpeedReadingInterval.fromJson(model)))
            : null;

    return RouteLegTravelAdvisory(
        tollInfo: data['tollInfo'] != null
            ? TollInfo.fromJson(data['tollInfo'])
            : null,
        speedReadingIntervals: speedReadingIntervals);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'tollInfo': tollInfo?.toJson(),
      'speedReadingIntervals': speedReadingIntervals
          ?.map((SpeedReadingInterval interval) => interval.toJson())
          .toList(),
    };

    json.removeWhere((String key, value) => value == null);
    return json;
  }
}

class RouteLegStepTravelAdvisory {
  const RouteLegStepTravelAdvisory({required this.speedReadingIntervals});

  final List<SpeedReadingInterval> speedReadingIntervals;

  static RouteLegStepTravelAdvisory? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    final List<SpeedReadingInterval> speedReadingIntervals =
        List<SpeedReadingInterval>.from(data['speedReadingIntervals']
            .map((model) => SpeedReadingInterval.fromJson(model)));

    return RouteLegStepTravelAdvisory(
        speedReadingIntervals: speedReadingIntervals);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'speedReadingIntervals': speedReadingIntervals
          .map((SpeedReadingInterval interval) => interval.toJson())
          .toList(),
    };
  }
}
