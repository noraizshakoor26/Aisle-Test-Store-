import 'package:flutter/material.dart';

class NavigatorService {
  static NavigatorService? instance;

  factory NavigatorService() {
    instance ??= NavigatorService._();
    return instance!;
  }
  NavigatorService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  BuildContext? get context => navigatorKey.currentContext;

  Future<T?> push<T>(Widget screen) {
    return _navigator.push<T>(MaterialPageRoute(builder: (_) => screen));
  }

  Future<T?> pushReplacement<T, TO>(Widget screen, {bool fade = false}) {
    return _navigator.pushReplacement<T, TO>(_route(screen, fade: fade));
  }

  Future<T?> pushAndRemoveUntil<T>(Widget screen, {bool fade = false}) {
    return _navigator.pushAndRemoveUntil<T>(
      _route(screen, fade: fade),
      (route) => false,
    );
  }

  Route<T> _route<T>(Widget screen, {required bool fade}) {
    if (!fade) return MaterialPageRoute(builder: (_) => screen);
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) => screen,
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: child,
      ),
    );
  }

  void pop<T>([T? result]) => _navigator.pop<T>(result);
}
