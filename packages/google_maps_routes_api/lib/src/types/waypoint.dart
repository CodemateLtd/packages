import 'package:google_maps_routes_api/src/types/location.dart';

class Waypoint {
  const Waypoint({
    this.via,
    this.vehicleStopover,
    this.sideOfRoad,
    this.location,
    this.placeId,
  });

  final bool? via;
  final bool? vehicleStopover;
  final bool? sideOfRoad;
  final Location? location;
  final String? placeId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'via': via,
      'vehicleStopover': vehicleStopover,
      'sideOfRoad': sideOfRoad,
      'location': location?.toJson(),
      'placeId': placeId,
    };
  }
}
