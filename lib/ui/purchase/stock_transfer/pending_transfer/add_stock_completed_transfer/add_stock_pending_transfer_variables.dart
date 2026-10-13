import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/purchase/stock_pending_transfer_model.dart';

class AddStockPendingTransferParams {
  ApiParam<StockPendingTransferModel> returnedPurchase = ApiParam<StockPendingTransferModel>();
  DropDownParam<StockPendingTransferItemModel> returnedPurchaseList = DropDownParam(options: []);

  List<FormParam> allParams() => [returnedPurchase, returnedPurchaseList];
}
