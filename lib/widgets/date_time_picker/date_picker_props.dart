import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class DatePickerProps {
  TextStyle? normalDayNumberStyle;
  TextStyle? selectedDayNumberStyle;
  TextStyle? disabledDayNumberStyle;
  TextStyle? todayNumberStyle;
  TextStyle? dayHeaderStyle;
  Color? selectedBgColor;

  DatePickerProps({
    this.normalDayNumberStyle,
    this.disabledDayNumberStyle,
    this.selectedDayNumberStyle,
    this.todayNumberStyle,
    this.selectedBgColor,
    this.dayHeaderStyle,
  }) {
    normalDayNumberStyle ??= _normal;
    disabledDayNumberStyle ??= _disabled;
    selectedDayNumberStyle ??= _selected;
    todayNumberStyle ??= _today;
    dayHeaderStyle ??= _dayHeader;
    selectedBgColor = Tm.color(Tc.comCardBg);
  }

  final TextStyle _normal = TsDefined.ts16W500(color: Tm.color(Tc.tabDefTxt));
  final TextStyle _selected = TsDefined.ts16W500(color: Tm.color(Tc.redDef));
  final TextStyle _disabled = TsDefined.ts16W500(color: Tm.color(Tc.priDef).withValues(alpha: 0.5));
  final TextStyle _today = TsDefined.ts16W600(color: Tm.color(Tc.priDef));
  final TextStyle _dayHeader = TsDefined.ts16W500(color: Tm.color(Tc.priIconLight));
}
