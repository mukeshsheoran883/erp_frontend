import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/network/brand_service.dart';
import 'package:invently/provider/master/create/brand_provider.dart';
import 'package:invently/ui/master/create/widgets/brand/add_brand/add_brand_variables.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/alert_title_bar.dart';
import 'package:invently/widgets/alert_dialog/show_dialog.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

part 'widget/add_brand_functions.dart';
part 'widget/brand_personal_details.dart';

Future<void> showCustomBrandScreen({
  required String title,
  String brandName = '',
  String brandCode = '',
  required String buttonName,
}) async {
  return await showPopup(
    child: AddEditBrandScreen(title: title, brandName: brandName, brandCode: brandCode, buttonName: buttonName),
  );
}

class AddEditBrandScreen extends StatefulWidget {
  final String title;
  final String buttonName;
  final String brandName;
  final String? brandCode;

  const AddEditBrandScreen({
    super.key,
    required this.title,
    required this.brandName,
    required this.brandCode,
    required this.buttonName,
  });

  @override
  State<AddEditBrandScreen> createState() => _AddEditBrandScreenState();
}

class _AddEditBrandScreenState extends State<AddEditBrandScreen> {
  AddBrandParams params = AddBrandParams();

  @override
  void initState() {
    _getBrand(this);
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
          AlertDialogTitleBar(title: widget.title),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: widget.buttonName == 'Delete'
                  ? Text(
                      'Are you sure want to delete this brand? Please note that this action can’t be on done.',
                      style: TsDefined.ts18W400(),
                      textAlign:
                          ('Are you sure want to delete this brand? Please note that this action can’t be on done.')
                                  .contains('•')
                              ? TextAlign.left
                              : TextAlign.center,
                    )
                  : _BrandDetailsForm(state: this),
            ),
          ),
          AlertBottomButton(
            leftText: 'Close',
            onLeftTap: () => _close(),
            onRightTap: () => widget.buttonName == 'Delete'
                ? _onDeleteTap(this, context)
                : (widget.brandName.isNotEmpty ? _onSaveChangeTap(this, context) : _onSaveTap(this, context)),
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
