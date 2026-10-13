
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTabBarTitle extends StatefulWidget {
  final List<String> titles;
  final TabController controller;

  const CustomTabBarTitle({super.key, required this.titles, required this.controller});

  @override
  State<CustomTabBarTitle> createState() => _CustomTabBarTitleState();
}

class _CustomTabBarTitleState extends State<CustomTabBarTitle> {
  List<GlobalKey> globalsKeys = [];
  bool showSelectedWidget = false;

  @override
  void initState() {
    globalsKeys = List.generate(widget.titles.length, (a) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSelectedWidget = true;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            children: [
              if (showSelectedWidget)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  width: _getWidth(),
                  height: 45,
                  left: _getLeftWidth(),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _getWidth(),
                        decoration: BoxDecoration(
                          color: Tm.colorSeparate(PC.colorPrimary100, PC.colorOpacityPur),
                          borderRadius:
                              const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                      ),
                      Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Tm.color(Tc.priDef),
                          borderRadius:
                              const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  for (int i = 0; i < widget.titles.length; i++)
                    _TabBarButton(
                      text: widget.titles[i],
                      key: globalsKeys[i],
                      selected: i == widget.controller.index,
                      onTap: () => widget.controller.animateTo(i),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _getWidth() {
    if (globalsKeys[widget.controller.index].currentContext == null) return 0;
    return (globalsKeys[widget.controller.index].currentContext!.findRenderObject() as RenderBox).size.width;
  }

  double _getLeftWidth() {
    double width = 0;
    for (int i = 0; i < widget.controller.index; i++) {
      width = width +
          (globalsKeys[i].currentContext == null
              ? 0
              : (globalsKeys[i].currentContext!.findRenderObject() as RenderBox).size.width);
    }

    return width;
  }
}

class _TabBarButton extends StatelessWidget {
  final String text;
  final bool selected;
  final Function() onTap;

  const _TabBarButton({super.key, required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverGD(
      onTap: onTap,
      hoverColor: Tm.color(Tc.hoverColor),
      clickColor: Tm.color(Tc.hoverColor),
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 2),
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Center(
            child: Text(
              text,
              style: Ts.lgRegular(
                color: selected ? Tm.colorSeparate(PC.colorPrimary500, PC.colorPrimary50) : Tm.color(Tc.tabDefTxt),
                fontStyle: selected ? FontStyle.italic : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
