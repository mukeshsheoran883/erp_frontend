
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/services/navigation_service/app_route_model.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

import 'menu_item_widget.dart';

class SubMenuItem extends StatefulWidget {
  final MenuItemWidget menu;
  final AppRoute route;
  final Function(MenuItemWidget)? onTap;
  final ValueNotifier<MenuItemWidget?> appRouteNotifier;
  const SubMenuItem({super.key, required this.menu, required this.route, this.onTap, required this.appRouteNotifier});

  @override
  State<SubMenuItem> createState() => _SubMenuItemState();
}

class _SubMenuItemState extends State<SubMenuItem> {
  bool selected = false;

  @override
  void initState() {
    selected = _selected(widget.route, widget.menu.children);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SubMenuItem oldWidget) {
    selected = _selected(widget.route, widget.menu.children);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: HoverGD(
        onTap: widget.onTap == null ? null : () => widget.onTap?.call(widget.menu),
        builder: (context, state) {
          return ValueListenableBuilder<MenuItemWidget?>(
            valueListenable: widget.appRouteNotifier,
            builder: (context, openRoute, child) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: selected
                      ? Tm.color(Tc.menuItemActFill)
                      : openRoute?.route == widget.route
                          ? Tm.color(Tc.menuItemSubActFill).withValues(alpha: 0.8)
                          : state.isHovering
                              ? Tm.color(Tc.menuItemSubActFill).withValues(alpha: 0.4)
                              : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 26,
                      height: 26,
                      child: SvgImage(
                        widget.route.iconPath ?? Assets.icons.danger,
                        width: 26,
                        height: 26,
                        color: selected ? Tm.color(Tc.comBtnTxt) : Tm.color(Tc.menuItemDefTxt).withValues(alpha: 0.6),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          widget.route.name.toPascalCase(),
                          style: Ts.rgRegular(color: selected ? Tm.color(Tc.comBtnTxt) : Tm.color(Tc.menuItemDefTxt)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _selected(AppRoute route, List<Widget> children) {
    final selectedRoute = AppNavigator.selectedRoute;

    return (route == selectedRoute || route.getAllChildRoutesAsAppRoute().contains(selectedRoute));
  }
}
