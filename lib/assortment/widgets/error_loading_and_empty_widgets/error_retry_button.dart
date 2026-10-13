import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/buttons/rounded_rect_button.dart';
import 'package:flutter/material.dart';

class ErrorWidgetWithButton extends StatelessWidget {
  final Function()? onPressed;
  final String? assetImagePath;
  final String? error;
  final String? buttonLabel;
  final Color? imageColor;
  final double height;
  final double padding;
  final double? imageSize;

  const ErrorWidgetWithButton({
    required this.onPressed,
    this.assetImagePath,
    required this.error,
    this.buttonLabel,
    this.imageColor,
    this.height = 30,
    this.padding = 30,
    this.imageSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ErrorImage(imageSize: imageSize),
            SizedBox(height: height),
            Text(
              error ?? StaticValues.commonErrorMessage,
              textAlign: TextAlign.center,
              style: TsDefined.ts15W600(color: Tm.color(Tc.txtH3)),
            ),
            if (onPressed != null) SizedBox(height: height),
            if (onPressed != null)
              Container(
                width: 140,
                alignment: Alignment.center,
                child: RRectButton(
                  text: buttonLabel ?? 'Retry',
                  onTap: () => onPressed!(),
                  bgColor: Colors.transparent,
                  style: Ts.rgBold(color: Tm.color(Tc.priDef)),
                  border: Border.all(color: Tm.color(Tc.priDef), width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorImage extends StatelessWidget {
  final double? imageSize;

  const _ErrorImage({required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageSize ?? context.percentWidth * 20,
      height: imageSize ?? context.percentWidth * 20,
      child: FittedBox(
        child: Row(
          children: [
            SvgImage(Assets.images.errorChar1),
            SvgImage(Assets.images.errorChar2),
          ],
        ),
      ),
    );
  }
}
