
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class ViewDetailsTitle extends StatelessWidget {
  final String title;
  final Widget? middleWidget;

  const ViewDetailsTitle({super.key, required this.title, this.middleWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 20, top: 20, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  title,
                  style: TsDefined.ts22W500(color: Tm.color(Tc.txtH2)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (middleWidget != null) middleWidget!,
          HoverGD(
            onTap: AppNavigator.pop,
            builder: (context, state) {
              return SvgImage(
                Assets.icons.closeSquare,
                color: state.isHovering ? Tm.color(Tc.closeRed) : Tm.color(Tc.txtH4),
                width: 27,
                height: 27,
              );
            },
          ),
        ],
      ),
    );
  }
}
