import 'package:google_maps_routes_api/src/types/route.dart';
export 'package:google_maps_routes_api/src/types/toll_info.dart';
export 'package:google_maps_routes_api/src/types/route.dart';
export 'package:google_maps_routes_api/src/types/route_leg.dart';

class RoutesResponse {
  const RoutesResponse({ this.routes, this.fallbackInfo });

  final List<Route>? routes;
  final FallbackInfo? fallbackInfo;
}

class FallbackInfo {
  const FallbackInfo({ this.routingMode, this.reason });

  final FallbackRoutingMode? routingMode;
  final FallbackReason? reason;
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