import 'package:google_maps_routes_api/src/types/route.dart';
export 'package:google_maps_routes_api/src/types/toll_info.dart';
export 'package:google_maps_routes_api/src/types/route.dart';
export 'package:google_maps_routes_api/src/types/route_leg.dart';

class RoutesResponse {
  const RoutesResponse({this.routes, this.fallbackInfo});

  final List<Route>? routes;
  final FallbackInfo? fallbackInfo;

  static RoutesResponse? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    List<Route>? routes = data['routes'] != null
        ? List<Route>.from(data['routes'].map((model) => Route.fromJson(model)))
        : null;

    return RoutesResponse(
      routes: routes,
      fallbackInfo: FallbackInfo.fromJson(
        data['FallbackInfo'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'routes': routes?.map((route) => route.toJson()).toList(),
      'fallbackInfo': fallbackInfo?.toJson(),
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class FallbackInfo {
  const FallbackInfo({this.routingMode, this.reason});

  final FallbackRoutingMode? routingMode;
  final FallbackReason? reason;

  static FallbackInfo? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    assert(json is Map<String, dynamic>);
    final Map<String, dynamic> data = json as Map<String, dynamic>;

    return FallbackInfo(
      routingMode: data['routingMode'] != null
          ? FallbackRoutingMode.values.byName(data['routingMode'])
          : null,
      reason: data['reason'] != null
          ? FallbackReason.values.byName(
              data['reason'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'routingMode': routingMode?.name,
      'reason': reason?.name,
    };

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

enum FallbackRoutingMode {
  FALLBACK_ROUTING_MODE_UNSPECIFIED,
  FALLBACK_TRAFFIC_UNAWARE,
  FALLBACK_TRAFFIC_AWARE,
}

enum FallbackReason {
  FALLBACK_REASON_UNSPECIFIED,
  SERVER_ERROR,
  LATENCY_EXCEEDED,
}
