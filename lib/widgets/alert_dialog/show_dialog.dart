import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

Future<T?> showPopup<T>({required Widget child, bool canClose = false, Color? barrierColor}) async {
  barrierColor ??= Tm.isDarkTheme.value ? Colors.black26 : Colors.black12;

  return await showDialog(
    context: Globals.context(),
    barrierColor: barrierColor,
    barrierDismissible: canClose,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        side: Tm.isDarkTheme.value ? BorderSide(color: Tm.color(Tc.tableDivider), width: 2) : BorderSide.none,
      ),
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(24)), child: child),
    ),
  );
}
