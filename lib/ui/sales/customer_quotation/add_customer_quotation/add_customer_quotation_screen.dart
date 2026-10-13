import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/customer/customer_model.dart';
import 'package:invently/models/customer/customer_quotation_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/customer/customer_quotation_service.dart';
import 'package:invently/network/customer/customer_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/ui/sales/customer_quotation/add_customer_quotation/add_branch_variables.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/increment_decrement_buttons.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';

part 'widget/add_customer_quotation_functions.dart';
part 'widget/customer_quotation_details_form.dart';

class AddEditCustomerQuotationsScreen extends StatefulWidget {
  final String? customerQuotationCode;

  const AddEditCustomerQuotationsScreen({
    super.key,
    required this.customerQuotationCode,
  });

  @override
  State<AddEditCustomerQuotationsScreen> createState() => _AddEditCustomerQuotationsScreenState();
}

class _AddEditCustomerQuotationsScreenState extends State<AddEditCustomerQuotationsScreen> {
  AddCustomerQuotationParams params = AddCustomerQuotationParams();
  static final Map<String, CustomerModel> customerCache = {};


  @override
  void initState() {
    _getCustomerQuotation(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.sales, AppRoutes.customerQuotationsList,
        if (widget.customerQuotationCode == null)
          AppRoutes.customerQuotationsAdd
        else
          AppRoutes.customerQuotationsEdit(
            data: AddEditCustomerQuotationsScreen(customerQuotationCode: widget.customerQuotationCode),
          ),
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
    return PageBodyContainer(
      child: Center(
        child: params.customerQuotation.status == Status.loading
            ? const CustomProgressIndicator()
            : params.customerQuotation.status == Status.success
            ? Column(
          children: [
            Expanded(child: _CustomerQuotationDetailsForm(state: this)),
            CreateEditButtons(
              onCancelTap: () => _onCloseTap(this),
              onSaveTap: () => _onSaveTap(this),
              isEdit: true,
            ),
          ],
        )
            : ErrorWidgetWithButton(
          onPressed: () => _getCustomerQuotation(this),
          error: params.customerQuotation.error.errorMessage,
        ),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}