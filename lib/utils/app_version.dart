import 'package:package_info_plus/package_info_plus.dart';

class AppVersionUtils {
  static String _appVersion = '';
  static String _buildNumber = '';

  static Future<void> loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  static String getAppVersion() => _appVersion;

  static String getBuildNumber() => _buildNumber;
}
