import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/alert_title_text.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

class AlertDialogTitleBar extends StatelessWidget {
  final String? title;
  final Function()? onCloseTap;
  final bool showCloseIcon;
  final EdgeInsets titlePadding;
  final double bottomHeight;

  const AlertDialogTitleBar({
    super.key,
    required this.title,
    this.onCloseTap,
    this.showCloseIcon = true,
    this.bottomHeight = 32,
    this.titlePadding = const EdgeInsets.only(left: 32),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration:
              BoxDecoration(color: Tm.color(Tc.comCardBg), borderRadius: const BorderRadius.all(Radius.circular(12))),
          margin: const EdgeInsets.symmetric(vertical: 14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                if (showCloseIcon) const SizedBox(width: 27, height: 27),
                if (title != null)
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AlertTitleText(title: title!),
                      ),
                    ),
                  ),
                if (showCloseIcon)
                  HoverGD(
                    onTap: onCloseTap ?? AppNavigator.pop,
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
          ),
        ),
        Container(width: double.infinity, height: 2, color: Tm.color(Tc.tableDivider)),
        SizedBox(height: bottomHeight),
      ],
    );
  }
}
