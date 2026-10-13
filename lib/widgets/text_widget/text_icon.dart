
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final String icon;
  final Function()? onTap;
  final double width;
  final double height;
  final Color? iconColor;

  const TextIcon({
    super.key,
    required this.icon,
    this.onTap,
    this.width = 24,
    this.height = 24,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: HoverGD(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(6),
          width: width,
          height: height,
          child: SvgImage(icon, color: iconColor),
        ),
      ),
    );
  }
}
