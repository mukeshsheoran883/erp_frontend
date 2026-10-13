import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/sales/return_item_model.dart';
import 'package:invently/network/employee_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/sales/return_item_service.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/ui/master/supplier/supplier_screen.dart';
import 'package:invently/ui/sales/return_item/add_retuurn_item/add_return_item_variables.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/increment_decrement_buttons.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/page_header_container.dart';
import 'package:invently/widgets/text_widget/price_text_field.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

part 'widget/add_return_functions.dart';
part 'widget/return_details_form.dart';

class AddEditReturnItemScreen extends StatefulWidget {
  final String? returnItemCode;

  const AddEditReturnItemScreen({super.key, required this.returnItemCode});

  @override
  State<AddEditReturnItemScreen> createState() => _AddEditReturnItemScreenState();
}

class _AddEditReturnItemScreenState extends State<AddEditReturnItemScreen> {
  AddReturnParams params = AddReturnParams();

  @override
  void initState() {
    _getReturnItem(this);
    // NOTE: breadcrumb route names below are guessed to match your AppRoutes
    // naming pattern (like purchase's AppRoutes.purchase / purchaseList / purchaseAdd / purchaseEdit).
    // Rename these if your actual route constants differ.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.returnItem,
        AppRoutes.returnedPurchaseList,
        if (widget.returnItemCode == null)
          AppRoutes.returnItemAdd
        else
          AppRoutes.returnItemEdit(data: AddEditReturnItemScreen(returnItemCode: widget.returnItemCode)),
      ]);
    });
    super.initState();
  }

  @override
  void dispose() {
    _dispose(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: params.returnItem.status == Status.loading
          ? const CustomProgressIndicator()
          : params.returnItem.status == Status.success
          ? _ReturnDetailsForm(state: this)
          : ErrorWidgetWithButton(
        onPressed: () => _getReturnItem(this),
        error: params.returnItem.error.errorMessage,
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}