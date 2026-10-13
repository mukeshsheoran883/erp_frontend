
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

class MenuItemWidget extends StatefulWidget {
  final AppRoute route;
  final Function(MenuItemWidget)? onTap;
  final ValueNotifier<MenuItemWidget?> appRouteNotifier;
  final bool expand;
  final List<Widget> children;
  const MenuItemWidget({
    super.key,
    required this.route,
    required this.onTap,
    this.children = const [],
    required this.expand,
    required this.appRouteNotifier,
  });

  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool selected = false;

  @override
  void initState() {
    selected = _selected(widget.route, widget.children);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MenuItemWidget oldWidget) {
    selected = _selected(widget.route, widget.children);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 14.5, right: widget.expand ? 14.5 : 0),
      child: HoverGD(
        onTap: widget.onTap == null ? null : () => widget.onTap?.call(widget),
        builder: (context, state) {
          return ValueListenableBuilder<MenuItemWidget?>(
            valueListenable: widget.appRouteNotifier,
            builder: (context, openRoute, child) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 224),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                    if (widget.expand)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            widget.route.name.toPascalCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Ts.rgRegular(color: selected ? Tm.color(Tc.comBtnTxt) : Tm.color(Tc.menuItemDefTxt)),
                          ),
                        ),
                      ),
                    if (widget.expand)
                      SvgImage(
                        Assets.icons.arrowRight,
                        width: 8,
                        color: widget.children.isEmpty
                            ? Colors.transparent
                            : selected
                                ? Tm.color(Tc.comBtnTxt)
                                : Tm.color(Tc.menuItemDefTxt).withValues(alpha: 0.8),
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
    if (selectedRoute == route || route.getAllChildRoutesAsAppRoute().contains(selectedRoute)) return true;

    return false;
  }
}
