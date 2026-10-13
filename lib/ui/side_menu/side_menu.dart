import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/ui/side_menu/widgets/menu_item_widget.dart';
import 'package:invently/ui/side_menu/widgets/menu_list.dart';
import 'package:invently/ui/side_menu/widgets/menu_overlay.dart';
import 'package:invently/widgets/elevation/elevation_widget.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  LayerLink link = LayerLink();

  ValueNotifier<MenuItemWidget?> appRouteNotifier = ValueNotifier(null);

  @override
  void dispose() {
    Future.delayed(Duration.zero, () => MenuOverlayModel.removeOverlay(appRouteNotifier));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: ShadowWidget(
        child: MenuList(
          expand: false,
          appRouteNotifier: appRouteNotifier,
          onExpandTap: expandMenu,
          onTap: navigate,
        ),
      ),
    );
  }

  void navigate(MenuItemWidget route) {
    // expanding if user is trying to navigate to same screen.
    if (AppNavigator.selectedRoute == route.route) {
      expandMenu();
      return;
    }

    if (route == appRouteNotifier.value) {
      expandMenu();
      return;
    }

    if (route.children.isNotEmpty &&
        MenuOverlayModel.isMenuOpen() &&
        route.route.name != appRouteNotifier.value?.route.name) {
      appRouteNotifier.value = route;
      return;
    }

    if (route.children.isNotEmpty) {
      appRouteNotifier.value = route;
      expandMenu();
      return;
    }

    // user clicked on a navigation possible item
    AppNavigator.navigate(route.route);
    MenuOverlayModel.removeOverlay(appRouteNotifier);
    setState(() {});
  }

  void expandMenu() {
    MenuOverlayModel.toggleMenu(
      context: context,
      navigate: navigate,
      link: link,
      appRouteNotifier: appRouteNotifier,
    );
  }
}
