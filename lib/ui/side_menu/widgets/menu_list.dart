import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/ui/side_menu/widgets/logout_button.dart';
import 'package:invently/ui/side_menu/widgets/theme_switch.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/app_version_text.dart';
import 'package:flutter/material.dart';

import 'menu_item_widget.dart';

class MenuList extends StatelessWidget {
  final Function(MenuItemWidget)? onTap;
  final void Function()? onExpandTap;
  final ValueNotifier<MenuItemWidget?> appRouteNotifier;
  final bool expand;

  const MenuList({
    super.key,
    this.onTap,
    required this.appRouteNotifier,
    required this.expand,
    this.onExpandTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tm.color(Tc.menuItemBgFill),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 32),
            child: HoverGD(
              onTap: onExpandTap,
              child: SvgImage(
                Assets.images.logo,
                width: 55,
              ),
            ),
          ),
          if (AuthenticationProvider.getRole() == 'INVENTORY')
            MenuItemWidget(
              route: AppRoutes.posInventory,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
            ),
          if (AuthenticationProvider.getRole() == 'DISPATCH')
            MenuItemWidget(
              route: AppRoutes.godown,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
            ),
          if (AuthenticationProvider.getRole() == 'ADMIN') ...[
            MenuItemWidget(
              route: AppRoutes.dashBoard,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
            ),
            MenuItemWidget(
              route: AppRoutes.master,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
              children: [
                MenuItemWidget(
                  route: AppRoutes.items,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.suppliers,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.branch,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.customers,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.employee,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.create,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
              ],
            ),
            MenuItemWidget(
              route: AppRoutes.administration,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
            ),
            MenuItemWidget(
              route: AppRoutes.inventory,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
            ),
            MenuItemWidget(
              route: AppRoutes.sales,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
              children: [
                MenuItemWidget(
                  route: AppRoutes.customerQuotation,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.pos,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.billHistory,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.returnItem,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
              ],
            ),
            MenuItemWidget(
              route: AppRoutes.quotations,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
            ),
            MenuItemWidget(
              route: AppRoutes.printerTemplates,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
            ),
            MenuItemWidget(
              route: AppRoutes.purchase,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
              children: [
                MenuItemWidget(
                  route: AppRoutes.purchaseList,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.returnedPurchaseList,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.stockAvailableList,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.stockTransfer,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
              ],
            ),
            MenuItemWidget(
              route: AppRoutes.reports,
              onTap: onTap,
              expand: expand,
              appRouteNotifier: appRouteNotifier,
              children: [
                MenuItemWidget(
                  route: AppRoutes.generalReport,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.overviewReport,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.administrationReport,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.dayBookReport,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
                MenuItemWidget(
                  route: AppRoutes.gstReport,
                  onTap: onTap,
                  expand: expand,
                  appRouteNotifier: appRouteNotifier,
                ),
              ],
            ),
          ],
          const Spacer(),
          ThemeSwitch(expanded: expand),
          LogoutButton(expand: expand),
          const SizedBox(height: 16),
          const AppVersionText(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
