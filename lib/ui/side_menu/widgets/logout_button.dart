
import 'package:invently/assortment/widgets/button/hover_button_base.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/ui/side_menu/widgets/menu_functions.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final bool expand;

  const LogoutButton({super.key, required this.expand});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 14.5, right: expand ? 14.5 : 0),
      child: HoverGD(
        onTap: MenuFunctions.logoutTap,
        builder: (context, state) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 224),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: state.isHovering ? Tm.color(Tc.menuItemSubActFill).withValues(alpha: 0.4) : null,
            ),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              children: [
                SizedBox(
                  width: 26,
                  height: 26,
                  child: SvgImage(
                    Assets.icons.logout,
                    width: 16,
                    height: 16,
                    color: Tm.color(Tc.menuItemDefTxt).withValues(alpha: 0.6),
                  ),
                ),
                if (expand) const SizedBox(width: 10),
                if (expand)
                  Text(
                    'Logout',
                    style: Ts.rgRegular(color: Tm.color(Tc.menuItemDefTxt).withValues(alpha: 0.8)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
