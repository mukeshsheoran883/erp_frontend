import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/purchase/purchase_model.dart';
import 'package:invently/models/purchase/stock_pending_transfer_model.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/network/stock_pending_transfer_service.dart';
import 'package:invently/provider/purchase/stock_pending_transfer_provider.dart';
import 'package:invently/ui/purchase/stock_transfer/pending_transfer/add_stock_completed_transfer/add_stock_pending_transfer_variables.dart';
import 'package:invently/ui/purchase/stock_transfer/pending_transfer/add_stock_completed_transfer/widget/add_stock_pending_transfer_tile.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/page_header_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

part 'widget/add_stock_pending_transfer_functions.dart';
part 'widget/stock_pending_transfer_details_form.dart';

class AddEditStockPendingTransferScreen extends StatefulWidget {
  final String? stockPendingTransferCode;

  const AddEditStockPendingTransferScreen({super.key, required this.stockPendingTransferCode});

  @override
  State<AddEditStockPendingTransferScreen> createState() => _AddEditStockPendingTransferScreenState();
}

class _AddEditStockPendingTransferScreenState extends State<AddEditStockPendingTransferScreen> {
  AddStockPendingTransferParams params = AddStockPendingTransferParams();
  late StockPendingTransferProvider provider;

  @override
  void initState() {
    _getPurchase(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.purchase,
        AppRoutes.stockTransfer,
        if (widget.stockPendingTransferCode == null)
          AppRoutes.stockTransferAdd
        else
          AppRoutes.stockTransferEdit(
              data: AddEditStockPendingTransferScreen(stockPendingTransferCode: widget.stockPendingTransferCode)),
      ]);
    });
    provider = context.read<StockPendingTransferProvider>();
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
      child: params.returnedPurchase.status == Status.loading
          ? const CustomProgressIndicator()
          : params.returnedPurchase.status == Status.success
          ? _StockPendingTransferDetailsForm(state: this)
          : ErrorWidgetWithButton(
          onPressed: () => _getPurchase(this), error: params.returnedPurchase.error.errorMessage),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
