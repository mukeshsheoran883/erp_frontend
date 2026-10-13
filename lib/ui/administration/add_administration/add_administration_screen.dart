import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/extensions/text_formatters.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/utils/file_utils.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/administration/organization_model.dart';
import 'package:invently/models/administration/organization_plan_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/custom_image_model.dart';
import 'package:invently/models/common/file_upload_response_model.dart';
import 'package:invently/network/administration_service.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/ui/administration/add_administration/add_administration_variables.dart';
import 'package:invently/utils/static_keys.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/form_widgets/file_picker_and_display_widget.dart';
import 'package:invently/widgets/form_widgets/phone_number_field.dart';
import 'package:invently/widgets/form_widgets/toggle_button_field.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

part 'widget/add_administration_functions.dart';
part 'widget/administration_details_form.dart';

class AddEditAdministrationScreen extends StatefulWidget {
  final String? administrationCode;

  const AddEditAdministrationScreen({super.key, required this.administrationCode});

  @override
  State<AddEditAdministrationScreen> createState() => _AddEditAdministrationScreenState();
}

class _AddEditAdministrationScreenState extends State<AddEditAdministrationScreen> {
  AddAdministrationParams params = AddAdministrationParams();

  @override
  void initState() {
    _getAdministration(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.administration,
        if (widget.administrationCode == null)
          AppRoutes.administrationAdd
        else
          AppRoutes.administrationEdit(
            data: AddEditAdministrationScreen(administrationCode: widget.administrationCode),
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
        child: params.organization.status == Status.loading
            ? const CustomProgressIndicator()
            : params.organization.status == Status.success
                ? Column(
                    children: [
                      Expanded(child: _AdministrationDetailsForm(state: this)),
                      CreateEditButtons(
                        onCancelTap: () => _onCloseTap(this),
                        onSaveTap: () => _onSaveTap(this),
                        isEdit: widget.administrationCode != null,
                      ),
                    ],
                  )
                : ErrorWidgetWithButton(
                    onPressed: () => _getAdministration(this),
                    error: params.organization.error.errorMessage,
                  ),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
