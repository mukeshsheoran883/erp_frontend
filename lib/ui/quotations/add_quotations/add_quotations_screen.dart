import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/administration/organization_model.dart';
import 'package:invently/models/administration/organization_plan_model.dart';
import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/models/quotations/quotations_model.dart';
import 'package:invently/models/supplier/supplier_model.dart';
import 'package:invently/network/administration_service.dart';
import 'package:invently/network/brand_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/quotations/quotations_service.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/ui/quotations/add_quotations/add_quotations_params.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

part 'widget/add_quotation_functions.dart';
part 'widget/quotation_details_form.dart';

class AddEditQuotationsScreen extends StatefulWidget {
  final String? quotationsCode;

  const AddEditQuotationsScreen({super.key, required this.quotationsCode});

  @override
  State<AddEditQuotationsScreen> createState() => _AddEditQuotationsScreenState();
}

class _AddEditQuotationsScreenState extends State<AddEditQuotationsScreen> {
  AddQuotationsParams params = AddQuotationsParams();

  @override
  void initState() {
    _getQuotation(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.quotations,
        if (widget.quotationsCode == null)
          AppRoutes.quotationsAdd
        else
          AppRoutes.quotationsEdit(data: AddEditQuotationsScreen(quotationsCode: widget.quotationsCode)),
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
        child: params.quotation.status == Status.loading
            ? const CustomProgressIndicator()
            : params.quotation.status == Status.success
            ? Column(
          children: [
            Expanded(child: _QuotationDetailsForm(state: this)),
            CreateEditButtons(
              onCancelTap: () => _onCloseTap(this),
              onSaveTap: () => _onSaveTap(this),
              isEdit: true,
            ),
          ],
        )
            : ErrorWidgetWithButton(onPressed: () => _getQuotation(this), error: params.quotation.error.errorMessage),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}