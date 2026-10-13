import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  final String assetPath;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit fit;
  const SvgImage(this.assetPath, {super.key, this.color, this.height, this.width, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      height: height,
      width: width,
      key: key,
      fit: fit,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      semanticsLabel: assetPath,
    );
  }
}
