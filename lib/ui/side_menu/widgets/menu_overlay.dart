
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/ui/side_menu/widgets/menu_item_widget.dart';
import 'package:invently/ui/side_menu/widgets/menu_list.dart';
import 'package:invently/ui/side_menu/widgets/sub_menu_item.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/elevation/elevation_widget.dart';
import 'package:flutter/material.dart';

class MenuOverlayModel {
  static OverlayEntry? _overlay;

  static void removeOverlay(ValueNotifier<MenuItemWidget?> appRouteNotifier) {
    if (_overlay == null || !_overlay!.mounted) return;

    try {
      _overlay!.remove();
    } catch (_) {
      debugPrint('Overlay removing threw an exception');
    }
    appRouteNotifier.value = null;
  }

  static bool isMenuOpen() {
    if (_overlay == null || !_overlay!.mounted) return false;
    return true;
  }

  static void toggleMenu({
    required BuildContext context,
    required ValueNotifier<MenuItemWidget?> appRouteNotifier,
    required void Function(MenuItemWidget) navigate,
    required LayerLink link,
  }) {
    if (_overlay == null || !_overlay!.mounted) {
      _showMenuOverlay(
        context: context,
        onExpandTap: () => removeOverlay(appRouteNotifier),
        navigate: navigate,
        link: link,
        appRouteNotifier: appRouteNotifier,
      );
    } else {
      removeOverlay(appRouteNotifier);
    }
  }

  static void _showMenuOverlay({
    required BuildContext context,
    required void Function() onExpandTap,
    required void Function(MenuItemWidget) navigate,
    required LayerLink link,
    required ValueNotifier<MenuItemWidget?> appRouteNotifier,
  }) async {
    if (_overlay != null && _overlay!.mounted) _overlay!.remove();

    _overlay = OverlayEntry(
      builder: (context) {
        return _MenuExpanded(
          link: link,
          navigate: navigate,
          onExpandTap: onExpandTap,
          removeOverlay: () => removeOverlay(appRouteNotifier),
          appRouteNotifier: appRouteNotifier,
        );
      },
    );

    Overlay.of(context).insert(_overlay!);
  }
}

class _MenuExpanded extends StatefulWidget {
  final LayerLink link;
  final void Function() onExpandTap;
  final void Function() removeOverlay;
  final void Function(MenuItemWidget) navigate;
  final ValueNotifier<MenuItemWidget?> appRouteNotifier;
  const _MenuExpanded({
    required this.link,
    required this.navigate,
    required this.onExpandTap,
    required this.removeOverlay,
    required this.appRouteNotifier,
  });

  @override
  State<_MenuExpanded> createState() => _MenuExpandedState();
}

class _MenuExpandedState extends State<_MenuExpanded> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CompositedTransformFollower(
          link: widget.link,
          showWhenUnlinked: false,
          child: ShadowWidget(
            child: MenuList(
              appRouteNotifier: widget.appRouteNotifier,
              expand: true,
              onTap: widget.navigate,
              onExpandTap: widget.onExpandTap,
            ),
          ),
        ),
        _ExpandedRoute(
          appRouteNotifier: widget.appRouteNotifier,
          removeOverlay: widget.removeOverlay,
          navigate: widget.navigate,
        ),
        Expanded(child: GestureDetector(onTap: widget.removeOverlay, child: Container(color: Colors.transparent))),
      ],
    );
  }
}

class _ExpandedRoute extends StatelessWidget {
  final ValueNotifier<MenuItemWidget?> appRouteNotifier;
  final void Function() removeOverlay;
  final void Function(MenuItemWidget) navigate;
  const _ExpandedRoute({required this.appRouteNotifier, required this.removeOverlay, required this.navigate});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MenuItemWidget?>(
      valueListenable: appRouteNotifier,
      builder: (context, route, child) {
        if (route == null || route.children.isEmpty) return const SizedBox();

        return ShadowWidget(
          child: Container(
            width: 224,
            height: context.percentHeight * 100,
            color: Tm.color(Tc.menuItemBgFill),
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            route.route.name.toPascalCase(),
                            style: Ts.rgSemibold(color: Tm.color(Tc.txtH2)),
                          ),
                          const Spacer(),
                          HoverGD(
                            onTap: removeOverlay,
                            builder: (context, state) {
                              return Container(
                                height: 24,
                                width: 24,
                                color: Colors.transparent,
                                child: SvgImage(
                                  Assets.icons.closeSquare,
                                  color: state.isHovering ? Tm.color(Tc.closeRed) : Tm.color(Tc.txtH4),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(height: 1, color: Tm.color(Tc.tableDivider)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                for (final i in route.children)
                  i.runtimeType == MenuItemWidget
                      ? SubMenuItem(
                          menu: i as MenuItemWidget,
                          appRouteNotifier: appRouteNotifier,
                          route: i.route,
                          onTap: navigate,
                        )
                      : i,
              ],
            ),
          ),
        );
      },
    );
  }
}
