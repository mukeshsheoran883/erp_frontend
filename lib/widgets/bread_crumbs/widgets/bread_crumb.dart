import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/services/navigation_service/app_route_model.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class BreadCrumb extends StatelessWidget {
  final Function()? onTap;
  final AppRoute route;

  const BreadCrumb({super.key, required this.route, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: HoverGD(
        onTap: onTap,
        child: Text(
          route.name.toPascalCase(),
          style: Ts.mdRegular(color: Tm.color(Tc.breadcrumbsDefTxt)),
        ),
      ),
    );
  }
}
