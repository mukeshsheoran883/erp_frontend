import 'package:flutter/material.dart';

class CommonFunctionsProvider extends ChangeNotifier {
  static bool _splashCompleted = false;
  static void setSplashCompleted(bool a) => _splashCompleted = a;
  static bool splashCompleted() => _splashCompleted;

  // static bool _scale = false;
  // bool getScale() => _scale;

  void clearProvider() {
    _splashCompleted = false;
  }

  // void toggleScale(bool scale) {
  //   _scale = !_scale;
  //   SecureStorageHelper.saveBool(dataToStore: _scale, key: StaticKeys.scaleKey());
  //   notifyListeners();
  // }

  // static Future<void> retrieveAutoScaleKey() async {
  //   _scale = (await SecureStorageHelper.getBool(key: StaticKeys.scaleKey())) ?? false;
  // }
}
