import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/tax/tax_model.dart';
import 'package:invently/network/tax_service.dart';
import 'package:invently/provider/master/create/tax_provider.dart';
import 'package:invently/ui/master/create/widgets/tax/add_tax/add_tax_variables.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

part 'widget/add_tax_functions.dart';
part 'widget/tax_details.dart';

Future<void> showAddTaxPopup({
  required String title,
  String taxName = '',
  String taxCode = '',
  String totalTax = '',
  String tax = '',
  required String buttonName,
}) async {
  return await showPopup(
    child: AddEditTaxScreen(
      title: title,
      taxName: taxName,
      taxCode: taxCode,
      tax: tax,
      totalTax: totalTax,
      buttonName: buttonName,
    ),
  );
}

class AddEditTaxScreen extends StatefulWidget {
  final String title;
  final String buttonName;
  final String totalTax;
  final String taxName;
  final String tax;
  final String taxCode;

  const AddEditTaxScreen({
    super.key,
    required this.title,
    required this.taxName,
    required this.tax,
    required this.totalTax,
    required this.taxCode,
    required this.buttonName,
  });

  @override
  State<AddEditTaxScreen> createState() => _AddEditTaxScreenState();
}

class _AddEditTaxScreenState extends State<AddEditTaxScreen> {
  AddTaxParams params = AddTaxParams();

  @override
  void initState() {
    _getTax(this);
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
            title: widget.title,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: widget.buttonName == 'Delete'
                  ? Text(
                      'Are you sure want to delete this tax? Please note that this action can’t be on done.',
                      style: TsDefined.ts18W400(),
                      textAlign:
                          ('Are you sure want to delete this tax? Please note that this action can’t be on done.')
                                  .contains('•')
                              ? TextAlign.left
                              : TextAlign.center,
                    )
                  : _TaxDetailsForm(
                      state: this,
                    ),
            ),
          ),
          AlertBottomButton(
            leftText: 'Close',
            onLeftTap: () => _close(),
            onRightTap: () => widget.buttonName == 'Delete'
                ? _onDeleteTap(this, context)
                : (widget.taxName.isNotEmpty ? _onSaveChangeTap(this, context) : _onSaveTap(this, context)),
            rightText: widget.buttonName,
            rightBtnColor: widget.buttonName == 'Delete' ? Tm.color(Tc.redActLight) : null,
            rightIcon: SvgImage(
              widget.buttonName == 'Delete' ? Assets.icons.trash : Assets.icons.checkSquare,
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
