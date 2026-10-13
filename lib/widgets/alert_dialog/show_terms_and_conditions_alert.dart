
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/web_view.dart';
import 'package:flutter/material.dart';

Future<void> showTermsAndConditionsPopup({
  bool showAcceptButton = false,
  bool accepted = false,
  Function(bool)? onChange,
}) async {
  showPopup(child: _ShowDeleteDialog(accepted: accepted, showAcceptButton: showAcceptButton, onChange: onChange));
}

class _ShowDeleteDialog extends StatelessWidget {
  final bool showAcceptButton;
  final bool accepted;
  final Function(bool)? onChange;

  const _ShowDeleteDialog({required this.accepted, required this.showAcceptButton, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tm.color(Tc.comCardBg),
      width: context.percentWidth * 90,
      height: context.percentHeight * 95,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogTitleBar(title: 'Terms, Conditions and Privacy Policy', bottomHeight: 0),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: WebView(url: Endpoint.privacyPolicy()),
            ),
          ),
          AlertBottomButton(
            showUpperPadding: false,
            onLeftTap: () => AppNavigator.pop(),
            showRightButton: showAcceptButton,
            onRightTap: () => {AppNavigator.pop(), onChange?.call(!accepted)},
            rightText: '${accepted ? 'Decline' : 'Accept'} Terms, Conditions & Privacy Policy',
            rightBtnColor: Tm.color(accepted ? Tc.redActLight : Tc.grnActLight),
            rightIcon: SvgImage(
              accepted ? Assets.icons.danger : Assets.icons.checkSquare,
              height: 22,
              width: 22,
              color: Tm.color(Tc.comBtnTxt),
            ),
          ),
        ],
      ),
    );
  }
}
