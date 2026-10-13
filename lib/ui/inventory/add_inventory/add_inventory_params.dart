import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/form_models.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:flutter/material.dart';

class AddInventoryParams {
  ApiParam<InventoryModel> inventory = ApiParam<InventoryModel>();
  DropDownListenableParam<CommonKeyValueModel> item =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DropDownListenableParam<CommonKeyValueModel> shop =
  DropDownListenableParam<CommonKeyValueModel>(options: ValueNotifier([]));
  DateTimeParam expiryDate = DateTimeParam();
  TextFieldParam price = TextFieldParam();
  TextFieldParam balanceQty = TextFieldParam();

  List<FormParam> allParams() => [inventory, item, shop, expiryDate, price, balanceQty];
}