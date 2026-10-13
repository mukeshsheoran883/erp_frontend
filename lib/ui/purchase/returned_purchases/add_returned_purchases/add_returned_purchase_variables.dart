import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/purchase/returned_purchases_model.dart';

class AddReturnedPurchaseParams {
  ApiParam<ReturnedPurchaseModel> returnedPurchase = ApiParam<ReturnedPurchaseModel>();
  DropDownParam<CommonKeyValueModel> purchaseId = DropDownParam(options: []);
  DropDownParam<ReturnedItem> returnedPurchaseList = DropDownParam(options: []);
  DropDownParam<CommonKeyValueModel> item = DropDownParam(options: []);

  List<FormParam> allParams() => [purchaseId, returnedPurchase, returnedPurchaseList, item];
}
