import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;
  final Color? bgColor;
  final double size;
  final EdgeInsets padding;
  final bool transparentBg;
  const CustomProgressIndicator({
    super.key,
    this.color,
    this.bgColor,
    this.size = 40,
    this.transparentBg = true,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + padding.left + padding.right,
      height: size + padding.top + padding.bottom,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor ?? (transparentBg ? null : Tm.color(Tc.priDef)),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      child: SpinKitFadingCircle(
        size: size,
        itemBuilder: (context, i) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: color ?? (transparentBg ? Tm.color(Tc.priDef) : Tm.color(Tc.comCardBg)),
              shape: BoxShape.circle,
              border: color == null
                  ? Border.all(color: transparentBg ? Tm.color(Tc.comCardBg) : Tm.color(Tc.priDef), width: 0.5)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
