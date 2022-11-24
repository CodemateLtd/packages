import 'enums.dart';

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
    final Map<String, dynamic> json = <String, dynamic>{
      'maneuver': maneuver?.name,
      'instructions': instructions,
    };

    json.removeWhere((String key, dynamic value) => value == null);
    return json;
  }
}
