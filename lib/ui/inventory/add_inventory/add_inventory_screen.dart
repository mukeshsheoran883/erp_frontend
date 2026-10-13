import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/inventory/inventory_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/stock_available_service.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/ui/inventory/add_inventory/add_inventory_params.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/price_text_field.dart';
import 'package:flutter/material.dart';

part 'widget/add_inventory_functions.dart';

part 'widget/inventory_details_form.dart';

class AddEditInventoryScreen extends StatefulWidget {
  final String? inventoryCode;
  final String? inventoryName;

  const AddEditInventoryScreen(
      {super.key, required this.inventoryCode, required this.inventoryName});

  @override
  State<AddEditInventoryScreen> createState() => _AddEditInventoryScreenState();
}

class _AddEditInventoryScreenState extends State<AddEditInventoryScreen> {
  AddInventoryParams params = AddInventoryParams();

  @override
  void initState() {
    _getInventory(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.inventory,
        AppRoutes.inventoryList,
        if (widget.inventoryCode == null)
          AppRoutes.inventoryAdd
        else
          AppRoutes.inventoryEdit(
              data: AddEditInventoryScreen(
            inventoryCode: widget.inventoryCode,
            inventoryName: widget.inventoryName,
          )),
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
        child: params.inventory.status == Status.loading
            ? const CustomProgressIndicator()
            : params.inventory.status == Status.success
                ? Column(
                    children: [
                      Expanded(child: _InventoryDetailsForm(state: this)),
                      CreateEditButtons(
                        onCancelTap: () => _onCloseTap(this),
                        onSaveTap: () => _onSaveTap(this),
                        isEdit: true,
                      ),
                    ],
                  )
                : ErrorWidgetWithButton(
                    onPressed: () => _getInventory(this),
                    error: params.inventory.error.errorMessage),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
