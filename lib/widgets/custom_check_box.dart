
import 'package:invently/assortment/widgets/check_box_base.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final void Function(bool)? onChange;
  final double width;
  const CustomCheckBox({super.key, required this.isChecked, required this.onChange, this.width = 24});

  @override
  Widget build(BuildContext context) {
    return CheckboxBase(
      value: isChecked,
      onChanged: onChange == null ? null : (a) => onChange?.call(a ?? false),
      checkColor: Tm.color(Tc.comCardBg),
      checkedBorderSide: BorderSide(color: Tm.color(Tc.priDef)),
      unCheckedBorderSide: BorderSide(color: Tm.color(Tc.stepperInaTxt)),
      checkedFillColor: Tm.color(Tc.priDef),
      unCheckedFillColor: Tm.color(Tc.comCardBg),
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      width: width,
    );
  }
}
