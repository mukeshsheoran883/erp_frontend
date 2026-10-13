
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/utils/app_version.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_snack_bar.dart';

class AppVersionText extends StatelessWidget {
  const AppVersionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 14.5),
      child: Container(
        width: 50,
        alignment: Alignment.center,
        child: GestureDetector(
          onDoubleTap: () => _copyInfo(context),
          child: Text(
            'V${StaticValues.isProduction ? 'R' : 'D'} ${AppVersionUtils.getAppVersion()}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TsDefined.ts10W400(color: Tm.color(Tc.menuItemDefTxt).withValues(alpha: 0.6)),
          ),
        ),
      ),
    );
  }

  String _getVersionMessage() {
    String version =
        'V${StaticValues.isProduction ? 'R' : 'D'} ${'${AppVersionUtils.getAppVersion()}+${AppVersionUtils.getBuildNumber()}'}';
    String organization = '';
    String user = '';
    String userCode = '';

    if (AuthenticationProvider.isLoggedIn) {
      organization = 'Organization: ${AuthenticationProvider.getUserDetailsStatic().organisationName}';
      user = 'User: ${AuthenticationProvider.getUserDetailsStatic().name}';
      userCode = 'UserCode: ${AuthenticationProvider.getUserDetailsStatic().employeeCode}';
    }

    return [
      version,
      if (organization.isNotEmpty) organization,
      if (user.isNotEmpty) user,
      if (userCode.isNotEmpty) userCode,
    ].join('\n');
  }

  Future<void> _copyInfo(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _getVersionMessage()));
    if (context.mounted) {
      AppSnackBar.showSnackBarWithText(text: 'App info copied', clickToOpen: false);
    }
  }
}
