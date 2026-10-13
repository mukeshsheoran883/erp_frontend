
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/info_tool_tip.dart';
import 'package:flutter/material.dart';

class PasswordConstrainsWidget extends StatelessWidget {
  const PasswordConstrainsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const InfoToolTip(
          iconWidth: 20,
          message: '''Password must satisfy following conditions
• Minimum 8 character
Must include at least:
• 1 number
• 1 special character
• 1 uppercase letter
• 1 lowercase letter''',
        ),
        const SizedBox(width: 6),
        Text('Password constraints', style: Ts.mdRegular(color: Tm.color(Tc.ipfHint))),
      ],
    );
  }
}
