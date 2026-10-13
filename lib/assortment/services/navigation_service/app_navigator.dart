part of 'navigation_service.dart';

/// [AppNavigator] is used for the Navigation in the application.
/// [navigate] function is used to navigate to different screens.
/// [router] is the [GoRouter] instance for the router.
/// [selectedRoute] is the current selected route of the application.
abstract class AppNavigator {
  static AppRoute selectedRoute = AppRoutes.splash;
  static List<AppRoute> allRoutes = AppRoutes.baseWindow.getAllChildRoutesAsAppRoute();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash.path,
    navigatorKey: Globals.navigatorKey,
    errorBuilder: (a, b) => BaseWindowScreen(child: ErrorScreen(state: b)),
    redirect: RedirectionService.redirect,
    routes: [AppRoutes.splash.generate(), AppRoutes.testScreen.generate(), AppRoutes.baseWindow.generate()],
  );

  static void navigate(AppRoute route, {GoType type = GoType.go}) {
    if (route.shellBuilder != null) {
      navigate(route.routes.first, type: type);
    } else {
      switch (type) {
        case GoType.go:
          Globals.context().go(route.path, extra: route.data);
        case GoType.push:
          Globals.context().push(route.path, extra: route.data);
        case GoType.pushReplace:
          Globals.context().pushReplacement(route.path, extra: route.data);
      }
    }

    updateSelectedRoute();
  }

  static void pop<T>([T? data]) {
    GoRouter.of(Globals.context()).routerDelegate.pop();
    updateSelectedRoute(pop: true);
  }

  static void updateSelectedRoute({bool pop = false}) {
    AppRoute? r = allRoutes.firstWhereOrNull(
      (e) =>
          (pop
              ? GoRouter.of(Globals.context()).routerDelegate.currentConfiguration.last.matchedLocation
              : GoRouter.of(Globals.context()).routeInformationProvider.value.uri.path) ==
          e.path,
    );

    if (r != null) selectedRoute = r;
  }

  static final ValueNotifier<List<BreadCrumb>> _breadCrumbs = ValueNotifier([]);

  static setBreadCrumbs(List<AppRoute> routes) {
    List<BreadCrumb> crumbs = [];
    for (final i in routes) {
      crumbs.add(BreadCrumb(route: i, onTap: () => navigate(i)));
    }
    _breadCrumbs.value = crumbs;
  }

  static addBreadCrumbs(AppRoute route) {
    _breadCrumbs.value.add(BreadCrumb(route: route, onTap: () => navigate(route)));
  }

  static ValueNotifier<List<BreadCrumb>> getBreadCrumbs() => _breadCrumbs;

  static final ValueNotifier<bool> showBreadCrumb = ValueNotifier(true);
}

enum GoType { go, push, pushReplace }
