import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/buttons/rounded_rect_button.dart';
import 'package:flutter/material.dart';

class AlertBottomButton extends StatelessWidget {
  final String leftText;
  final String? rightText;
  final Color? leftColor;
  final Color? rightColor;
  final Color? leftBtnColor;
  final Color? rightBtnColor;
  final Function()? onLeftTap;
  final Function()? onRightTap;
  final bool showLeftButton;
  final bool showRightButton;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final EdgeInsets leftIconPadding;
  final EdgeInsets rightIconPadding;
  final bool showContainerDecoration;
  final bool showUpperPadding;

  const AlertBottomButton({
    super.key,
    this.leftText = 'Close',
    this.rightText,
    this.onLeftTap,
    this.showLeftButton = true,
    this.onRightTap,
    this.showRightButton = true,
    this.leftColor,
    this.rightColor,
    this.leftBtnColor,
    this.rightBtnColor,
    this.leftIcon,
    this.rightIcon,
    this.leftIconPadding = const EdgeInsets.only(right: 4),
    this.rightIconPadding = const EdgeInsets.only(right: 4),
    this.showContainerDecoration = true,
    this.showUpperPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showUpperPadding) const SizedBox(height: 32),
        Container(width: double.infinity, height: 2, color: Tm.color(Tc.tableDivider)),
        Container(
          decoration: showContainerDecoration
              ? BoxDecoration(
                  color: Tm.color(Tc.comCardBg),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                )
              : null,
          height: 75,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showLeftButton)
                AlertButton(
                  text: leftText,
                  onTap: onLeftTap ?? () => AppNavigator.pop(),
                  color: leftColor ?? Tm.color(Tc.neuNeuBtnTxt),
                  buttonColor: leftBtnColor ?? Tm.color(Tc.neuDef),
                  icon: leftIcon ??
                      SvgImage(Assets.icons.closeSquare, height: 22, width: 22, color: Tm.color(Tc.neuNeuBtnTxt)),
                  iconPadding: leftIconPadding,
                ),
              if (showLeftButton && showRightButton && rightText != null) const SizedBox(width: 24),
              if (showRightButton && rightText != null)
                AlertButton(
                  text: rightText!,
                  onTap: onRightTap,
                  color: rightColor ?? Tm.color(Tc.comBtnTxt),
                  buttonColor: rightBtnColor,
                  icon: rightIcon ??
                      SvgImage(Assets.icons.arrowRightLong, height: 12, width: 12, color: Tm.color(Tc.comBtnTxt)),
                  iconPadding: rightIconPadding,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class AlertButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final TextStyle? style;
  final Color? color;
  final Color? buttonColor;
  final Widget? icon;
  final EdgeInsets iconPadding;
  final BoxBorder? border;

  const AlertButton({
    super.key,
    this.onTap,
    required this.text,
    this.color,
    this.buttonColor,
    this.icon,
    required this.iconPadding,
    this.style ,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return RRectButton(
      onTap: onTap,
      bgColor: buttonColor,
      height: 46,
      border: border,
      radius: const BorderRadius.all(Radius.circular(12)),
      style: Ts.rgMedium(color: color),
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Padding(padding: const EdgeInsets.only(right: 8), child: icon!),
            Text(text, style: style ?? Ts.rgMedium(color: color)),
          ],
        ),
      ),
      padding: iconPadding,
    );
  }
}
