import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/purchase/stock_available_model.dart';
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

class AddStockAvailableVariables {
  ApiParam<StockAvailableModel> stockAvailable = ApiParam<StockAvailableModel>();
  DropDownParam<StockAvailableItemModel> stockAvailableList = DropDownParam(options: []);
  TextFieldParam sellingPrice = TextFieldParam();
  TextFieldParam vendorCost = TextFieldParam();
  DateTimeParam createdON = DateTimeParam();
  DateTimeParam expiryDate = DateTimeParam();
  TextFieldParam quantity = TextFieldParam();
  DropDownListenableParam<CommonKeyValueModel> unit =
      DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier(UnitModel.allUnits));

  TextFieldParam purchaseId = TextFieldParam();
  DropDownParam<CommonKeyValueModel> items = DropDownParam(options: []);

  List<FormParam> allParams() => [
        stockAvailable,
        stockAvailableList,
        sellingPrice,
        vendorCost,
        createdON,
        expiryDate,
        quantity,
        unit,
        purchaseId,
        items,
      ];
}
