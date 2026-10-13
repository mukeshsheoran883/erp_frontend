
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RRectButton extends StatelessWidget {
  final String? text;
  final Widget? widget;
  final void Function()? onTap;
  final Color? bgColor;
  final Color? disabledBgColor;
  final TextStyle? style;
  final BorderRadius radius;
  final double? height;
  final double? width;
  final EdgeInsets padding;
  final BoxBorder? border;
  const RRectButton({
    super.key,
    this.text,
    this.onTap,
    this.bgColor,
    this.disabledBgColor,
    this.style,
    this.height,
    this.width,
    this.border,
    this.radius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.all(4),
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        padding: padding,
        decoration: BoxDecoration(color: _getColor(), border: border, borderRadius: radius),
        child: widget ??
            Text(
              text ?? '',
              style: style ?? Ts.rgMedium(color: Tm.color(Tc.comBtnTxt)),
            ),
      ),
    );
  }

  Color _getColor() {
    if (onTap == null && disabledBgColor != null) return disabledBgColor!;

    return bgColor ?? Tm.color(Tc.priDef);
  }
}
