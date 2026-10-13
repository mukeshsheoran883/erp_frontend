
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:provider/provider.dart';

class MenuFunctions {
  static Future<void> logoutTap() async {
    bool confirmed = false;

    await showDoubleButtonAlert(
      DoubleButtonAlertModel(
        onRightTap: () => {confirmed = true, AppNavigator.pop()},
        content: 'Are you sure you want to logout?',
        title: 'Confirm Logout?',
      ),
      canClose: true,
    );

    if (!confirmed) return;

    await handleFutureWithAlert(
      errorMessage: () => '',
      function: () async {
        await Globals.context().read<AuthenticationProvider>().logout(closeAllPopup: true);
        return Status.success;
      },
    );
    AppNavigator.navigate(AppRoutes.splash);
  }
}
