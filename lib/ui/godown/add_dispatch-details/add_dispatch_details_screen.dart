import 'package:go_router/go_router.dart';
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/network/pos/pos_service.dart';
import 'package:invently/provider/ops/pos_provider.dart';
import 'package:invently/ui/godown/add_dispatch-details/add_dispatch-details_variables.dart';
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


part 'widget/add_dispatch_details_functions.dart';
part 'widget/dispatch_details.dart';

Future<void> showAddDispatchDetailsPopup({
  required int posId,
  required String posCode,
  String buttonName = 'Submit',
}) async {
  return await showPopup(
    child: AddDispatchDetailsScreen(
      posId: posId,
      posCode: posCode,
      buttonName: buttonName,
    ),
  );
}

class AddDispatchDetailsScreen extends StatefulWidget {
  final int posId;
  final String posCode;
  final String buttonName;

  const AddDispatchDetailsScreen({
    super.key,
    required this.posId,
    required this.posCode,
    required this.buttonName,
  });

  @override
  State<AddDispatchDetailsScreen> createState() =>
      _AddDispatchDetailsScreenState();
}

class _AddDispatchDetailsScreenState extends State<AddDispatchDetailsScreen> {
  AddDispatchDetailsParams params = AddDispatchDetailsParams();

  @override
  void initState() {
    _getDispatchDetails(this);
    super.initState();
  }

  @override
  void dispose() {
    _dispose(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Tm.color(Tc.comCardBg),
      width: context.percentWidth * 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertDialogTitleBar(
            title: 'Dispatch Details — ${widget.posCode}',
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: _DispatchDetailsForm(state: this),
            ),
          ),
          AlertBottomButton(
            leftText: 'Close',
            onLeftTap: () => _close(),
            onRightTap: () => _onSubmitTap(this, context),
            rightText: widget.buttonName,
            rightIcon: SvgImage(
              Assets.icons.checkSquare,
              height: 22,
              width: 22,
              color: Tm.color(Tc.comBtnTxt),
            ),
          ),
        ],
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;

  void _close() => mounted ? context.pop() : null;
}