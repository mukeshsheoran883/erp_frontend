import 'package:invently/assortment/helpers/db.dart';
import 'package:invently/assortment/helpers/secure_storage_helper.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/provider/common_functions_provider.dart';
import 'package:invently/provider/provider_register.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/static_keys.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthenticationProvider extends ChangeNotifier {
  static bool get isLoggedIn =>
      _accessToken.isNotEmpty &&
      _refreshToken.isNotEmpty &&
      _role.isNotEmpty &&
      _userDetail.organisationName.trim().isNotEmpty &&
      _userDetail.employeeCode.trim().isNotEmpty &&
      _userDetail.emailId.trim().isNotEmpty;

  static String getAccessToken() => _accessToken;
  static String getRefreshToken() => _refreshToken;
  static String getRole() => _role;
  static UserModel getUserDetailsStatic() => _userDetail;
  UserModel getUserDetails() => _userDetail;

  bool rememberUser() => _rememberUser;

  static String _accessToken = '';
  static String _refreshToken = '';
  static UserModel _userDetail = UserModel.fromJson({});
  static bool _rememberUser = false;
  static String _role = '';

  Future<void> saveUserDetails({
    required String role,
    required String accessToken,
    required String refreshToken,
    required UserModel user,
    required bool rememberMe,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userDetail = user;
    _role = role;
    _rememberUser = rememberMe;

    if (rememberMe) {
      await SecureStorageHelper.saveString(key: StaticKeys.accessTokenLocation(), dataToStore: accessToken);
      await SecureStorageHelper.saveString(key: StaticKeys.role(), dataToStore: role);
      await SecureStorageHelper.saveString(key: StaticKeys.refreshTokenLocation(), dataToStore: refreshToken);
      await SecureStorageHelper.saveBool(key: StaticKeys.rememberUserKey(), dataToStore: rememberMe);
      await CommonDB().saveValue(key: StaticKeys.usersDataKey(), value: user.toJsonForDb());
    }

    notifyListeners();
  }

  Future<void> updateCurrentUser(UserModel user, CommonKeyValueModel? newShop) async {
    CommonKeyValueModel shop =
        newShop ?? CommonKeyValueModel(id: _userDetail.defaultShop.id, value: _userDetail.defaultShop.value);

    _userDetail = user;
    _userDetail.defaultShop = shop;

    if (_rememberUser) {
      await CommonDB().saveValue(key: StaticKeys.usersDataKey(), value: _userDetail.toJsonForDb());
    }
    notifyListeners();
  }

  Future<void> saveNewAccessToken({required String accessToken}) async {
    if (rememberUser()) {
      await SecureStorageHelper.saveString(key: StaticKeys.accessTokenLocation(), dataToStore: accessToken);
    }
    _accessToken = accessToken;
    notifyListeners();
  }

  static Future<void> retrieveUserData() async {
    _accessToken = (await SecureStorageHelper.getString(key: StaticKeys.accessTokenLocation())) ?? '';
    _refreshToken = (await SecureStorageHelper.getString(key: StaticKeys.refreshTokenLocation())) ?? '';
    _role = (await SecureStorageHelper.getString(key: StaticKeys.role())) ?? '';
    _rememberUser = (await SecureStorageHelper.getBool(key: StaticKeys.rememberUserKey())) ?? false;

    final userData = await CommonDB().getValue(key: StaticKeys.usersDataKey());
    if (userData != null) _userDetail = UserModel.fromJson(userData);
  }

  Future<bool> logout({bool closeAllPopup = true}) async {
    if (closeAllPopup) {
      try {
        while (GoRouter.of(Globals.context()).canPop()) {
          GoRouter.of(Globals.context()).pop();
        }
      } catch (a) {
        Globals.logger.log(a.toString());
      }
    }

    ProviderRegister.clearProviders();
    final bool isDarkTheme = Tm.isDarkTheme.value;
    await SecureStorageHelper.clearAll();
    await DB.clearAllDB();
    CommonFunctionsProvider.setSplashCompleted(true);
    await Tm.changeTheme(isDarkMode: isDarkTheme);
    notifyListeners();

    return true;
  }

  void clearProvider() {
    _accessToken = '';
    _refreshToken = '';
    _role = '';
    _userDetail = UserModel.fromJson({});
    _rememberUser = false;
  }
}
