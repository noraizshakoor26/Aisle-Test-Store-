part of 'route_bloc.dart';

abstract class RouteEvent {}

class RouteStarted extends RouteEvent {}

class RouteSignedOut extends RouteEvent {}
