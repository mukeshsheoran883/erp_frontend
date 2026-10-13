import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showSingleButtonAlert({String? title, String? text, Function()? onDismiss}) async {
  return await showPopup(child: _NotificationUI(title: title, text: text, onDismiss: onDismiss));
}

class _NotificationUI extends StatelessWidget {
  final String? title;
  final String? text;
  final Function()? onDismiss;

  const _NotificationUI({required this.title, required this.text, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tm.color(Tc.comCardBg),
      width: context.percentWidth * 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogTitleBar(title: title ?? 'Alert'),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                text ?? '',
                style: TsDefined.ts18W400(),
                textAlign: (text ?? '').contains('•') ? TextAlign.left : TextAlign.center,
              ),
            ),
          ),
          AlertBottomButton(
            leftText: 'Ok',
            showLeftButton: true,
            onLeftTap: () => {AppNavigator.pop(), if (onDismiss != null) onDismiss!()},
          ),
        ],
      ),
    );
  }
}
