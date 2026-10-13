
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewDetailsBottomButtons extends StatelessWidget {
  final List<ViewDetailsButtonModel> buttons;

  const ViewDetailsBottomButtons({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Tm.color(Tc.comCardBg),
        border: Border(top: BorderSide(color: Tm.color(Tc.tableDivider), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final i in buttons) _ButtonWidget(model: i),
        ],
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final ViewDetailsButtonModel model;

  const _ButtonWidget({required this.model});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: model.onTap,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      tooltip: model.tooltip,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: model.bgColor, borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: SvgImage(model.icon, height: 24, width: 24, color: model.iconColor),
      ),
    );
  }
}

class ViewDetailsButtonModel {
  final String icon;
  final String? tooltip;
  final Color iconColor;
  final Color bgColor;
  Function()? onTap;

  ViewDetailsButtonModel({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.iconColor,
    required this.bgColor,
  });

  static closeButton([Function()? onTap]) => ViewDetailsButtonModel(
        icon: Assets.icons.closeSquare,
        tooltip: 'Close',
        onTap: onTap ?? Globals.context().pop,
        iconColor: Tm.color(Tc.txtH4),
        bgColor: Tm.color(Tc.neuDef),
      );

  static deleteButton(Function()? onTap) => ViewDetailsButtonModel(
        icon: Assets.icons.trash,
        tooltip: 'Delete',
        onTap: onTap,
        iconColor: Tm.color(Tc.redActLight),
        bgColor: Tm.color(Tc.redDefLight).withValues(alpha: Tm.isDarkTheme.value ? 0.1 : 1),
      );

  static editButton(Function()? onTap) => ViewDetailsButtonModel(
        icon: Assets.icons.editIcon,
        tooltip: 'Edit',
        onTap: onTap,
        iconColor: Tm.color(Tc.priIconLight),
        bgColor: Tm.color(Tc.priDefLight),
      );
}
