
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/popup_menu/show_custom_menu.dart';
import 'package:flutter/material.dart';

Future<void> showAppMenu({
  required AppMenuParams params,
  required List<Widget> Function(Function() close) childrenBuilder,
}) async {
  await showCustomMenu(
    params: params,
    childBuilder: (closeFunction) => Container(
      decoration: BoxDecoration(
        color: Tm.color(Tc.comCardBg),
        borderRadius: const BorderRadius.all(Radius.circular(8 + 6)),
        border: Tm.isDarkTheme.value ? Border.all(color: Tm.color(Tc.tableDivider), width: 2) : null,
      ),
      padding: const EdgeInsets.all(6),
      child: Column(mainAxisSize: MainAxisSize.min, children: childrenBuilder(closeFunction)),
    ),
  );
}

class AppMenuButtons {
  static Widget viewButton(Function()? onTap) => HoverGD(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          width: 203,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text('View', style: Ts.rgRegular(color: Tm.color(Tc.dropItemDefTxt))),
        ),
      );

  static Widget editButton(Function()? onTap) => HoverGD(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          width: 203,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text('Edit', style: Ts.rgRegular(color: Tm.color(Tc.dropItemDefTxt))),
        ),
      );

  static Widget deleteButton(Function()? onTap) => HoverGD(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          width: 203,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text('Delete', style: Ts.rgRegular(color: Tm.color(Tc.dropItemDefTxt))),
        ),
      );

  static Widget divider() => Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
        decoration: BoxDecoration(color: Tm.color(Tc.tableDivider)),
        width: 203,
      );

  static Widget textButton({required String text, Function()? onTap}) => HoverGD(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          width: 203,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(text, style: Ts.rgRegular(color: Tm.color(Tc.dropItemDefTxt))),
        ),
      );
}

class AppMenuParams {
  LayerLink link;
  Offset buttonPosition;
  Size buttonSize;

  AppMenuParams({required this.link, required this.buttonPosition, required this.buttonSize});
}
