
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class ThemeSwitch extends StatelessWidget {
  final bool expanded;
  final Color? bgColor;
  final Color? buttonInsideColor;

  const ThemeSwitch({super.key, required this.expanded, this.bgColor, this.buttonInsideColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 14.5, right: expanded ? 2 : 0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 224),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: bgColor ?? Tm.color(Tc.toggleMainFrameBg),
        ),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            AdvancedSwitch(
              controller: Tm.isDarkTheme,
              initialValue: Tm.isDarkTheme.value,
              onChanged: (a) => Tm.changeTheme(isDarkMode: a),
              inactiveColor: Tm.color(Tc.toggleDefFill),
              activeColor: buttonInsideColor ?? Tm.color(Tc.toggleDefFill),
              thumb: ValueListenableBuilder<bool>(
                valueListenable: Tm.isDarkTheme,
                builder: (BuildContext context, bool value, Widget? child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Tm.colorSeparate(PC.colorBaseWhite, PC.colorNeutral800),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: SvgImage(
                        value ? Assets.icons.moon : Assets.icons.sun,
                        color: Tm.color(Tc.txtH3),
                        key: Key(value.toString()),
                      ),
                    ),
                  );
                },
              ),
              // borderRadius: const BorderRadius.all(Radius.circular(99)),
              height: 26,
              width: 42,
            ),
            if (expanded) const SizedBox(width: 10),
            if (expanded)
              Text(
                Tm.isDarkTheme.value ? 'Dark Theme' : 'Light Theme',
                style: Ts.rgRegular(color: Tm.color(Tc.menuItemDefTxt).withValues(alpha: 0.8)),
              ),
          ],
        ),
      ),
    );
  }
}
