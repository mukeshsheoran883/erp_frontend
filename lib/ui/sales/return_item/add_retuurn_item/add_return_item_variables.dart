import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/sales/return_item_model.dart';

class AddReturnParams {
  ApiParam<ReturnItemModel> returnItem = ApiParam<ReturnItemModel>();
  TextFieldParam purchaseBillNumberField = TextFieldParam();
  DropDownParam<CommonKeyValueModel> supplier = DropDownParam(options: []);
  CommonKeyValueParam item = CommonKeyValueParam();
  TextFieldParam returnReason = TextFieldParam();
  TextFieldParam quantity = TextFieldParam()..reset('1');
  TextFieldParam price = TextFieldParam();
  TextFieldParam tax = TextFieldParam();

  List<FormParam> allParams() => [
    purchaseBillNumberField,
    returnItem,
    supplier,
    item,
    returnReason,
    quantity,
    price,
    tax,
  ];
}