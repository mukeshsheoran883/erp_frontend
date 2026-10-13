
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function()? onDelTap;
  final EdgeInsets padding;

  const DeleteButton({super.key, required this.onDelTap, this.padding = const EdgeInsets.only(right: 16)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: HoverGD(
        onTap: onDelTap,
        tooltip: 'Delete',
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        builder: (context, bState) {
          return Container(
            height: 48,
            width: 48,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: Tm.color(Tc.iconButtonBgRed),
            ),
            child: SvgImage(
              Assets.icons.trash,
              width: 22,
              height: 22,
              color: onDelTap == null ? Tm.color(Tc.redActLight).withValues(alpha: 0.25) : Tm.color(Tc.redActLight),
            ),
          );
        },
      ),
    );
  }
}

class SquareIconButtonModel {
  Function()? onTap;
  String buttonIcon;
  String tooltip;
  EdgeInsets padding;
  Color? iconColor;
  Color? buttonBgColor;
  double iconSize;
  BoxDecoration? decoration;

  SquareIconButtonModel({
    required this.buttonIcon,
    required this.tooltip,
    this.onTap,
    this.padding = const EdgeInsets.only(right: 16),
    this.buttonBgColor,
    this.iconColor,
    this.iconSize = 22,
    this.decoration,
  });
}

class SquareIconButton extends StatelessWidget {
  final SquareIconButtonModel model;

  const SquareIconButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: model.padding,
      child: HoverGD(
        onTap: model.onTap,
        tooltip: model.tooltip,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 48,
          width: 48,
          padding: const EdgeInsets.all(12),
          decoration: model.decoration ??
              BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: model.buttonBgColor ?? Tm.color(Tc.redDefLight)),
              ),
          alignment: Alignment.center,
          child: SvgImage(
            model.buttonIcon,
            width: model.iconSize,
            height: model.iconSize,
            color: model.iconColor ?? Tm.color(Tc.redActLight),
          ),
        ),
      ),
    );
  }
}
