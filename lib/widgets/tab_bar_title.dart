
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTabBarTitleRounded extends StatefulWidget {
  final List<String> titles;
  final int selectedIndex;
  final Function(int) onTap;
  final double tabHeight;

  const CustomTabBarTitleRounded({
    super.key,
    required this.titles,
    required this.selectedIndex,
    required this.onTap,
    this.tabHeight = 60,
  });

  @override
  State<CustomTabBarTitleRounded> createState() => _CustomTabBarTitleRoundedState();
}

class _CustomTabBarTitleRoundedState extends State<CustomTabBarTitleRounded> {
  final animationDuration = const Duration(milliseconds: 300);
  final animationCurve = Curves.easeInOut;
  int tabIndex = 0;

  TextStyle style = Ts.rgMedium(color: Tm.color(Tc.tabDefTxt));

  TextStyle selectedStyle = Ts.rgMedium(color: Tm.colorSeparate(PC.colorPrimary500, PC.colorPrimary50));
  final BorderRadius radius = const BorderRadius.all(Radius.circular(12));

  @override
  void initState() {
    tabIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTabBarTitleRounded oldWidget) {
    super.didUpdateWidget(oldWidget);
    tabIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.tabHeight,
      decoration: BoxDecoration(color: null, borderRadius: radius),
      child: ClipRRect(
        child: Stack(
          children: [
            AnimatedAlign(
              duration: animationDuration,
              curve: animationCurve,
              alignment: FractionalOffset(1 / (widget.titles.length - 1) * tabIndex, 0),
              child: Container(
                height: widget.tabHeight,
                decoration: BoxDecoration(color: Tm.color(Tc.iconContainerFillPurple), borderRadius: radius),
                child: FractionallySizedBox(widthFactor: 1 / widget.titles.length),
              ),
            ),
            Row(
              children: [
                for (int i = 0; i < widget.titles.length; i++)
                  Expanded(
                    child: HoverGD(
                      onTap: () => widget.onTap(i),
                      hoverColor: Colors.transparent,
                      clickColor: Colors.transparent,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.titles[i],
                          style: i == widget.selectedIndex ? selectedStyle : style,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
