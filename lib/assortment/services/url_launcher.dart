
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static const String _errorString = 'Failed to open requested resource';

  static Future<bool> launch(Uri url, {bool showErrorToast = true}) async {
    if (!await canLaunchUrl(url)) {
      if (showErrorToast) AppSnackBar.showSnackBarWithText(text: _errorString);
      return false;
    }

    try {
      return await launchUrl(url);
    } catch (_) {
      if (showErrorToast) AppSnackBar.showSnackBarWithText(text: _errorString);
      return false;
    }
  }
}
