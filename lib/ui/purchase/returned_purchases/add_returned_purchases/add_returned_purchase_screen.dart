import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/purchase_model.dart';
import 'package:invently/models/purchase/returned_purchases_model.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/network/returned_purchases_service.dart';
import 'package:invently/provider/purchase/purchase_provider.dart';
import 'package:invently/ui/purchase/returned_purchases/add_returned_purchases/add_returned_purchase_variables.dart';
import 'package:invently/ui/purchase/returned_purchases/add_returned_purchases/widget/add_returned_purchase_tile.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/page_header_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widget/add_returned_purchase_functions.dart';

part 'widget/purchase_returned_details_form.dart';

class AddEditReturnedPurchaseScreen extends StatefulWidget {
  final String? returnedPurchaseCode;

  const AddEditReturnedPurchaseScreen({super.key, required this.returnedPurchaseCode});

  @override
  State<AddEditReturnedPurchaseScreen> createState() => _AddEditReturnedPurchaseScreenState();
}

class _AddEditReturnedPurchaseScreenState extends State<AddEditReturnedPurchaseScreen> {
  AddReturnedPurchaseParams params = AddReturnedPurchaseParams();
  late PurchaseProvider provider;

  @override
  void initState() {
    _getPurchase(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.purchase,
        AppRoutes.returnedPurchaseList,
        if (widget.returnedPurchaseCode == null)
          AppRoutes.returnedPurchaseAdd
        else
          AppRoutes.returnedPurchaseEdit(
              data: AddEditReturnedPurchaseScreen(returnedPurchaseCode: widget.returnedPurchaseCode)),
      ]);
    });
    provider = context.read<PurchaseProvider>();
    provider.clearProvider();
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
      child: params.returnedPurchase.status == Status.loading
          ? const CustomProgressIndicator()
          : params.returnedPurchase.status == Status.success
              ? _ReturnedPurchaseDetailsForm(state: this)
              : ErrorWidgetWithButton(
                  onPressed: () => _getPurchase(this), error: params.returnedPurchase.error.errorMessage),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
