
import 'dart:ui';

import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';

Future<bool> showMultiDeletePopup({required MultiSelectModel model}) async {
  if (model.items.isEmpty) return false;
  bool confirmed = false;

  bool isMultiple = model.items.length > 1;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      title: 'Delete ${isMultiple ? model.pluralString : model.singleString}',
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content:
          'Are you sure you want to delete the following ${model.items.length} ${isMultiple ? model.pluralString : model.singleString}? This action cannot be undone.',
      multiContent: model.items,
      leftText: 'Close',
      rightText: 'Delete',
      rightButtonBg: Tm.color(Tc.redDef),
      rightIcon: SvgImage(Assets.icons.trash, color: Tm.color(Tc.comBtnTxt), width: 22, height: 22),
    ),
    canClose: true,
  );

  return confirmed;
}

class MultiSelectModel {
  List<String> items;
  String singleString;
  String pluralString;
  String actionWord;
  String? customBodyString;
  String? leftText;
  String? rightText;
  String? rightIcon;
  Color? rightButtonColor;

  MultiSelectModel({
    required this.items,
    required this.singleString,
    required this.pluralString,
    this.actionWord = 'action',
    this.customBodyString,
    this.rightIcon,
    this.leftText,
    this.rightText,
    this.rightButtonColor,
  });
}

Future<bool> showMultiActionPopup({required MultiSelectModel model}) async {
  if (model.items.isEmpty) return false;
  bool confirmed = false;

  bool isMultiple = model.items.length > 1;

  await showDoubleButtonAlert(
    DoubleButtonAlertModel(
      title: '${model.actionWord.toFirstLetterUpperCase()} ${isMultiple ? model.pluralString : model.singleString}',
      onRightTap: () => {confirmed = true, AppNavigator.pop()},
      content: model.customBodyString ??
          'Are you sure you want to ${model.actionWord.toLowerCase()} the following ${model.items.length} ${isMultiple ? model.pluralString : model.singleString}?',
      multiContent: model.items,
      leftText: (model.leftText ?? 'Close').toPascalCase(),
      rightText: (model.rightText ?? 'Delete').toPascalCase(),
      rightButtonBg: model.rightButtonColor ?? Tm.color(Tc.redDef),
      rightIcon: SvgImage(model.rightIcon ?? Assets.icons.trash, color: Tm.color(Tc.comBtnTxt), width: 22, height: 22),
    ),
    canClose: true,
  );

  return confirmed;
}
