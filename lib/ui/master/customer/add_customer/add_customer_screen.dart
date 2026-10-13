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
import 'package:invently/network/common_api_services.dart';
import 'package:invently/network/customer/customer_service.dart';
import 'package:invently/ui/master/customer/add_customer/add_customer_variables.dart';
import 'package:invently/utils/static_keys.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/form_widgets/country_drop_down.dart';
import 'package:invently/widgets/form_widgets/file_picker_and_display_widget.dart';
import 'package:invently/widgets/form_widgets/phone_number_field.dart';
import 'package:invently/widgets/form_widgets/state_drop_down.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

part 'widget/add_customer_functions.dart';
part 'widget/customer_personal_details.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final String? customerCode;

  const AddEditCustomerScreen({
    super.key,
    required this.customerCode,
  });

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  TabController? tabController;

  AddCustomerParams params = AddCustomerParams();

  @override
  void initState() {
    _getCustomer(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.master, AppRoutes.customers, AppRoutes.customersAdd]);
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
        child: params.customer.status == Status.loading
            ? const CustomProgressIndicator()
            : params.customer.status == Status.success
                ? Column(
                    children: [
                      Expanded(
                        child: _CustomerPersonalDetailsForm(state: this),
                      ),
                      CreateEditButtons(
                        onCancelTap: () => _onCloseTap(this),
                        onSaveTap: () => _onSaveTap(this),
                        isEdit: true,
                      ),
                    ],
                  )
                : ErrorWidgetWithButton(
                    onPressed: () => _getCustomer(this),
                    error: params.customer.error.errorMessage,
                  ),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
