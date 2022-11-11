
import 'package:google_maps_routes_api/src/types/location.dart';
import 'package:google_maps_routes_api/src/types/route.dart';

class RouteLeg {
  const RouteLeg({
    this.distanceMeters,
    this.duration,
    this.staticDuration,
    this.polyline,
    this.startLocation,
    this.endLocation,
    this.steps,
    this.travelAdvisory,
  });

  final int? distanceMeters;
  final String? duration;
  final String? staticDuration;
  final Polyline? polyline;
  final Location? startLocation;
  final Location? endLocation;
  final List<RouteLegStep>? steps;
  final RouteLegTravelAdvisory? travelAdvisory;

  static RouteLeg? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;
    List<RouteLegStep> steps = List<RouteLegStep>.from(
        data['steps'].map((model) => RouteLegStep.fromJson(model)));

    return RouteLeg(
      distanceMeters: data['distanceMeters'],
      staticDuration: data['staticDuration'],
      polyline: Polyline.fromJson(data['polyline']),
      startLocation: Location.fromJson(data['startLocation']),
      endLocation: Location.fromJson(data['endLocation']),
      steps: steps,
      travelAdvisory: RouteLegTravelAdvisory.fromJson(data['travelAdvisory']),
    );
  }
}

class RouteLegStep {
  const RouteLegStep({
    this.distanceMeters,
    this.staticDuration,
    this.polyline,
    this.endLocation,
    this.startLocation,
    this.navigationInstruction,
  });

  final int? distanceMeters;
  final String? staticDuration;
  final Polyline? polyline;
  final Location? endLocation;
  final Location? startLocation;
  final NavigationInstruction? navigationInstruction;

  static RouteLegStep? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return RouteLegStep(
      distanceMeters: data['distanceMeters'],
      staticDuration: data['staticDuration'],
      polyline: Polyline.fromJson(data['polyline']),
      endLocation: Location.fromJson(data['endLocation']),
      startLocation: Location.fromJson(data['startLocation']),
      navigationInstruction:
          NavigationInstruction.fromJson(data['navigationInstruction']),
    );
  }
}
