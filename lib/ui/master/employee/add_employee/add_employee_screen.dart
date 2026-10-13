
import 'package:invently/assortment/extensions/context_extensions.dart';
import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/extensions/string_extensions.dart';
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
import 'package:invently/models/shop/shop_model.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/models/user/employee_permission_model.dart';
import 'package:invently/models/user/employee_permissions.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/network/employee_service.dart';
import 'package:invently/network/shops_service.dart';
import 'package:invently/ui/master/employee/add_employee/add_employee_variables.dart';
import 'package:invently/ui/master/employee/add_employee/widgets/expansion_tile.dart';
import 'package:invently/utils/static_keys.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/choice_chip_field.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/custom_tab_bar/custom_tab_bar.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/form_widgets/country_drop_down.dart';
import 'package:invently/widgets/form_widgets/file_picker_and_display_widget.dart';
import 'package:invently/widgets/form_widgets/phone_number_field.dart';
import 'package:invently/widgets/form_widgets/state_drop_down.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:collection/collection.dart';
import 'package:fast_validator/fast_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

part 'add_employee_functions.dart';
part 'widgets/employee_access_form.dart';
part 'widgets/employee_permission_form.dart';
part 'widgets/employee_personal_details_form.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final String? employeeCode;

  const AddEditEmployeeScreen({super.key, required this.employeeCode});

  @override
  State<AddEditEmployeeScreen> createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  TabController? tabController;

  AddEmployeeParams params = AddEmployeeParams();

  @override
  void initState() {
    _getEmployee(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs(
        [
          AppRoutes.master,
          AppRoutes.employee,
          if (widget.employeeCode == null)
            AppRoutes.employeeAdd
          else
            AppRoutes.employeeEdit(data: AddEditEmployeeScreen(employeeCode: widget.employeeCode)),
        ],
      );
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
        child: params.employee.status == Status.loading
            ? const CustomProgressIndicator()
            : params.employee.status == Status.success
                ? CustomTabBar(
                    onControllerCreated: (a) => tabController = a,
                    titles: const ['Personal', 'Shop Access', 'Permissions'],
                    tabs: [
                      _EmployeePersonalDetailsForm(state: this),
                      _EmployeeAccessForm(state: this),
                      _EmployeePermissionForm(state: this),
                    ],
                    endWidget: CreateEditButtons(
                      onCancelTap: () => _onCloseTap(this),
                      onSaveTap: () => _onSaveTap(this),
                      isEdit: widget.employeeCode != null,
                    ),
                  )
                : ErrorWidgetWithButton(onPressed: () => _getEmployee(this), error: params.employee.error.errorMessage),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
