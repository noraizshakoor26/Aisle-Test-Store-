part of 'route_bloc.dart';

class RouteState {
  final StatusIndicator status;

  const RouteState({this.status = StatusIndicator.idle});

  RouteState copyWith({StatusIndicator? status}) {
    return RouteState(status: status ?? this.status);
  }
}
