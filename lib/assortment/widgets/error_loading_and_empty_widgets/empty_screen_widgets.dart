import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class ListEmptyWidget extends StatelessWidget {
  final String? text;
  final String? buttonLabel;
  final Function()? onTap;
  final String? assetImagePath;
  final double textSize;
  final Color? svgImgColor;
  final double verticalSpacing;
  final double imageSize;

  const ListEmptyWidget({
    this.buttonLabel,
    this.text,
    this.onTap,
    this.assetImagePath,
    this.verticalSpacing = 30,
    this.svgImgColor,
    this.textSize = 18,
    this.imageSize = 215,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.8,
                child: SvgImage(
                  assetImagePath ?? Assets.images.noData,
                  color: svgImgColor,
                  height: imageSize,
                  width: imageSize,
                ),
              ),
              SizedBox(height: verticalSpacing),
              Text(
                text ?? 'No Items Found',
                textAlign: TextAlign.center,
                style: TsDefined.ts16W400(),
              ),
              SizedBox(height: verticalSpacing * 2),
              if (buttonLabel != null)
                Container(
                  width: context.percentWidth * 25,
                  alignment: Alignment.center,
                  child: HoverGD(
                    onTap: onTap ?? () => {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Tm.color(Tc.priDef),
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(buttonLabel!, style: TsDefined.ts14W400(color: Tm.color(Tc.comBg))),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
