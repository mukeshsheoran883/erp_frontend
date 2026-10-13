
import 'package:flutter/cupertino.dart';

class CommonFunctions {
  static Future<void> removeTextSelection(
    TextEditingController controller, {
    Duration delay = const Duration(milliseconds: 50),
  }) async {
    try {
      await Future.delayed(
        delay,
        () => controller.selection =
            TextSelection(baseOffset: controller.text.length, extentOffset: controller.text.length),
      );
    } catch (_) {}
  }
}
