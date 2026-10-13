import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  final String? message;
  final Widget child;
  const CustomTooltip({super.key, this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message ?? '',
      waitDuration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        color: Tm.color(Tc.secDefLight).withValues(alpha: 0.8),
        border: Border.all(color: Tm.color(Tc.tableDivider), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      textStyle: TsDefined.ts14W400(color: Tm.color(Tc.ipfTitle)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
      child: child,
    );
  }
}
