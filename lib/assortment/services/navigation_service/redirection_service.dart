import 'dart:async';

import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/provider/common_functions_provider.dart';
import 'package:invently/widgets/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectionService {
  static FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    if (state.fullPath == null || (state.error != null)) {
      return AppRoutes.error.path;
    }

    if (TestScreen.showTestScreen) return AppRoutes.testScreen.path;

    /// Play splash as first route if not played
    if (!CommonFunctionsProvider.splashCompleted()) {
      return AppRoutes.splash.path;
    }

    /// Redirect to login if user is not logged in
    if (!AuthenticationProvider.isLoggedIn && !_routesAccessibleWithoutLogin.contains(state.fullPath)) {
      return AppRoutes.login.path;
    }

    /// Redirect to home path if splash is played once and again user tires to navigate to splash
    if (CommonFunctionsProvider.splashCompleted() && AppRoutes.splash.path == state.fullPath!) {
      return AppRoutes.home.path;
    }

    /// Actual path user tried to navigate
    return state.fullPath;
  }

  static final List<String> _routesAccessibleWithoutLogin = [
    AppRoutes.loginBranchSelection(data: null).path,
    AppRoutes.forgotPasswordEmailSection.path,
    AppRoutes.forgotPasswordResetSection(data: null).path,
    AppRoutes.activateAccount.path,
    AppRoutes.createAccountPassword(data: null).path,
  ];
}
