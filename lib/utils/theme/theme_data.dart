import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

final ThemeData commonThemeData = ThemeData(
  scaffoldBackgroundColor: Tm.color(Tc.comBg),
  dialogTheme: const DialogThemeData(
    surfaceTintColor: Colors.transparent,
  ),
  scrollbarTheme: ScrollbarThemeData(
    thumbVisibility: WidgetStateProperty.all(false),
  ),
);