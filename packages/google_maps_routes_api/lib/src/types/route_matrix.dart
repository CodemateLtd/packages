import 'package:google_maps_routes_api/src/types/enums.dart';
import 'package:google_maps_routes_api/src/types/routes_response.dart';
import 'package:google_maps_routes_api/src/types/travel_advisory.dart';

class RouteMatrix {
  const RouteMatrix({
    this.status,
    this.condition,
    this.distanceMeters,
    this.duration,
    this.staticDuration,
    this.travelAdvisory,
    this.fallbackInfo,
    this.originIndex,
    this.destinationIndex,
  });

  final Status? status;
  final RouteMatrixElementCondition? condition;
  final int? distanceMeters;
  final String? duration;
  final String? staticDuration;
  final RouteTravelAdvisory? travelAdvisory;
  final FallbackInfo? fallbackInfo;
  final int? originIndex;
  final int? destinationIndex;

  static RouteMatrix? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return RouteMatrix(
      status: Status.fromJson(data['status']),
      condition: data['condition'] != null
          ? RouteMatrixElementCondition.values.byName(data['condition'])
          : null,
      distanceMeters: data['distanceMeters'],
      duration: data['duration'],
      staticDuration: data['staticDuration'],
      travelAdvisory: RouteTravelAdvisory.fromJson(data['travelAdvisory']),
      fallbackInfo: FallbackInfo.fromJson(data['fallbackInfo']),
      originIndex: data['originIndex'],
      destinationIndex: data['destinationIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'status': status?.toJson(),
      'condition': condition?.name,
      'distanceMeters': distanceMeters,
      'duration': duration,
      'staticDuration': staticDuration,
      'travelAdvisory': travelAdvisory?.toJson(),
      'fallbackInfo': fallbackInfo?.toJson(),
      'originIndex': originIndex,
      'destinationIndex': destinationIndex,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class Status {
  const Status({this.code, this.message, this.details});

  final int? code;
  final String? message;
  final List<Map<String, dynamic>>? details;

  static Status? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return Status(
        code: data['code'], message: data['message'], details: data['details']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'code': code,
      'message': message,
      'details': details,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}
