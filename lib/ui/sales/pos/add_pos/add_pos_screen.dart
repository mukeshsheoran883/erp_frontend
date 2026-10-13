import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/models/pos/pos_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/network/customer/customer_quotation_service.dart';
import 'package:invently/network/customer/customer_service.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/pos/pos_service.dart';
import 'package:invently/ui/sales/pos/add_pos/add_pos_params.dart';
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
import 'package:invently/widgets/text_widget/price_text_field.dart';
import 'package:flutter/material.dart';

part 'widget/add_pos_functions.dart';
part 'widget/pos_details_form.dart';

class AddEditPosScreen extends StatefulWidget {
  final String? posCode;

  const AddEditPosScreen({super.key, required this.posCode});

  @override
  State<AddEditPosScreen> createState() => _AddEditPosScreenState();
}

class _AddEditPosScreenState extends State<AddEditPosScreen> {
  AddPosParams params = AddPosParams();

  // Caches full item objects fetched during search, keyed by itemCode
  static final Map<String, ItemModel> itemCache = {};

  @override
  void initState() {
    _getPos(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.pos,
        AppRoutes.posList,
        if (widget.posCode == null)
          AppRoutes.posAdd
        else
          AppRoutes.posEdit(data: AddEditPosScreen(posCode: widget.posCode)),
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
        child: params.pos.status == Status.loading
            ? const CustomProgressIndicator()
            : params.pos.status == Status.success
            ? Column(
          children: [
            Expanded(child: _PosDetailsForm(state: this)),
            CreateEditButtons(
              onCancelTap: () => _onCloseTap(this),
              onSaveTap: () => _onSaveTap(this),
              isEdit: true,
            ),
          ],
        )
            : ErrorWidgetWithButton(onPressed: () => _getPos(this), error: params.pos.error.errorMessage),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}