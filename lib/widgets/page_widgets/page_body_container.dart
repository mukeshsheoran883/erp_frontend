
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class PageBodyContainer extends StatelessWidget {
  final Widget child;
  final Widget? bottomWidget;

  const PageBodyContainer({super.key, required this.child, this.bottomWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Tm.color(Tc.comCardBg),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: child,
            ),
          ),
        ),
        if (bottomWidget != null) bottomWidget!,
      ],
    );
  }
}
