part of 'colors.dart';

abstract class Tm {
  static ValueNotifier<bool> isDarkTheme = ValueNotifier(false);

  static const String _themeSavingKey = 'appThemeSaveKey';

  static Future<void> changeTheme({required bool isDarkMode}) async {
    isDarkTheme.value = isDarkMode;
    await SecureStorageHelper.saveBool(key: _themeSavingKey, dataToStore: isDarkTheme.value);
    Future.delayed(const Duration(milliseconds: 100), () => AppNavigator.navigate(AppRoutes.home));
  }

  static Future<void> retrieveTheme() async {
    isDarkTheme.value = await SecureStorageHelper.getBool(key: _themeSavingKey) ?? false;
  }

  static Color color(AppColor color) {
    return isDarkTheme.value ? color.dark : color.light;
  }

  static Color colorSeparate(Color light, Color dark) {
    return isDarkTheme.value ? dark : light;
  }
}
