
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class BrokenImageWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const BrokenImageWidget({super.key, this.size = 36, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: SvgImage(
        Assets.icons.imageBroken,
        width: size,
        height: size,
        color: color ?? Tm.color(Tc.ipfTitle),
      ),
    );
  }
}
