import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/utils/file_utils.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/models/category/category_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/custom_image_model.dart';
import 'package:invently/models/common/file_upload_response_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/models/supplier/supplier_model.dart';
import 'package:invently/models/tax/tax_model.dart';
import 'package:invently/network/brand_service.dart';
import 'package:invently/network/category_service.dart';
import 'package:invently/network/common_api_services.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/network/tax_service.dart';
import 'package:invently/ui/master/items/add_items/add_items_variables.dart';
import 'package:invently/utils/static_keys.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/form_widgets/file_picker_and_display_widget.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/price_text_field.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

part 'widget/add_item_functions.dart';
part 'widget/item_details_form.dart';

class AddEditItemScreens extends StatefulWidget {
  final String? itemCode;

  const AddEditItemScreens({super.key, required this.itemCode});

  @override
  State<AddEditItemScreens> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreens> {
  TabController? tabController;

  AddItemsParams params = AddItemsParams();

  @override
  void initState() {
    _getItem(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([AppRoutes.master, AppRoutes.items, AppRoutes.itemAdd]);
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
        child: params.item.status == Status.loading
            ? const CustomProgressIndicator()
            : params.item.status == Status.success
                ? Column(
                    children: [
                      Expanded(
                        child: _ItemDetailsForm(state: this),
                      ),
                      CreateEditButtons(
                        onCancelTap: () => _onCloseTap(this),
                        onSaveTap: () => _onSaveTap(this),
                        isEdit: true,
                      ),
                    ],
                  )
                : ErrorWidgetWithButton(onPressed: () => _getItem(this), error: params.item.error.errorMessage),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
