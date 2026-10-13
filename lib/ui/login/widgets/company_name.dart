
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class CompanyName extends StatelessWidget {
  const CompanyName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgImage(Assets.images.logo, height: 38),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgImage(Assets.images.name,width: 200,),
              SvgImage(Assets.images.tagLine),
            ],
          ),
        ],
      ),
    );
  }
}
