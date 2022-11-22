import 'package:google_maps_routes_api/src/types/enums.dart';

class NavigationInstruction {
  const NavigationInstruction({this.maneuver, this.instructions});

  final Maneuver? maneuver;
  final String? instructions;

  static NavigationInstruction? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return NavigationInstruction(
        maneuver: data['maneuver'] != null
            ? Maneuver.values.byName(data['maneuver'])
            : null,
        instructions: data['instructions']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'maneuver': maneuver?.name,
      'instructions': instructions,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}
