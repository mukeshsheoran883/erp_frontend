import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/purchase_model.dart';
import 'package:invently/network/employee_service.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/provider/purchase/purchase_provider.dart';
import 'package:invently/ui/purchase/purchase_list/add_purchase/add_purchase_variables.dart';
import 'package:invently/ui/purchase/purchase_list/add_purchase/widget/add_purchase_tile.dart';
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

part 'widget/add_purchase_functions.dart';
part 'widget/purchase_details_form.dart';

class AddEditPurchaseScreen extends StatefulWidget {
  final String? purchaseCode;

  const AddEditPurchaseScreen({super.key, required this.purchaseCode});

  @override
  State<AddEditPurchaseScreen> createState() => _AddEditPurchaseScreenState();
}

class _AddEditPurchaseScreenState extends State<AddEditPurchaseScreen> {
  AddPurchaseParams params = AddPurchaseParams();
  late PurchaseProvider provider;

  @override
  void initState() {
    _getPurchase(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.purchase,
        AppRoutes.purchaseList,
        if (widget.purchaseCode == null)
          AppRoutes.purchaseAdd
        else
          AppRoutes.purchaseEdit(data: AddEditPurchaseScreen(purchaseCode: widget.purchaseCode)),
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
      child: params.purchase.status == Status.loading
          ? const CustomProgressIndicator()
          : params.purchase.status == Status.success
              ? _PurchaseDetailsForm(state: this)
              : ErrorWidgetWithButton(onPressed: () => _getPurchase(this), error: params.purchase.error.errorMessage),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
