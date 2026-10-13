import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class AlertTitleText extends StatelessWidget {
  final String title;
  final Color? titleColor;

  const AlertTitleText({required this.title, this.titleColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TsDefined.ts22W500(color: titleColor ?? Tm.color(Tc.redIconLight)),
      textAlign: TextAlign.center,
    );
  }
}
