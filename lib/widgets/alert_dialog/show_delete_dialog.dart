import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteAlert({required String title, required String text, Function()? onDismiss}) async {
  return await showPopup(child: _ShowDeleteDialog(title: title, text: text, onDismiss: onDismiss));
}

class _ShowDeleteDialog extends StatelessWidget {
  final String? title;
  final String? text;
  final Function()? onDismiss;

  const _ShowDeleteDialog({required this.title, required this.text, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tm.color(Tc.comCardBg),
      width: context.percentWidth * 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogTitleBar(title: 'Delete $title'),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                'Are you sure want to delete this $text? Please note that this action can’t be on done.',
                style: TsDefined.ts18W400(),
                textAlign: ('Are you sure want to delete this $text? Please note that this action can’t be on done.')
                        .contains('•')
                    ? TextAlign.left
                    : TextAlign.center,
              ),
            ),
          ),
          AlertBottomButton(
            leftText: 'Close',
            onLeftTap: () => AppNavigator.pop(),
            onRightTap: () => {AppNavigator.pop(), if (onDismiss != null) onDismiss!()},
            rightText: 'Delete',
            rightBtnColor: Tm.color(Tc.redActLight),
            rightIcon: SvgImage(Assets.icons.trash, height: 22, width: 22, color: Tm.color(Tc.comBtnTxt)),
          ),
        ],
      ),
    );
  }
}
