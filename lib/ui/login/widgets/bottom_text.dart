
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/show_terms_and_conditions_alert.dart';
import 'package:flutter/material.dart';

class BottomText extends StatelessWidget {
  const BottomText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _ClickableText(text: '©${DateTime.now().year} ${StaticValues.companyName}  All rights reserved', onTap: null),
          _ClickableText(text: 'Privacy Policy ', onTap: () => showTermsAndConditionsPopup(showAcceptButton: false)),
          _ClickableText(text: 'Terms & Conditions', onTap: () => showTermsAndConditionsPopup(showAcceptButton: false)),
        ],
      ),
    );
  }
}

class _ClickableText extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const _ClickableText({required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: HoverGD(
          onTap: onTap,
          tooltip: text,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Ts.smLight(color: Tm.color(Tc.txtH4)),
                ),
                if (onTap != null) Container(height: 1, color: Tm.color(Tc.txtH4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
