import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/bread_crumbs/widgets/bread_crumb.dart';
import 'package:flutter/material.dart';

class BreadCrumbs extends StatefulWidget {
  final List<BreadCrumb> crumbs;

  const BreadCrumbs({super.key, required this.crumbs});

  @override
  State<BreadCrumbs> createState() => _BreadCrumbsState();
}

class _BreadCrumbsState extends State<BreadCrumbs> {
  @override
  Widget build(BuildContext context) {
    if (widget.crumbs.isEmpty) return const SizedBox();

    return SizedBox(
      height: 68,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.crumbs.last.route.name.toPascalCase(),
            style: Ts.xl2Medium(color: Tm.color(Tc.txtH1)),
          ),
          Flexible(
            child: ValueListenableBuilder<bool>(
              valueListenable: Tm.isDarkTheme,
              builder: (context, value, child) {
                return ListView.builder(
                  key: Key(value.toString()),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.crumbs.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        if (index == 0)
                          HoverGD(
                            onTap: enableBackButton() ? () => _navigateToPreviousScreen() : null,
                            child: SvgImage(
                              Assets.icons.arrowLeftSquare,
                              width: 20,
                              height: 20,
                              color: enableBackButton()
                                  ? Tm.color(Tc.breadcrumbsDefTxt)
                                  : Tm.color(Tc.breadcrumbsDefTxt).withValues(alpha: 0.4),
                            ),
                          ),
                        widget.crumbs[index],
                        if (index != widget.crumbs.length - 1)
                          SvgImage(
                            Assets.icons.arrowRight,
                            width: 6,
                            height: 13,
                            color: Tm.color(Tc.breadcrumbsDefTxt),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool enableBackButton() {
    if (widget.crumbs.length < 2) return false;
    return true;
  }

  void _navigateToPreviousScreen() {
    final route = widget.crumbs[widget.crumbs.length - 2];
    route.onTap?.call();
  }
}
