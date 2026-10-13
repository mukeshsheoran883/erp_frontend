import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/utils/file_utils.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/models/common/custom_image_model.dart';
import 'package:invently/models/common/file_upload_response_model.dart';
import 'package:invently/models/customer/customer_model.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/models/sales/bill_history_model.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/network/customer/customer_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/sales/bill_history_service.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/ui/master/customer/add_customer/add_customer_variables.dart';
import 'package:invently/ui/sales/bill_history/add_invoice/add_invoice_variables.dart';
import 'package:invently/utils/static_keys.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/buttons/increment_decrement_buttons.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/form_widgets/country_drop_down.dart';
import 'package:invently/widgets/form_widgets/file_picker_and_display_widget.dart';
import 'package:invently/widgets/form_widgets/phone_number_field.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/form_widgets/state_drop_down.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/price_text_field.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

part 'widget/add_invoice_functions.dart';
part 'widget/invoice_personal_details.dart';

class AddEditInvoiceScreen extends StatefulWidget {
  final String? invoiceCode;

  const AddEditInvoiceScreen({
    super.key,
    required this.invoiceCode,
  });

  @override
  State<AddEditInvoiceScreen> createState() => _AddEditInvoiceScreenState();
}

class _AddEditInvoiceScreenState extends State<AddEditInvoiceScreen> {
  TabController? tabController;

  AddInvoiceParams params = AddInvoiceParams();

  // Caches full item objects fetched during search, keyed by itemCode
  static final Map<String, ItemModel> itemCache = {};

  // Caches full customer objects fetched during search, keyed by customerCode
  static final Map<String, CustomerModel> customerCache = {};

  @override
  void initState() {
    _getBill(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.sales, AppRoutes.billHistory, AppRoutes.billAdd]);
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
        child: params.bill.status == Status.loading
            ? const CustomProgressIndicator()
            : params.bill.status == Status.success
            ? Column(
          children: [
            Expanded(
              child: _InvoicePersonalDetailsForm(state: this),
            ),
            CreateEditButtons(
              onCancelTap: () => _onCloseTap(this),
              onSaveTap: () => _onSaveTap(this),
              isEdit: true,
            ),
          ],
        )
            : ErrorWidgetWithButton(
          onPressed: () => _getBill(this),
          error: params.bill.error.errorMessage,
        ),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}