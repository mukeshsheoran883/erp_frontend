
part of 'select_branch_section.dart';

Future<void> _getUserAndShops(_SelectBranchSectionState state) async {
  state.userLoadingError = '';
  state.userLoadingStatus = Status.loading;
  state.userModel = null;
  state.defaultShop = null;
  state.accessibleShops.value = [];
  state.defaultShopError = ValidationError.none();
  state.refresh();

  final apiResponse = await Future.wait([
    CommonApiServices.getCurrentUserDetails(
      employeeCode: state.widget.employeeCode,
      accessToken: state.widget.loginResponse.accessToken,
    ),
    ShopService.getShopList(accessToken: state.widget.loginResponse.accessToken),
  ]);

  ApiResponseModel<UserModel> userResponse = apiResponse[0] as ApiResponseModel<UserModel>;
  ApiResponseModel<List<ShopModel>> shopResponse = apiResponse[1] as ApiResponseModel<List<ShopModel>>;

  if (!userResponse.responseType.success || userResponse.data == null) {
    state.userLoadingError = userResponse.firstError();
    state.userLoadingStatus = Status.error;
    state.refresh();
    return;
  } else if (!shopResponse.responseType.success || shopResponse.data == null) {
    state.userLoadingError = shopResponse.firstError();
    state.userLoadingStatus = Status.error;
    state.refresh();
    return;
  }

  state.userModel = userResponse.data;
  state.accessibleShops.value =
      shopResponse.data!.map((e) => CommonKeyValueModel(id: e.shopCode, value: e.name.toPascalCase())).toList();
  state.defaultShop = state.accessibleShops.value.isEmpty ? null : state.accessibleShops.value.first;

  state.userLoadingStatus = Status.success;
  state.refresh();
}

Future<void> _saveUserDetailsAndLogin(_SelectBranchSectionState state, UserModel user, ShopModel currentShop) async {
  if (!state.mounted) return;

  state.defaultShopError.reset();
  state.refresh();

  if (!_validate(state)) {
    state.refresh();
    return;
  }

  final provider = state.context.read<AuthenticationProvider>();

  if (state.defaultShop != null) user.defaultShop = state.defaultShop!;
  await provider.saveUserDetails(
    role: state.widget.role,
    accessToken: state.widget.loginResponse.accessToken,
    refreshToken: state.widget.loginResponse.refreshToken,
    rememberMe: state.widget.rememberMe,
    user: user,
  );

  _navigateByRole(state.widget.role);
  AppSnackBar.showSnackBarWithText(text: 'Logged in successfully');
}

void _navigateByRole(String role) {
  switch (role) {
    case 'INVENTORY':
      AppNavigator.navigate(AppRoutes.posInventory);
      break;
    case 'DISPATCH':
      AppNavigator.navigate(AppRoutes.godown);
      break;
    case 'ADMIN':
    default:
      AppNavigator.navigate(AppRoutes.dashBoard);
      break;
  }
}

bool _validate(_SelectBranchSectionState state) {
  final isValid = Validator.validate(
    [
      ValidationModel<CommonKeyValueModel?>(
        error: state.defaultShopError,
        data: state.defaultShop,
        fieldName: 'Shop',
        validators: [FastRequiredValidation(customMessage: 'Please select any branch to continue')],
      ),
    ],
  );

  return isValid;
}
