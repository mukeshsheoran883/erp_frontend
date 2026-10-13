
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';

class DetailsValueName extends StatelessWidget {
  final String label;
  final Widget? child;
  final String? childText;
  final bool removeColon;

  const DetailsValueName({super.key, required this.label, this.child, this.childText, this.removeColon = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            color: Tm.color(Tc.tableDivider),
            child: Text('$label${removeColon ? '' : ' :'}', style: TsDefined.ts15W400(color: Tm.color(Tc.txtH3))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: child ??
                SelectableText(
                  (childText == null || childText!.trim().isEmpty) ? '_' : childText!,
                  style: Ts.rgRegular(color: Tm.color(Tc.ipfTxt)),
                ),
          ),
        ],
      ),
    );
  }
}
