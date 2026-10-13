
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:flutter/material.dart';

class CreateEditButtons extends StatelessWidget {
  final bool isEdit;
  final Function() onCancelTap;
  final Function() onSaveTap;

  const CreateEditButtons({super.key, this.isEdit = false, required this.onCancelTap, required this.onSaveTap});

  @override
  Widget build(BuildContext context) {
    return AlertBottomButton(
      onLeftTap: onCancelTap,
      onRightTap: onSaveTap,
      rightText: isEdit ? 'Save Changes' : 'Save',
      leftIcon: SvgImage(Assets.icons.closeSquare, height: 22, width: 22, color: Tm.color(Tc.neuNeuBtnTxt)),
      rightIcon: SvgImage(Assets.icons.checkSquare, height: 22, width: 22, color: Tm.color(Tc.comBtnTxt)),
    );
  }
}
