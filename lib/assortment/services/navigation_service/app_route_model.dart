import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  String name;
  String path;
  String? iconPath;
  Object? data;

  List<AppRoute> routes;
  Widget Function(BuildContext context, GoRouterState state)? goBuilder;
  Widget Function(BuildContext context, GoRouterState goState, Widget child)? shellBuilder;

  AppRoute({
    required this.path,
    required this.name,
    this.iconPath,
    this.data,
    this.routes = const [],
    this.shellBuilder,
    this.goBuilder,
  }) {
    if (shellBuilder == null && goBuilder == null) {
      assert(false, 'Either shellBuilder or goBuilder must be given');
    }
    if (shellBuilder != null && goBuilder != null) {
      assert(false, 'Both shellBuilder and goBuilder cannot be given');
    }
  }

  RouteBase generate() {
    return goBuilder != null
        ? GoRoute(
            path: path,
            name: name,
            routes: _genFullRoute(),
            pageBuilder: (context, state) => NoTransitionPage(child: goBuilder!(context, state)),
          )
        : ShellRoute(
            routes: _genFullRoute(),
            pageBuilder: (context, state, child) => NoTransitionPage(child: shellBuilder!(context, state, child)),
          );
  }

  List<RouteBase> _genFullRoute() {
    List<RouteBase> bases = [];
    for (final i in routes) {
      final rr = i.generate();
      bases.add(rr);
    }

    return bases;
  }

  List<String> getAllChildRoutes() {
    List<String> children = [];

    children.add(path);
    for (final i in routes) {
      children.add(i.path);
      children.addAll(i.getAllChildRoutes());
    }
    return children;
  }

  List<AppRoute> getAllChildRoutesAsAppRoute() {
    List<AppRoute> children = [];

    for (final i in routes) {
      children.add(i);
      children.addAll(i.getAllChildRoutesAsAppRoute());
    }

    return children;
  }
}
