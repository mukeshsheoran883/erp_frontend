
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/buttons/rounded_rect_button.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String text;
  final Function()? onTap;

  const AddButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return RRectButton(
      height: 48,
      width: 198,
      onTap: onTap,
      bgColor: Tm.color(Tc.priDef),
      disabledBgColor: Tm.color(Tc.priDisLight),
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgImage(Assets.icons.addSquare, width: 24, height: 24, color: Tm.color(Tc.comBtnTxt)),
          const SizedBox(width: 12),
          Text(text, style: Ts.rgMedium(color: Tm.color(Tc.comBtnTxt))),
        ],
      ),
    );
  }
}
