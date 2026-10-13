import 'package:invently/assortment/extensions/date_time_extensions.dart';
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/stock_available_model.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/network/stock_available_service.dart';
import 'package:invently/provider/purchase/stock_available_provider.dart';
import 'package:invently/ui/purchase/stock_available/add_stock_available/add_stock_available_variables.dart';
import 'package:invently/ui/purchase/stock_available/add_stock_available/widget/add_stock_available_tile.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/alert_bottom_buttons.dart';
import 'package:invently/widgets/alert_dialog/api_search_drop_down.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/date_time_picker/date_time_field.dart';
import 'package:invently/widgets/date_time_picker/date_time_picker.dart';
import 'package:invently/widgets/form_widgets/search_selection_popup/search_popup_text_field.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/page_header_container.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widget/add_stock_available_functions.dart';

part 'widget/stock_available_details_form.dart';

class AddEditStockAvailableScreen extends StatefulWidget {
  final String? stockAvailableCode;

  const AddEditStockAvailableScreen({super.key, required this.stockAvailableCode});

  @override
  State<AddEditStockAvailableScreen> createState() => _AddEditStockAvailableScreenState();
}

class _AddEditStockAvailableScreenState extends State<AddEditStockAvailableScreen> {
  AddStockAvailableVariables params = AddStockAvailableVariables();
  late StockAvailableProvider provider;

  @override
  void initState() {
    _getStockAvailable(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.purchase,
        AppRoutes.stockAvailableList,
        if (widget.stockAvailableCode == null)
          AppRoutes.stockAvailableAdd
        else
          AppRoutes.stockAvailableEdit(
            data: AddEditStockAvailableScreen(stockAvailableCode: widget.stockAvailableCode),
          ),
      ]);
    });
    provider = context.read<StockAvailableProvider>();
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
      child: params.stockAvailable.status == Status.loading
          ? const CustomProgressIndicator()
          : params.stockAvailable.status == Status.success
              ? _StockAvailableDetailsForm(state: this)
              : ErrorWidgetWithButton(
                  onPressed: () => _getStockAvailable(this),
                  error: params.stockAvailable.error.errorMessage,
                ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
