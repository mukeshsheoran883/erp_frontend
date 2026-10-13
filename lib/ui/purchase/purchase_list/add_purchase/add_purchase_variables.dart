import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/purchase/purchase_model.dart';

class AddPurchaseParams {
  ApiParam<PurchaseEditModel> purchase = ApiParam<PurchaseEditModel>();
  TextFieldParam purchaseBillNumberField = TextFieldParam();
  DropDownParam<AddEditPurchaseModel> purchaseList = DropDownParam(options: []);
  DropDownParam<CommonKeyValueModel> supplier = DropDownParam(options: []);

  List<FormParam> allParams() => [purchaseBillNumberField, purchase, purchaseList, supplier];
}