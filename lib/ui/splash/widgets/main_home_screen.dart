
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/ui/side_menu/side_menu.dart';
import 'package:invently/ui/side_menu/widgets/menu_functions.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/bread_crumbs/bread_crumbs.dart';
import 'package:invently/widgets/buttons/rounded_rect_button.dart';
import 'package:invently/widgets/profile_tile/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'main_home_screen_functions.dart';

class MainHomeScreen extends StatefulWidget {
  final Widget child;

  const MainHomeScreen({super.key, required this.child});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  ApiParam<UserModel> employee = ApiParam<UserModel>();

  @override
  void initState() {
    _getUserDetails(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return employee.status == Status.loading
        ? const CustomProgressIndicator()
        : employee.status == Status.success
            ? Row(
                children: [
                  const SideMenu(),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: AppNavigator.showBreadCrumb,
                              builder: (context, showBreadCrumbs, child) {
                                return ValueListenableBuilder(
                                  valueListenable: AppNavigator.getBreadCrumbs(),
                                  builder: (context, crumbs, child) {
                                    return showBreadCrumbs ? BreadCrumbs(crumbs: crumbs) : const SizedBox();
                                  },
                                );
                              },
                            ),
                            const Spacer(),
                            const ProfileTile(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(child: widget.child),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorWidgetWithButton(onPressed: () => _getUserDetails(this), error: employee.error.errorMessage),
                  RRectButton(
                    width: 140,
                    height: 44,
                    onTap: MenuFunctions.logoutTap,
                    bgColor: Tm.color(Tc.redActLight),
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 26,
                          height: 26,
                          child: SvgImage(
                            Assets.icons.logout,
                            width: 16,
                            height: 16,
                            color: Tm.color(Tc.comBtnTxt).withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: Ts.rgRegular(color: Tm.color(Tc.comBtnTxt).withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
