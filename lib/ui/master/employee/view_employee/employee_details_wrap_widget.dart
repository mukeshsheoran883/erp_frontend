import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsWrapWidget extends StatelessWidget {
  final List<String> items;
  final Color? bgColor;

  const EmployeeDetailsWrapWidget({super.key, required this.items, this.bgColor});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('_', style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt)));
    }

    return Wrap(
      runSpacing: 12,
      spacing: 6,
      children: [for (final i in items) _Widget(text: i, color: bgColor)],
    );
  }
}

class _Widget extends StatelessWidget {
  final String text;
  final Color? color;

  const _Widget({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Tm.color(Tc.secDefLight),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Text(text.toFirstLetterUpperCase(), style: TsDefined.ts15W400(color: Tm.color(Tc.txtH2))),
    );
  }
}
