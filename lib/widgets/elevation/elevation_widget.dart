import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class ShadowWidget extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color? shadowColor;
  final BoxShape shape;
  final BorderRadius? radius;
  final bool disable;

  const ShadowWidget({
    required this.child,
    this.elevation = 5,
    this.shadowColor,
    this.radius,
    this.disable = false,
    this.shape = BoxShape.rectangle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (disable) return child;

    return PhysicalModel(
      elevation: elevation,
      shadowColor: shadowColor ?? Tm.colorSeparate(PC.colorSecondary100, PC.colorPrimary600),
      color: Colors.transparent,
      shape: shape,
      borderRadius: radius,
      child: child,
    );
  }
}
