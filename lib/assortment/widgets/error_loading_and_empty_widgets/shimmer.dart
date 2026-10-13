import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Color? baseColor;
  final Color? highlightColor;
  final double? height;
  final double? width;
  final BorderRadius radius;
  final BoxShape? shape;

  const ShimmerWidget({
    super.key,
    this.baseColor,
    this.highlightColor,
    this.height,
    this.width,
    this.radius = BorderRadius.zero,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Tm.isDarkTheme.value;
    Color finalBaseColor = baseColor ?? (isDarkTheme ? PC.colorNeutral800 : const Color.fromRGBO(245, 242, 242, 1));

    final Color finalHighlightColor =
        highlightColor ?? (isDarkTheme ? PC.colorNeutral900 : const Color.fromRGBO(255, 255, 255, 1));

    return Shimmer.fromColors(
      baseColor: finalBaseColor,
      highlightColor: finalHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: shape != null
            ? BoxDecoration(color: finalBaseColor, shape: shape!)
            : BoxDecoration(color: finalBaseColor, borderRadius: radius),
      ),
    );
  }
}
