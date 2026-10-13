import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class AdjustableShadowWidget extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color? shadowColor;
  final BoxShape shape;
  final BorderRadius? radius;
  final double spread;
  final double blur;
  final Offset? offset;

  const AdjustableShadowWidget({
    required this.child,
    this.elevation = 5,
    this.shadowColor,
    this.radius,
    this.shape = BoxShape.rectangle,
    this.blur = 7,
    this.spread = 5,
    this.offset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Tm.color(Tc.secFoc),
            spreadRadius: 5,
            blurRadius: 7,
            offset: offset ?? const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
