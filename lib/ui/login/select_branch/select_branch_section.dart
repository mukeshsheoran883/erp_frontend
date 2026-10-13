
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/cached_image.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/shop/shop_model.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/models/user/login_model.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/network/shops_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/ui/login/widgets/back_to_login_button.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/rounded_rect_button.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:fast_validator/fast_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'select_branch_function.dart';

class SelectBranchSection extends StatefulWidget {
  final String employeeCode;
  final String role;
  final LoginResponseModel loginResponse;
  final bool rememberMe;
  const SelectBranchSection({
    super.key,
    required this.employeeCode,
    required this.rememberMe,
    required this.loginResponse,
    required this.role,
  });

  @override
  State<SelectBranchSection> createState() => _SelectBranchSectionState();
}

class _SelectBranchSectionState extends State<SelectBranchSection> {
  Status userLoadingStatus = Status.loading;
  String userLoadingError = '';
  UserModel? userModel;
  CommonKeyValueModel? defaultShop;
  ValidationError defaultShopError = ValidationError.none();
  ValueNotifier<List<CommonKeyValueModel>> accessibleShops = ValueNotifier([]);

  @override
  void initState() {
    _getUserAndShops(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userLoadingStatus == Status.loading
        ? const CustomProgressIndicator()
        : userLoadingStatus == Status.success
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ImageAndNameWidget(user: userModel!),
                  const SizedBox(height: 46),
                  CustomDropdown(
                    items: accessibleShops,
                    selected: defaultShop,
                    error: defaultShopError.errorMessage,
                    hintText: 'Select branch',
                    emptyMessage: 'No accessible branches found',
                    onSelected: (a) => {defaultShop = a, defaultShopError.reset(), refresh()},
                  ),
                  const SizedBox(height: 6),
                  RRectButton(
                    text: 'Continue',
                    height: 44,
                    onTap: () => _saveUserDetailsAndLogin(this, userModel!, ShopModel.fromJson({})),
                  ),
                  const SizedBox(height: 46),
                  const BackToLoginButton(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorWidgetWithButton(error: userLoadingError, onPressed: () => _getUserAndShops(this)),
                  const BackToLoginButton(),
                ],
              );
  }

  void refresh() => mounted ? setState(() => {}) : null;
}

class _ImageAndNameWidget extends StatelessWidget {
  final UserModel user;

  const _ImageAndNameWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: CachedImage(
            url: user.profilePhotoUrl,
            height: 66,
            width: 66,
            errorWidget: Container(
              width: 66,
              height: 66,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Tm.color(Tc.tableLine2)),
              child: SvgImage(Assets.icons.person, height: 40, width: 40, color: Tm.color(Tc.txtH4)),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${user.name.toPascalCase()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Ts.xl3Semibold(color: Tm.color(Tc.txtH2)),
              ),
              Text(
                'Select Your Branch to Continue',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Ts.rgRegular(color: Tm.color(Tc.txtH3)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
